# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Good-lookin' diffs. Actually... nah... The best-lookin' diffs."
HOMEPAGE="https://github.com/so-fancy/${PN}"
SRC_URI="https://github.com/so-fancy/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"

RDEPEND="dev-vcs/git
	dev-lang/perl"

src_compile() { :; }

src_install() {
	dobin diff-so-fancy
	exeinto /usr/bin/lib
	doexe lib/DiffHighlight.pm
}
