# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker xdg

DESCRIPTION="One music sequencer for all major platforms, desktop and mobile"
HOMEPAGE="https://helio.fm"
SRC_URI="amd64? ( https://ci.helio.fm/helio-${PV}-x64.deb )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="net-misc/curl[curl_ssl_gnutls(+)]"

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
