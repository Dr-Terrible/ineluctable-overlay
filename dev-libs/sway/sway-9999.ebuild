# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="http://swaywm.org/"

EGIT_REPO_URI="https://github.com/swaywm/sway"

LICENSE="MIT"
SLOT="0"
IUSE="doc elogind systemd wallpapers zsh-completion"

RDEPEND="
	=dev-libs/wlroots-9999[xwayland]
	>=dev-libs/json-c-0.13:=
	>=dev-libs/libinput-1.6.0
	dev-libs/libpcre
	dev-libs/wayland
	dev-libs/wayland-protocols
	sys-libs/libcap
	virtual/pam
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
"

DEPEND="${RDEPEND}
doc? ( app-text/asciidoc )
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
