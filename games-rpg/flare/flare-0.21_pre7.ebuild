# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils gnome2-utils

EGIT_PN="${PN}-game"
EGIT_COMMIT="4e586dea9867b3e236af621d156f109b59fa78f8"

DESCRIPTION="Free/Libre Action Roleplaying game"
HOMEPAGE="https://github.com/clintbellanger/flare-game"
SRC_URI="https://github.com/clintbellanger/${EGIT_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${EGIT_PN}-${EGIT_COMMIT}.tar.gz"

LICENSE="CC-BY-SA-3.0 GPL-2 GPL-3 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="~games-engines/${P}"

S="${WORKDIR}/${EGIT_PN}-${EGIT_COMMIT}"
DOCS=()

src_configure() {
	local mycmakeargs=(
		-DBINDIR="/usr/bin"
		-DDATADIR="/usr/share/${PN}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	games_make_wrapper "flare-game" "flare --game=flare-game"
	make_desktop_entry "flare-game" "Flare (game)"

	docinto game
	dodoc README
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
