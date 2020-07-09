# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Tasksh is a shell for Taskwarrior"
HOMEPAGE="https://taskwarrior.org"
SRC_URI="https://taskwarrior.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

BDEPEND="sys-libs/readline:0"
RDEPEND="${BDEPEND}
	app-misc/task"

#src_prepare() {
#	cmake-utils_src_prepare
#}

src_configure() {
	local mycmakeargs=(
		-DTASKSH_DOCDIR=share/doc/${PF}
		-DTASKSH_RCDIR=share/${PN}/rc
	)
	cmake_src_configure
}

#src_install() {
#	cmake-utils_src_install
#}
