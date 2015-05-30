# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base systemd

GITHUB_SRC="https://github.com/${PN}/${PN}/releases/download/v${PV}/${PN}-linux-ARCH-v${PV}.tar.gz"

DESCRIPTION="Syncthing is an application that lets you synchronize your files across multiple devices"
HOMEPAGE="http://syncthing.net"
SRC_URI=" x86? ( ${GITHUB_SRC//ARCH/386} )
	amd64? ( ${GITHUB_SRC//ARCH/amd64} )
	arm? ( ${GITHUB_SRC//ARCH/arm} )"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="doc systemd"

RESTRICT="mirror"

RDEPEND="systemd? ( >=sys-apps/systemd-219 )"

DOCS=(
	"${S}/FAQ.pdf"
	"${S}/Getting-Started.pdf"
)

_unpack() {
	mv "${WORKDIR}"/${PN}-linux-${1}-v${PV}/* "${S}" || die
	rm -r "${WORKDIR}"/${PN}-linux-${1}-v${PV} || die
}

src_unpack() {
	unpack ${A}
	mkdir -p "${S}" || die
	use x86 && unpack "386"
	use amd64 && _unpack "amd64"
	use arm && unpack "arm"
}

src_install() {
	dobin "${S}"/${PN}
	use doc && base_src_install_docs

	if use systemd; then
		systemd_newunit "${S}"/etc/linux-systemd/system/${PN}@.service  "${PN}@.service"
		systemd_newuserunit "${S}"/etc/linux-systemd/user/${PN}.service "${PN}.service"
	fi
}