# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils qmake-utils

DESCRIPTION="Material Design implemented in QML"
HOMEPAGE="http://papyros.io"
SRC_URI="https://github.com/papyros/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
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

PATCHES=(
	 "${FILESDIR}"/${PN}-doc.patch
)

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs

	# Install HTML documentation
	if use doc; then
		pushd documentation
			mkdir html || die
			QT_SELECT="qt5" qdoc \
				material.qdocconf || die
			dodoc -r html
		popd
	fi

	# remove bundled fonts
	rm -r "${ED}"/$( qt5_get_libdir )/qt5/qml/Material/fonts/roboto || die
}
