# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic cmake-utils

MY_PN="GamePlay"

DESCRIPTION="GamePlay3D is an open-source, cross-platform 3D game framework written in C++."
HOMEPAGE="http://www.gameplay3d.org"
SRC_URI="
	https://github.com/blackberry/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/blackberry/${MY_PN}/releases/download/v${PV}/gameplay-deps.zip -> ${P}-deps.zip
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples"

RESTRICT="mirror"

# Missing USE 'static-libs'
# >=sci-physics/bullet-2.82[static-libs]
# >=media-libs/openal-1.14[static-libs]
# >=dev-lang/lua-5.2.1[static-libs]
COMMON_DEPEND="virtual/opengl
	virtual/glu
	>=media-libs/glew-1.10.0[static-libs]
	>=media-libs/freetype-2.4.5[static-libs]
	>=media-libs/libvorbis-1.3.4[static-libs]
	>=media-libs/libogg-1.3.2[static-libs]
	>=media-libs/libpng-1.6.2
	>=sys-libs/zlib-1.2.5[static-libs]
	>=dev-libs/tinyxml2-2.1[static-libs]
	dev-libs/libpcre[cxx]
	x11-libs/gtk+:2"
RDEPEND="${COMMON_DEPEND}"
DEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-cmake.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
	epatch_user

	# FIX: external deps should be inside $S
	mv "${WORKDIR}"/{bin,external-deps} "${S}" || die

	# TODO: remove bundled libs
	# NOTE: GamePlay3D's deps are statically linked against libgameplay.so, so we need to rely on external USE 'static-libs' (which are missing for some packages, such as bullet and freetype2) and then patch CMake files.
#	rm -r "${S}"/external-deps/{bullet,freetype2,glew,lua,openal,png,tinyxml2,zlib} || die
}

#src_configure() {
#	# CMake files provided by BlackBerry's R&D suck, so hard.
#	local VORBIS="ogg vorbis vorbisfile vorbisenc"
#	local DEPS="lua5.2 zlib libpng16 bullet $VORBIS openal glew"
#
#	append-libs "$( $(tc-getPKG_CONFIG) --libs $DEPS )"
#	append-cppflags "$( $(tc-getPKG_CONFIG) --cflags-only-I --cflags-only-other $DEPS )"
#	append-cxxflags "$( $(tc-getPKG_CONFIG) --cflags $DEPS )"
#	append-flags "$( $(tc-getPKG_CONFIG) --cflags $DEPS )"
#
#	cmake-utils_src_configure
#}

src_install() {
	local DEST=/usr/share/gameplay3d

	into ${DEST}
	dobin "${S}"/bin/linux/*
	dolib.a "${BUILD_DIR}"/gameplay/libgameplay.a

	if use doc; then
		einfo "Generating documentation API ..."
		doxygen -u gameplay.doxyfile || die
		doxygen gameplay.doxyfile || die "doxygen failed"
	fi

	if use examples; then
		cp -r "${BUILD_DIR}"/samples "${D}/${DEST}" || die
	fi
}
