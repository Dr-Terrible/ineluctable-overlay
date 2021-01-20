# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit python-any-r1

EGIT_COMMIT="54ac84a76f26b387776dc1e3e66e042f9e7c77f4"

DESCRIPTION="Game Programming Patterns"
HOMEPAGE="http://gameprogrammingpatterns.com"
SRC_URI="https://github.com/munificent/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

PATCHES=( ${FILESDIR}/python3.patch )

DEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/pygments[${PYTHON_USEDEP}]')
	$(python_gen_any_dep 'dev-python/markdown[${PYTHON_USEDEP}]')
	$(python_gen_any_dep 'dev-python/smartypants[${PYTHON_USEDEP}]')
	>=dev-ruby/sass-3.4.0:3.4"

RESTRICT="binchecks strip test mirror"

src_compile() {
	${PYTHON} script/format.py || die
}

src_install() {
	dodoc -r html
}
