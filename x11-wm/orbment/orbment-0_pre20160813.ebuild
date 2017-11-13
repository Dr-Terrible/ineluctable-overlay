# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils

ORBMENT_ECOMMIT="01dcfff9719e20261a6d8c761c0cc2f8fa0d0de5"
CHCK_ECOMMIT="2efd6cd314884712e9409e54c302afb9b9fff1b0"
INIHCK_ECOMMIT="312c57e74b54582e7e6968e622bb9df09205428b"

DESCRIPTION="Orbment is a dynamic window manager and compositor for Wayland"
HOMEPAGE="https://github.com/Cloudef/${PN}"
SRC_URI="https://github.com/Cloudef/${PN}/archive/${ORBMENT_ECOMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/Cloudef/chck/archive/${CHCK_ECOMMIT}.tar.gz -> chck-${CHCK_ECOMMIT}.tar.gz
	https://github.com/Cloudef/inihck/archive/${INIHCK_ECOMMIT}.tar.gz -> inihck-${INIHCK_ECOMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

S="${WORKDIR}/${PN}-${ORBMENT_ECOMMIT}"

RDEPEND="dev-libs/libinput:0/10
	dev-libs/wlc:0
	media-libs/libpng:0/16
	sys-libs/zlib:0
	x11-libs/libxkbcommon:0"
DEPEND="virtual/pkgconfig"

src_prepare() {
	rmdir "${S}"/lib/chck || die
	mv "${WORKDIR}"/chck-${CHCK_ECOMMIT} "${S}"/lib/chck || die

	rmdir "${S}"/lib/inihck || die
	mv "${WORKDIR}"/inihck-${INIHCK_ECOMMIT} "${S}"/lib/inihck || die

	default
}
