# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 eutils qmake-utils cmake-utils

DESCRIPTION="Cross-platform QtQuick components using Material Design guidelines"
HOMEPAGE="https://github.com/lirios/${PN}"

EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
EGIT_COMMIT="5c32a95be79c088209536b99d51a397f48de4ff4"
#SRC_URI="https://github.com/lirios/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 ~arm x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc demo test"

RDEPEND="dev-qt/qtdeclarative:5"
DEPEND="doc? ( dev-qt/qdoc )"

DOCS=( AUTHORS.md README.md )

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOCDIR="/usr/share/doc/${PF}"
		-DINSTALL_LIBDIR=$( qt5_get_libdir )
		-DINSTALL_LIBEXECDIR=$( qt5_get_libdir )
		-DINSTALL_QMLDIR=$( qt5_get_libdir )/qt5/qml
		-DINSTALL_PLUGINSDIR=$( qt5_get_plugindir )
		-DFLUID_WITH_DOCUMENTATION=$(usex doc ON OFF)
		-DFLUID_WITH_DEMO=$(usex demo ON OFF)
		-DBUILD_TESTING=$(usex test ON OFF)
		-DFLUID_WITH_QML_MODULES=ON
	)

	cmake-utils_src_configure
}
