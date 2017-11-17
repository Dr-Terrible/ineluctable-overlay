# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic cmake-utils git-r3

MY_PN="GamePlay"

DESCRIPTION="GamePlay3D is an open-source, cross-platform 3D game framework written in C++."
HOMEPAGE="http://www.gameplay3d.org"

EGIT_REPO_URI="https://github.com/blackberry/${MY_PN}.git"
EGIT_BRANCH="next"

SRC_URI="https://github.com/blackberry/${MY_PN}/releases/download/v3.0.0/gameplay-deps.zip -> ${PN}-3.0.0-deps.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
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

src_unpack() {
	git-r3_src_unpack
	cd "${S}" || die
	unpack ${PN}-3.0.0-deps.zip
}

src_prepare() {
	epatch "${PATCHES[@]}"
	epatch_user

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
