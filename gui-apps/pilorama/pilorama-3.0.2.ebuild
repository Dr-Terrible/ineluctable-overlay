# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit xdg qmake-utils

DESCRIPTION="Advanced Timeboxing Tool"
HOMEPAGE="https://pilorama.app https://github.com/eplatonoff/${PN}"
SRC_URI="https://github.com/eplatonoff/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtsvg:5
	dev-qt/qtxml:5
"

DOCS=( README.md )

src_prepare() {
	default

	# Fix wrong version declarations
	sed -e "s/3.0.1/${PV}/g" -i \
		src/${PN}.desktop \
		src/${PN}.pro \
		 || die
}

src_configure() {
	eqmake5 src/${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs

	# install desktop files
	insinto /usr/share/applications
	doins src/*.desktop

	# install icons
	insinto /usr/share/icons
	doins -r src/assets/app_icons/hicolor/
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
