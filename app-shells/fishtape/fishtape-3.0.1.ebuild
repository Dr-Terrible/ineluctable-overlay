# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fishtape is a Test Anything Protocol compliant test runner for Fish"
HOMEPAGE="https://github.com/jorgebucaran/${PN}"
SRC_URI="https://github.com/jorgebucaran/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

RDEPEND="app-shells/fish"

DDOC=(README.md)

src_install(){
	insinto /usr/share/fish/vendor_completions.d/
	doins completions/${PN}.fish

	insinto /usr/share/fish/vendor_functions.d/
	doins functions/${PN}.fish

	einstalldocs
}
