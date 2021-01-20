# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker xdg

DESCRIPTION="A minimal Markdown reading & writing app"
HOMEPAGE="https://typora.io"
SRC_URI="https://www.typora.io/linux/typora_${PV}_amd64.deb"

LICENSE="EULA"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="x11-libs/libXScrnSaver"

S="${WORKDIR}"

RESTRICT="strip mirror"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	mv "${S}"/* "${D}" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
