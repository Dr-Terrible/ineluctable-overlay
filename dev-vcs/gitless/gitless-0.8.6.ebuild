# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )
inherit distutils-r1

DOCS_COMMIT="dded8f00d4233ad8f284f288479f8a23dd92c91c"

DESCRIPTION="A version control system built on top of Git"
HOMEPAGE="https://gitless.com"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	doc? ( https://github.com/sdg-mit/${PN}/archive/${DOCS_COMMIT}.tar.gz -> ${P}-docs.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-python/sh[${PYTHON_USEDEP}]
	dev-python/clint[${PYTHON_USEDEP}]
	dev-python/pygit2[${PYTHON_USEDEP}]
	dev-vcs/git"

src_install() {
	distutils-r1_src_install

	if use doc; then
		pushd "${WORKDIR}/${PN}-${DOCS_COMMIT}" || die
			dohtml -r .
		popd || die
	fi
}
