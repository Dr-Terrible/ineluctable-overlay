# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
LLVM_MAX_SLOT=11
inherit llvm cmake

DESCRIPTION="PortableCL: opensource implementation of the OpenCL standard"
HOMEPAGE="http://portablecl.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64"
IUSE="cuda debug asan tsan lsan ubsan"

RESTRICT="mirror"

RDEPEND="
	<sys-devel/llvm-12:=
	|| (
		sys-devel/llvm:11
		sys-devel/llvm:10
	)

	dev-libs/ocl-icd
	sys-apps/hwloc
	cuda? ( dev-util/nvidia-cuda-toolkit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	mycmakeargs=(
		-DPOCL_ICD_ABSOLUTE_PATH=ON
		-DDEVELOPER_MODE=OFF
		-DUSE_POCL_MEMMANAGER=OFF
		-DPEDANTIC=OFF
		-DOCS_AVAILABLE=ON
		-DENABLE_CONFORMANCE=ON
		-DENABLE_CUDA=$(usex cuda)
		-DPOCL_DEBUG_MESSAGES=$(usex debug)
		-DENABLE_ASAN=$(usex asan)
		-DENABLE_TSAN=$(usex tsan)
		-DENABLE_UBSAN=$(usex ubsan)
		-DENABLE_LSAN=$(usex lsan)
	)
	cmake_src_configure
}
