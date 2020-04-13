# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit bash-completion-r1

DESCRIPTION="Run tasks in parallel and display pretty output as they complete"
HOMEPAGE="https://github.com/themattrix/${PN}"
SRC_URI="https://github.com/themattrix/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=app-shells/bash-4.0:0
	sys-apps/coreutils
	sys-libs/ncurses
	sys-apps/sed"

src_install() {
	insinto $(get_bashhelpersdir)
	doins concurrent.lib.sh
}
