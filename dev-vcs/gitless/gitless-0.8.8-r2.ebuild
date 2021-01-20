# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1

DOCS_COMMIT="99c45d20ea27ff83cb379b24663ae8292dde60cf"

DESCRIPTION="A version control system built on top of Git"
HOMEPAGE="https://gitless.com https://github.com/gitless-vcs/gitless"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	doc? ( https://github.com/gitless-vcs/${PN}/archive/${DOCS_COMMIT}.tar.gz -> ${P}-docs.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="$(python_gen_cond_dep '
		dev-python/sh[${PYTHON_USEDEP}]
		~dev-python/clint-0.5.1[${PYTHON_USEDEP}]
		dev-python/pygit2:=[${PYTHON_USEDEP}]
	')
	dev-vcs/git"

PATCHES=(
	"${FILESDIR}"/pygit2-1.1.1.patch
)

#python_prepare_all() {
#	# Loosen requirements
#	sed -e 's|==|>=|' -i requirements.txt || die
#
#	distutils-r1_python_prepare_all
#}

src_install() {
	distutils-r1_src_install

	if use doc; then
		pushd "${WORKDIR}/${PN}-${DOCS_COMMIT}" || die
			docinto html
			dodoc -r .
		popd || die
	fi
}
