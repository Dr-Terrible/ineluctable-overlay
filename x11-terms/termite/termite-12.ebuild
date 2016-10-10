# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs versionator

UTIL_COMMIT="62faf9e46b8c4ab213ac42aaf6343dea9e2dfc1e"

DESCRIPTION="A keyboard-centric terminal aimed at use within a tiling window manager"
HOMEPAGE="https://github.com/thestinger/${PN}"
SRC_URI="https://github.com/thestinger/${PN}/archive/v${PV}.tar.gz -> ${PF}.tar.gz
	https://github.com/thestinger/util/archive/${UTIL_COMMIT}.tar.gz -> ${PF}-util.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

CDEPEND="=x11-libs/vte-0.46.0-r666:2.91"
RDEPEND="$CDEPEND"
DEPEND="$CDEPEND"

RESTRICT="test strip mirror"

PATCHES=(
	"${FILESDIR}/${PN}-vte-deprecated-api.patch"
)

pkg_pretend() {
	if ! version_is_at_least 4.7 $(gcc-version); then
		eerror "${PN} passes -std=c++11 to \${CXX} and requires a version"
		eerror "of gcc newer than 4.7.0"
	fi
}

src_unpack() {
	default
	mv "${WORKDIR}"/util-${UTIL_COMMIT}/* "${S}"/util/ || die
}

src_compile() {
	emake VERSION="${PV}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc README* config
}

pkg_postinst() {
	echo
	elog "Termite looks for a config file at ~/.config/termite/config"
	elog "An example config can be found in ${ROOT}usr/share/doc/${PF}/config"
}
