# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1 cmake

DESCRIPTION="An industrial strength 3D python package for CAD/BIM/PLM/CAM"
HOMEPAGE="http://www.pythonocc.org"
SRC_URI="https://github.com/tpaviot/${PN}-core/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=LGPL-3
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="+opengl"

S="${WORKDIR}/${PN}-core-${PV}"

RDEPEND="${PYTHON_DEPS}
	sci-libs/opencascade:7.5.0=
	opengl? ( virtual/opengl )"
DEPEND=">=dev-lang/swig-3.0.9"

src_configure() {
	# NOTE: without this hack CMake's macro Python3 will always assume the
	# highest version of Python available from the system, regardless of
	# what is specified in PYTHON_COMPAT.
	python_setup
	sed -i \
		-e "s/find_package(Python3 COMPONENTS/find_package(Python3 ${EPYTHON##python} EXACT COMPONENTS/g" \
	CMakeLists.txt

	local mycmakeargs=(
		-DPYTHONOCC_WRAP_VISU=$(usex opengl)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize "${ED}"/usr
}
