# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python3_{4,5,6} )
inherit gnome2 python-any-r1 vala cmake-utils

DESCRIPTION="A simple ebook reader originally intended for Elementary OS"
HOMEPAGE="http://babluboy.github.io/bookworm"
SRC_URI="https://github.com/babluboy/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~arm"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug"

DEPEND="${PYTHON_DEPS}
	$(vala_depend)
	dev-libs/glib:2
	>=dev-libs/granite-0.5
	dev-libs/libgee:0.8
	dev-libs/libxml2:2
	net-libs/libsoup:2.4
	app-text/poppler[cairo]
	app-arch/unzip
	app-arch/unrar
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango:0
	net-libs/webkit-gtk:4/37
	x11-libs/gtk+:3
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"

pkg_setup(){
	python-any-r1_pkg_setup
}

src_prepare(){
	gnome2_src_prepare
	vala_src_prepare
	default
}

src_configure(){
	local mycmakeargs=(
		-DGSETTINGS_COMPILE="OFF"
		-DVALA_EXECUTABLE="$( type -p valac-$(vala_best_api_version) )"
	)
	use debug && mycmakeargs+=(-DCMAKE_BUILD_TYPE="RelWithDebInfo")
	cmake-utils_src_configure
}

pkg_preinst(){
	gnome2_schemas_savelist
}

pkg_postinst(){
	gnome2_gconf_install
	gnome2_schemas_update
}

pkg_postrm(){
	gnome2_gconf_uninstall
	gnome2_schemas_update
}
