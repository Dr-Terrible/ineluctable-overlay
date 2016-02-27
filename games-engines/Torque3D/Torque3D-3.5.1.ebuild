# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_BUILD_TYPE="Release"
#CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils git-2

EGIT_REPO_URI="https://github.com/GarageGames/${PN}.git"
EGIT_BRANCH="development"
#EGIT_COMMIT="feec36731ef870c36084fd08c1cd53865aa01ad4"

DESCRIPTION="Torque3D is an cross-platform and open-source game engine"
HOMEPAGE="http://garagegames.github.io/Torque3D"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="vorbis theora openal smp static-libs tools debug profiler asserts"

DEPEND=">=dev-lang/nasm-2.11.03"
CDEPEND="virtual/opengl
	media-libs/freetype
	theora? ( media-libs/libtheora:0 )
	vorbis? ( media-libs/libvorbis:0 )
	openal? ( media-libs/openal )"
RDEPEND="${CDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-cflags.patch"
	epatch "${FILESDIR}/${PN}-bundled.patch"

	# TODO: bundled libs that need to be removed:
	#lmng
	#lpng
	#lungif
	#ljpeg
	#zlib
	#tinyxml
	#opcode
	#squish
	#collada
	#pcre
	#convexDecomp
#	rm -r \
#		Engine/lib/libogg \
#		Engine/lib/libvorbis \
#		|| die
}

src_configure() {
	# NOTE: it's an ugly hack and can't be avoided
	local TORQUE_EXTERNAL_LIBS="dl Xxf86vm Xext X11 Xft stdc++ pthread GL"
	use vorbis TORQUE_EXTERNAL_LIBS+="vorbis vorbisenc vorbisfile ogg m"
	use theora TORQUE_EXTERNAL_LIBS+="theora theoradec theoraenc ogg"

	local mycmakeargs=(
		-DTORQUE_APP_NAME=${PN}
		-DTORQUE_DEDICATED=ON
#		-DTORQUE_ADVANCED_LIGHTING=ON
#		-DTORQUE_BASIC_LIGHTING=ON
#		-DTORQUE_ADDITIONAL_LINKER_FLAGS=${LDFLAGS}
		-DTORQUE_CXX_FLAGS_COMMON=${CXXFLAGS}
		-DTORQUE_EXTERNAL_LIBS="${TORQUE_EXTERNAL_LIBS}"
		$(cmake-utils_use vorbis TORQUE_SFX_VORBIS)
		$(cmake-utils_use openal TORQUE_SFX_OPENAL)
		$(cmake-utils_use theora TORQUE_THEORA)
		$(cmake-utils_use tools TORQUE_TOOLS)
		$(cmake-utils_use debug TORQUE_DEBUG)
		$(cmake-utils_use profiler TORQUE_ENABLE_PROFILER)
		$(cmake-utils_use asserts TORQUE_ENABLE_ASSERTS)
		$(cmake-utils_use smp TORQUE_MULTITHREAD)
		$(cmake-utils_use static-libs TORQUE_STATIC)
	)
	cmake-utils_src_configure
}
