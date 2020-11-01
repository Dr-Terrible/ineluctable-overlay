# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Debugger for zsh"
HOMEPAGE="https://github.com/rocky/${PN}"
SRC_URI="https://github.com/rocky/${PN}/archive/${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"

RDEPEND="app-shells/zsh"

RESTRICT="mirror"

src_prepare() {
	eautoreconf
	default
}
