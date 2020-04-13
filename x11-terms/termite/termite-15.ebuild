# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

UTIL_COMMIT="62faf9e46b8c4ab213ac42aaf6343dea9e2dfc1e"

DESCRIPTION="A keyboard-centric terminal aimed at use within a tiling window manager"
HOMEPAGE="https://github.com/thestinger/${PN}"
SRC_URI="https://github.com/thestinger/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/thestinger/util/archive/${UTIL_COMMIT}.tar.gz -> ${P}-util.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

RDEPEND="x11-libs/vte:2.91[termite(-)]"

RESTRICT="strip mirror"

src_unpack() {
	default
	mv "${WORKDIR}"/util-${UTIL_COMMIT}/* "${S}"/util/ || die
}

src_compile() {
	#append-ldflags -Wl,-rpath="${EROOT%/}/usr/$(get_libdir)/${VTE_NAME}"
	emake VERSION="v${PV}"
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
