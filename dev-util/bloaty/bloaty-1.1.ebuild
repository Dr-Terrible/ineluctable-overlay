# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

COMMIT="87082741b1cc0a97cd84bd17cd4ee41d70a42fc6"
ABSEIL_COMMIT="1948f6f967e34db9793cfa8b4bcbaf370d039fd8"
DEMUMBLE_COMMIT="01098eab821b33bd31b9778aea38565cd796aa85"

DESCRIPTION="A size profiler for binaries"
HOMEPAGE="https://github.com/google/bloaty"
SRC_URI="https://github.com/google/bloaty/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/abseil/abseil-cpp/archive/${ABSEIL_COMMIT}.tar.gz -> abseil-${ABSEIL_COMMIT}.tar.gz
	https://github.com/nico/demumble/archive/${DEMUMBLE_COMMIT}.tar.gz -> demumble-${DEMUMBLE_COMMIT}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${COMMIT}"

DEPEND="dev-libs/re2
	>=dev-libs/capstone-4.0.1
	dev-libs/protobuf"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-libbloaty.patch # not required for bloaty v1.1.1+
)

src_prepare() {
	rmdir "${S}"/third_party/abseil-cpp || die
	mv "${WORKDIR}"/abseil-cpp-$ABSEIL_COMMIT "${S}"/third_party/abseil-cpp || die

	rmdir "${S}"/third_party/demumble || die
	mv "${WORKDIR}"/demumble-$DEMUMBLE_COMMIT "${S}"/third_party/demumble || die

	cmake-utils_src_prepare
}
