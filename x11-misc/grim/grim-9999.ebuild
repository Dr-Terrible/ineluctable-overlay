# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 meson

DESCRIPTION="Grab images from a Wayland compositor "
HOMEPAGE="https://github.com/emersion/grim"

EGIT_REPO_URI="https://github.com/emersion/grim.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND="
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	x11-libs/cairo
"

DEPEND="${RDEPEND}
	doc? ( app-text/scdoc )
"
