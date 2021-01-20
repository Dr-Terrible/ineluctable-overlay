# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Prevents you from committing secrets and credentials into git repositories"
HOMEPAGE="https://github.com/awslabs/git-secrets"
SRC_URI="https://github.com/awslabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm x86"

RESTRICT+=" mirror"

RDEPEND="dev-vcs/git"

DOCS=(README.rst NOTICE.txt LICENSE.txt CHANGELOG.md)

src_compile() {
	# we skip this because the first target of the
	# Makefile is "install" and plain "make" would
	# actually run "make install"
	:;
}

src_install() {
	DESTDIR="${D}" PREFIX="/usr" default
}
