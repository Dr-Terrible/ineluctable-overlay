# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A program to read and control device brightness"
HOMEPAGE="https://github.com/Hummer12007/${PN}"
SRC_URI="https://github.com/Hummer12007/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="udev systemd"

REQUIRED_USE="^^ ( udev systemd )"

RDEPEND="udev? ( virtual/udev )
systemd? ( sys-apps/systemd )"

src_install() {
	emake DESTDIR="${D}" ENABLE_SYSTEMD="$(usex systemd 1 0)"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_UDEV_RULES="$(usex udev 1 0)" ENABLE_SYSTEMD="$(usex systemd 1 0)" install
}
