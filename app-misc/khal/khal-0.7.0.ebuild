# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="CLI calendar application"
HOMEPAGE="http://lostpackets.de/khal/"
SRC_URI="https://github.com/geier/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://pypi/k/${PN}/${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RESTRICT+=" mirror"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/icalendar[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/vdirsyncer[${PYTHON_USEDEP}]
	dev-lang/python[sqlite]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]"

DEPEND="doc? (
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-newsfeed[${PYTHON_USEDEP}]
)"

DOCS=( AUTHORS.txt CHANGELOG.rst CONTRIBUTING.txt README.rst khal.conf.sample )

src_prepare() {
	# fix documentation build path
	sed -i \
		-e "s:/${PN}/${PN}/:/${PF}/${PN}/:" \
		doc/source/Makefile || die
	distutils-r1_src_prepare
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
