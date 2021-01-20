# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit llvm cmake-utils

DESCRIPTION="PortableCL: opensource implementation of the OpenCL standard"
HOMEPAGE="http://portablecl.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64"
IUSE="cuda debug asan tsan lsan ubsan"
RESTRICT="mirror"

RDEPEND="
	<sys-devel/llvm-11:=
	|| (
		sys-devel/llvm:10
		sys-devel/llvm:9
	)

	dev-libs/ocl-icd
	sys-apps/hwloc
	dev-libs/libltdl:0
	cuda? ( dev-util/nvidia-cuda-toolkit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

LLVM_MAX_SLOT=10

pkg_setup() {
	# Needs an OpenCL 1.2 ICD, mesa and nvidia are invalid
	# Maybe ati works, feel free to add/fix if you can test
	if [[ $(eselect opencl show) == 'ocl-icd' ]]; then
		einfo "Found a valid OpenCL ICD profile"
	else
		eerror "Please use a supported ICD:"
		eerror "eselect opencl set ocl-icd"
		die "OpenCL ICD not set to a supported value"
	fi
}

src_configure() {
	mycmakeargs=(
		-DDEVELOPER_MODE=OFF
		-DUSE_POCL_MEMMANAGER=OFF
		-DPEDANTIC=ON
		-DOCS_AVAILABLE=ON
		-DENABLE_CONFORMANCE=ON
		-DENABLE_CUDA=$(usex cuda)
		-DPOCL_DEBUG_MESSAGES=$(usex debug)
		-DENABLE_ASAN=$(usex asan)
		-DENABLE_TSAN=$(usex tsan)
		-DENABLE_UBSAN=$(usex ubsan)
		-DENABLE_LSAN=$(usex lsan)
	)
	cmake-utils_src_configure
}
