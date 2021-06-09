# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Execute binaries from Python packages in isolated environments"
HOMEPAGE="https://pipxproject.github.io/pipx"
SRC_URI="https://github.com/pipxproject/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/userpath-1.5.0[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/importlib_metadata-3.3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/mkdocs[${PYTHON_USEDEP}]
	)"
