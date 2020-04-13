# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A program to read and control device brightness"
HOMEPAGE="https://github.com/Hummer12007/brightnessctl"

SRC_URI="https://github.com/Hummer12007/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+suid"

src_install() {
	emake DESTDIR="${D}" INSTALL_UDEV_RULES="$(usex suid 0 1)" install
}
