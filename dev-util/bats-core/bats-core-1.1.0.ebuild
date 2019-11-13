# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An automated testing system for bash"
HOMEPAGE="https://github.com/${PN}/${PN}"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="test"

RDEPEND="!dev-util/bats
	app-shells/bash"

PATCHES=( "${FILESDIR}"/install.patch )

DOCS=( AUTHORS README.md)

src_test() {
	bin/bats --tap test || die "Tests failed"
}

src_install() {
	./install.sh "${D}/${EPREFIX}/usr" || die
	einstalldocs
}
