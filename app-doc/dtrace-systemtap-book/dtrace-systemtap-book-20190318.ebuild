# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit python-any-r1 scons-utils

MY_PN="${PN//systemtap/stap}"
EGIT_COMMIT="9e2d33078079224c145a4b95ea80d19b02a6d182"

DESCRIPTION="Dynamic Tracing with DTrace and SystemTap"
HOMEPAGE="http://myaut.github.io/dtrace-stap-book"
SRC_URI="https://github.com/myaut/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep '>=dev-python/lesscpy-0.13.0[${PYTHON_USEDEP}]')
	$(python_gen_any_dep 'dev-python/PyPDF2[${PYTHON_USEDEP}]')
	$(python_gen_any_dep 'dev-python/reportlab[${PYTHON_USEDEP}]')
	media-gfx/inkscape"

RESTRICT="binchecks strip test mirror"

src_compile() {
	# Inkscape is used to generate/convert svg files.
	# Inkscape uses g_get_user_config_dir(), which in turn
	# uses XDG_CONFIG_HOME to get the config directory for this
	# user. See bug 463380
	export XDG_CONFIG_HOME="${T}/inkscape_home"
	escons
}

src_install() {
	# clean out md/scons files before installing
	find . \( \
		-iname '*.md' -o \
		-iname '*.less' -o \
		-iname 'SConscript' -o \
		-iname '*.svg' \) \
		-delete || die

	pushd build/book || die
		local HTML_DOCS=( . )
		einstalldocs
	popd || die
}
