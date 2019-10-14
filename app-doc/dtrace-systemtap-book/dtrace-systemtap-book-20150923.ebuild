# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit python-any-r1 scons-utils

MY_PN="${PN//systemtap/stap}"
EGIT_COMMIT="5b4259f6228955e74a9a0d9030563916328928e0"

DESCRIPTION="Dynamic Tracing with DTrace and SystemTap"
HOMEPAGE="http://myaut.github.io/dtrace-stap-book"
SRC_URI="https://github.com/myaut/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/lesscpy[${PYTHON_USEDEP}]')
	media-gfx/inkscape"

RESTRICT="binchecks strip test mirror"

#pkg_setup() {
#	python-any-r1_pkg_setup
#}

src_compile() {
	escons
}

src_install() {
	dodoc -r build/*
}
