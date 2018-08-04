# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="A lightweight Wayland notification daemon"
HOMEPAGE="https://mako-project.org/"

SRC_URI="https://github.com/emersion/mako/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND="
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	sys-apps/systemd
	x11-libs/cairo
	x11-libs/pango
"

DEPEND="${RDEPEND}
	doc? ( app-text/scdoc )
"
