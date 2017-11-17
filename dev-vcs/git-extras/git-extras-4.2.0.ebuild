# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit bash-completion-r1

DESCRIPTION="Little git extras"
HOMEPAGE="https://github.com/tj/git-extras"
SRC_URI="https://github.com/tj/git-extras/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RESTRICT+=" test mirror"

RDEPEND="dev-vcs/git"

src_prepare() {
	default
	sed -i \
		-e "s:\$(DESTDIR)\$(SYSCONFDIR)/bash_completion.d:\$(DESTDIR)$(get_bashcompdir):" \
	Makefile || die
}

src_compile() {
	# we skip this because the first target of the
	# Makefile is "install" and plain "make" would
	# actually run "make install"
	:;
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install fail"
	dodoc Readme.md
}
