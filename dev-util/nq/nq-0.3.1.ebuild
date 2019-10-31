# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Unix command line queue utility"
HOMEPAGE="https://github.com/chneukirchen/nq"
SRC_URI="https://github.com/chneukirchen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"

DOCS=( README.md NEWS.md )

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	einstalldocs
}
