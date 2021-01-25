# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
inherit python-single-r1 cmake

DESCRIPTION="Appleseed is a modern, physically-based production renderer."
HOMEPAGE="http://appleseedhq.net"
SRC_URI="https://github.com/${PN}hq/${PN}/archive/${PV}-beta.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

X86_CPU_FEATURES=( sse4_2:sse4.2 avx:avx avx2:avx2 f16c:f16c )
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="cuda cli qt tools python cpu_flags_x86_sse debug ${CPU_FEATURES[@]%:*}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# 	media-libs/embree
DEPEND="dev-libs/boost:=[python?,threads]
	media-libs/openexr
	media-libs/openimageio
	media-libs/osl
	media-libs/libpng:0
	dev-libs/xerces-c
	sys-libs/zlib
	cuda? ( dev-util/nvidia-cuda-toolkit )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-beta"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DWITH_CLI=$(usex cli ON OFF)
		-DWITH_STUDIO=$(usex qt ON OFF)
		-DWITH_TOOLS=$(usex tools ON OFF)
		-DWITH_GPU=$(usex cuda ON OFF)
		-DWITH_OSL=OFF
		-WWITH_EMBREE=OFF
		-DWITH_DISNEY_MATERIAL=OFF
		-DWITH_DOXYGEN=OFF
		-DWITH_PYTHON2_BINDINGS=OFF
		-DUSE_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DUSE_SSE42=$(usex cpu_flags_x86_sse4_2 ON OFF)
		-DUSE_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DUSE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)
		-DUSE_F16C=$(usex cpu_flags_x86_f16c ON OFF)
		-DUSE_STATIC_BOOST=OFF
		-DUSE_STATIC_EMBREE=OFF
		-DUSE_STATIC_EXR=OFF
		-DUSE_STATIC_OCIO=OFF
		-DUSE_STATIC_OIIO=OFF
		-DUSE_STATIC_OSL=OFF
		-DUSE_STATIC_OSL=OFF
		-DWARNINGS_AS_ERRORS=OFF
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE
		-DINSTALL_HEADERS=OFF
		-DINSTALL_TESTS=OFF
		-DINSTALL_API_EXAMPLES=OFF
	)
	cmake_src_configure
}
