# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 cmake-multilib

#EGIT_REPO_URI="https://github.com/toffanin/${PN}.git"
#EGIT_BRANCH="${PV}"

DESCRIPTION="An open-source 3D framework"
HOMEPAGE="http://butts.com"
SRC_URI="${PN}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE_MODULES=""
IUSE_BACKENDES="sdl sfml"
IUSE_SCRIPTING="lua python"
IUSE="+aio doc egl examples gles opengl cpu_flags_x86_sse2 static-libs test tools $IUSE_MODULES $IUSE_BACKENDES $IUSE_SCRIPTING"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	egl? ( opengl )
	gles? ( opengl )"

# TODO:
# media-libs/glm[static-libs]
# media-libs/libsfml[static-libs]
CDEPEND="opengl? ( virtual/opengl )
	egl? ( media-libs/mesa[egl] )
	gles? ( media-libs/mesa[gles1,gles2] )
	cpu_flags_x86_sse2? ( dev-lang/orc )
	dev-libs/libRocket
	media-libs/glm
	media-libs/glfw[egl?]
	media-libs/assimp[tools]
	>=dev-cpp/cereal-1.0.0
	sdl? ( >=media-libs/libsdl2-2.0.3[cpu_flags_x86_sse2?,opengl?,gles?,threads] )
	sfml? ( media-libs/libsfml )
	aio? ( >=dev-libs/libuv-0.11.27 )"

DEPEND="doc? ( =games-engines/${PN}-docs-${PV} )"
RDEPEND="${CDEPEND}"

RESTRICT+=" mirror fetch"

S="${WORKDIR}/red-panda"

pkg_setup() {
	use python && python_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STRICT=OFF
		$(cmake-utils_use_build static-libs STATIC_LIBS)
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_build tools TOOLS)
		$(cmake-utils_use_with sdl BACKEND_SDL)
		$(cmake-utils_use_with sfml BACKEND_SFML)
		$(cmake-utils_use_enable python)
		$(cmake-utils_use_enable lua)
	)
	cmake-multilib_src_configure
}