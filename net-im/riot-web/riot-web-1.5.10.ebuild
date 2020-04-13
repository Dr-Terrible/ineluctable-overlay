# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_64 )

inherit multilib-build pax-utils unpacker xdg-utils

QA_PREBUILT="
	opt/Riot/swiftshader/libEGL.so
	opt/Riot/swiftshader/libGLESv2.so
	opt/Riot/swiftshader/libvk_swiftshader.so
	opt/Riot/riot-web
	opt/Riot/libffmpeg.so
	opt/Riot/libGLESv2.so
	opt/Riot/libEGL.so
"

DESCRIPTION="A glossy Matrix collaboration client for desktop"
HOMEPAGE="https://riot.im"
SRC_URI="amd64? ( https://riot.im/packages/debian/pool/main/r/riot-web/riot-web_${PV}_amd64.deb )"

RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="pax_kernel"

RDEPEND="app-accessibility/at-spi2-atk:2[${MULTILIB_USEDEP}]
	app-accessibility/at-spi2-core:2[${MULTILIB_USEDEP}]
	dev-libs/atk:0[${MULTILIB_USEDEP}]
	dev-libs/expat:0[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr:0[${MULTILIB_USEDEP}]
	dev-libs/nss:0[${MULTILIB_USEDEP}]
	media-libs/alsa-lib:0[${MULTILIB_USEDEP}]
	net-print/cups:0[${MULTILIB_USEDEP}]
	sys-apps/dbus:0[${MULTILIB_USEDEP}]
	sys-apps/util-linux:0[${MULTILIB_USEDEP}]
	x11-libs/cairo:0[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libX11:0[${MULTILIB_USEDEP}]
	x11-libs/libxcb:0[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite:0[${MULTILIB_USEDEP}]
	x11-libs/libXcursor:0[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:0[${MULTILIB_USEDEP}]
	x11-libs/libXext:0[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:0[${MULTILIB_USEDEP}]
	x11-libs/libXi:0[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:0[${MULTILIB_USEDEP}]
	x11-libs/libXrender:0[${MULTILIB_USEDEP}]
	x11-libs/libXScrnSaver:0[${MULTILIB_USEDEP}]
	x11-libs/libXtst:0[${MULTILIB_USEDEP}]
	x11-libs/pango:0[${MULTILIB_USEDEP}]"

S="${WORKDIR}"

src_prepare() {
	default

	# disable auto-update
	sed -i 's|https://packages.riot.im/desktop/update/|null|g' \
		opt/Riot/resources/webapp/config.json || die
}

src_install() {
	insinto /opt
	doins -r opt/*

	insinto /usr/
	doins -r usr/*

	fperms +x /opt/Riot/riot-web
	dosym ../../opt/Riot/${PN} /usr/bin/riot-web
	use pax_kernel && pax-mark -m "${ED%/}"/opt/Riot/riot-web
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
