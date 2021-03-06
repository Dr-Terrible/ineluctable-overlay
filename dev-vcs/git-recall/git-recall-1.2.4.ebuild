# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple and handy tool to easily recall what you've done"
HOMEPAGE="https://github.com/Fakerr/git-recall"
SRC_URI="https://github.com/Fakerr/git-recall/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"

RESTRICT+=" test mirror"

RDEPEND="dev-vcs/git
	sys-apps/less"

src_compile() {
	# we skip this because the first target of the
	# Makefile is "install" and plain "make" would
	# actually run "make install"
	:;
}

src_install() {
	emake BINPREFIX="${D}/usr/bin" PREFIX="/usr" install || die "emake install fail"
	dodoc README.md
}
