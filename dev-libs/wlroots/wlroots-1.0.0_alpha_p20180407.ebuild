# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 meson

DESCRIPTION="A modular Wayland compositor library"
HOMEPAGE="https://github.com/swaywm/wlroots"

EGIT_REPO_URI="https://github.com/swaywm/wlroots"
EGIT_COMMIT="ba5c0903f9c288e7b617e537ef80eed2a42e08ed"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="caps elogind systemd xcb-errors xwayland X"

DEPEND="
>=dev-libs/wayland-protocols-1.12
>=media-libs/mesa-17.1.0[egl,gles2,gbm,wayland]
dev-libs/libinput
dev-libs/wayland
virtual/libudev
x11-libs/libdrm
x11-libs/libxkbcommon
x11-libs/pixman
caps? ( sys-libs/libcap )
elogind? ( sys-auth/elogind )
systemd? ( sys-apps/systemd )
xwayland? (
	x11-base/xorg-server[wayland]
	x11-libs/libxcb
	x11-proto/xcb-proto
)
X? (
	x11-libs/libxcb
	x11-proto/xcb-proto
)
"

RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		-Denable-elogind=$(usex elogind true false)
		-Denable-libcap=$(usex caps true false)
		-Denable-systemd=$(usex systemd true false)
		-Denable-x11_backend=$(usex X true false)
		-Denable-xcb_errors=$(usex xcb-errors true false)
		-Denable-xwayland=$(usex xwayland true false)
	)
	meson_src_configure
}
