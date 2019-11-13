# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Node version management"
HOMEPAGE="https://github.com/tj/n"
SRC_URI="https://github.com/tj/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"

RDEPEND="net-misc/curl[http2,ssl,brotli]"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md)

src_compile() { :; }

src_install() {
	emake PREFIX="${D}${EPREFIX}"/usr install

	# Docs
	dodoc -r docs/*
	einstalldocs
}
