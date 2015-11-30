# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit qmake-utils base python-any-r1

EDOC_COMMIT="7787a8677df40da76e66f2aea20567b4ca0434c1"

DESCRIPTION="Material Design implemented in QML"
HOMEPAGE="http://papyros.io"
SRC_URI="https://github.com/papyros/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://github.com/papyros/docmaker/archive/${EDOC_COMMIT}.tar.gz -> ${P}-docmaker.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm"
IUSE+=" doc test"

RESTRICT+=" mirror"

DEPEND="doc? (
		dev-qt/qdoc:5
		dev-python/jinja
		dev-python/pygments
	)"
RDEPEND="dev-qt/qtdeclarative:5
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtgraphicaleffects:5
	media-fonts/roboto"

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	base_src_install INSTALL_ROOT="${D}"
	einstalldocs

	# Install HTML documentation
	if use doc; then
		pushd documentation
			mkdir html || die
			QT_SELECT="qt5" qdoc \
				material.qdocconf || die
			${EPYTHON} "${WORKDIR}"/docmaker-${EDOC_COMMIT}/docmaker.py \
				ditaxml html || die
			dohtml -A dita,index -r html/*
		popd
	fi

	# remove bundled fonts
	rm -r "${ED}"/$( qt5_get_libdir )/qt5/qml/Material/fonts/roboto || die
}