# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user flag-o-matic systemd autotools multilib-minimal

DESCRIPTION="A file watching service"
HOMEPAGE="https://facebook.github.io/watchman"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +pcre ssp libressl doc cxx"

RESTRICT="mirror test"

RDEPEND="pcre? ( dev-libs/libpcre )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	cxx? ( dev-cpp/folly )"
DEPEND="dev-cpp/glog
	doc? (
	>=www-apps/jekyll-3.6.0
	www-apps/jekyll-feed
	www-apps/jekyll-seo-tag
	www-apps/jekyll-sitemap
	dev-ruby/pygments_rb
)"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/empty ${PN}
}

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	STATEDIR="${EPREFIX}/run/${PN}"

	local myconf=(
		--enable-statedir="${STATEDIR}"
		--disable-dependency-tracking
		--without-ruby
		--without-python
		--with-buildinfo=Gentoo
		$(use_with pcre)
		$(use_enable cxx cppclient)
		$(use_enable debug debug)
		$(use_enable ssp stack-protector)
	)
	econf "${myconf[@]}"
}

multilib_src_install_all() {
	prune_libtool_files --all
	rm -r "${ED}"/run || die

	# install init files
	systemd_newunit "${FILESDIR}"/systemd/${PN}.socket ${PN}@.socket
	systemd_newunit "${FILESDIR}"/systemd/${PN}.service ${PN}@.service
	systemd_dotmpfilesd "${FILESDIR}/systemd/${PN}.conf"

	# install doc
	if use doc; then
		jekyll build --source "${S}"/website --destination "${T}"/html || die
		dodoc -r "${T}"/html
	fi
}

pkg_postinst() {
	elog "You must be in the '${PN}' group to use WatchMan."
	elog "Just run (replace <USER> with the desired username):"
	elog "    gpasswd -a <USER> ${PN}"
	elog
	elog "then have <USER> re-login."
	elog
	elog "To instantiate ${PN}'service for a specific user run:"
	elog
	elog "    systemctl enable ${PN}@<USER>.service"
	elog "    systemctl start  ${PN}@<USER>.service"
	elog
	elog "If instead to always run the service at boot-time you prefer to activate"
	elog "it only when it's needed, then instantiate ${PN}'s socket which will"
	elog "activate ${PN}'s service on-demand:"
	elog
	elog "    systemctl disable ${PN}<USER>.service"
	elog "    systemctl stop ${PN}@<USER>.service"
	elog "    systemctl enable ${PN}@<USER>.socket"
	elog "    systemctl start  ${PN}@<USER>.socket"
	elog
	elog "then have <USER> run any ${PN}'s commands by shell to automatically"
	elog "instantiate the service in background:"
	elog
	elog "    watchman version"
	elog
	elog "All the logs are available at ${STATEDIR}/<USER>-state/log."
}
