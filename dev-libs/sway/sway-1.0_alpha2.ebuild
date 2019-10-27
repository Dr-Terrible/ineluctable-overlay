# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="http://swaywm.org/"

UPSTREAM_VERSION="1.0-alpha.2"
SRC_URI="https://github.com/swaywm/${PN}/archive/${UPSTREAM_VERSION}.tar.gz"
S="${WORKDIR}/${PN}-${UPSTREAM_VERSION}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc elogind systemd wallpapers zsh-completion"

RDEPEND="
	>=dev-libs/json-c-0.13:=
	>=dev-libs/libinput-1.6.0
	dev-libs/libpcre
	dev-libs/wayland
	dev-libs/wayland-protocols
	dev-libs/wlroots[xwayland]
	sys-libs/libcap
	virtual/pam
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
"

DEPEND="${RDEPEND}
	doc? ( app-text/scdoc )
"

src_configure() {
	local emesonargs=(
		-Ddefault_wallpaper=$(usex wallpapers true false)
		-Dzsh_completions=$(usex zsh-completion true false)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	!(use elogind || use systemd) && fperms u+s /usr/bin/sway
}

pkg_postinst() {
	(use elogind || use systemd) && setcap "cap_sys_ptrace,cap_sys_tty_config=eip" /usr/bin/sway
}
