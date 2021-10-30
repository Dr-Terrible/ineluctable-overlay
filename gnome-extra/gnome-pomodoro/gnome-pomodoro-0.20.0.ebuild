# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.52"
VALA_USE_DEPEND="vapigen"

inherit vala xdg gnome2-utils meson vala

DESCRIPTION="Time management utility for GNOME based on the pomodoro technique"
HOMEPAGE="https://gnomepomodoro.org https://github.com/${PN}/${PN}"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	x11-libs/gtk+:3[introspection]
	x11-libs/gdk-pixbuf
	dev-libs/libpeas
	dev-libs/gom[introspection]
	gnome-base/gsettings-desktop-schemas
	media-libs/gstreamer
	media-libs/libcanberra
	gnome-base/gnome-desktop:3[introspection]
"
BDEPEND=">=sys-devel/gettext-0.19.8
	$(vala_depend)"

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
	default
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}
