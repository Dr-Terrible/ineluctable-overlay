# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit user python-single-r1 autotools-utils

DESCRIPTION="A file watching service"
HOMEPAGE="https://facebook.github.io/watchman"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +pcre python ssp test doc"

RESTRICT="mirror"

CDEPEND="pcre? ( dev-libs/libpcre )"
DEPEND="${CDEPEND}
	doc? ( www-apps/jekyll )"
RDEPEND="${CDEPEND}"

DOCS=()

pkg_setup() {
	enewgroup ${PN}
}

src_configure() {
	STATEDIR="${EPREFIX}/var/lib/${PN}"

	local myeconfargs=(
		--enable-statedir="${STATEDIR}"
		--disable-dependency-tracking
		--without-ruby
		$(use_with python)
		$(use_with pcre)
		$(use_enable debug lenient)
		$(use_enable ssp stack-protector)
	)
	autotools-utils_src_configure VERSION="${PF}"
}

src_install() {
	autotools-utils_src_install

	# Fix state directory permissions
	keepdir ${STATEDIR}
	fperms -R 0775 ${STATEDIR}
	fowners -R :${PN} ${STATEDIR}

	# install doc
	if use doc; then
		jekyll build --source "${S}"/website --destination "${T}"/html || die
		dohtml -r "${T}"/html/*
	fi
}

pkg_postinst() {
	elog
	elog "You must be in the '${PN}' group to use WatchMan."
	elog "Just run (replace <USER> with the desired username):"
	elog "    gpasswd -a <USER> ${PN}"
	elog
	elog "then have <USER> re-login."
}
