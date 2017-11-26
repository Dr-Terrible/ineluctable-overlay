# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user flag-o-matic systemd autotools multilib-minimal

DESCRIPTION="A file watching service"
HOMEPAGE="https://facebook.github.io/watchman"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +pcre ssp libressl doc"

RESTRICT="mirror test"

RDEPEND="pcre? ( dev-libs/libpcre )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
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
}

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	STATEDIR="${EPREFIX}/var/lib/${PN}"

	local myconf=(
		--enable-statedir="${STATEDIR}"
		--disable-dependency-tracking
		--without-ruby
		--without-python
		--disable-cppclient
		$(use_with pcre)
		$(use_enable debug lenient)
		$(use_enable ssp stack-protector)
	)
	econf "${myconf[@]}"
}

multilib_src_install_all() {
	prune_libtool_files --all

	# Fix state directory permissions
	keepdir ${STATEDIR}
	fperms -R 0775 ${STATEDIR}
	fowners -R :${PN} ${STATEDIR}

	# install init files
	systemd_dounit "${FILESDIR}"/${PN}.socket
	systemd_newunit "${FILESDIR}"/${PN}_at.service ${PN}@.service

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
}
