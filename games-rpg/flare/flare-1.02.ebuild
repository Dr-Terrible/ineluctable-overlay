# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils gnome2-utils

DESCRIPTION="Free/Libre Action Roleplaying game"
HOMEPAGE="https://github.com/clintbellanger/flare-game"
SRC_URI="https://github.com/clintbellanger/flare-game/archive/v${PV}.tar.gz -> ${P}-game.tar.gz"

LICENSE="CC-BY-SA-3.0 GPL-2 GPL-3 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="~games-engines/${P}"

S="${WORKDIR}/${PN}-game-${PV}"
DOCS=()

src_configure() {
	local mycmakeargs=(
		-DBINDIR="/usr/bin"
		-DDATADIR="/usr/share/${PN}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	make_desktop_entry "flare-game" "Flare (game)"
	newdoc README.md README.game.md
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
