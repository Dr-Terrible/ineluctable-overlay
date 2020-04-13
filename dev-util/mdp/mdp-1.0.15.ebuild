# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic

DESCRIPTION="A command-line based markdown presentation tool"
HOMEPAGE="https://github.com/visit1985/mdp"
SRC_URI="https://github.com/visit1985/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"

RDEPEND="sys-libs/ncurses"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS CREDITS README.md )

src_compile() {
	emake LDLIBS="$( pkg-config --libs ncursesw )"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	einstalldocs
}
