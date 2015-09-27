# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-multilib git-r3

EGIT_REPO_URI="https://github.com/therocode/${PN}.git"
EGIT_BRANCH="incoming"

DESCRIPTION="Feather Kit is a lightweight, open source framework for game development in C++"
HOMEPAGE="http://featherkit.therocode.net"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~x86"

FK_MODULES="audio structure entity rendering ui util"
FK_BACKENDS="sfml sdl"
IUSE="$FK_BACKENDS static-libs json freetype doc"

for module in $FK_MODULES; do
	IUSE="${IUSE} +${module}"
done

REQUIRED_USE="freetype? ( rendering )"

COMMON_DEPEND="json? ( dev-libs/jsoncpp[${MULTILIB_USEDEP}] )
	audio? (
		media-libs/openal[${MULTILIB_USEDEP}]
		media-libs/libvorbis[static-libs?,${MULTILIB_USEDEP}]
		media-libs/libogg[static-libs?,${MULTILIB_USEDEP}]
	)
	rendering? (
		virtual/opengl[${MULTILIB_USEDEP}]
		media-libs/glm[${MULTILIB_USEDEP}]
		media-libs/freetype:2[static-libs?,${MULTILIB_USEDEP}]
	)
	sfml? ( >=media-libs/libsfml-2.1[static-libs?,${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2[static-libs?,${MULTILIB_USEDEP}] )"
DEPEND="doc? ( >=dev-python/sphinx-1.2.2 )"
RDEPEND="${COMMON_DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-missing-headers.patch
)

src_prepare() {
	# FIX: multilib-strict check
	sed -i -e "s:DESTINATION lib:DESTINATION $(get_libdir):" CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use !static-libs SHARED_BUILD)
		$(cmake-utils_use_build json)
		$(cmake-utils_use freetype BUILD_RENDERING_TEXT)
		$(cmake-utils_use sfml BUILD_SFMLBACKENDS)
		$(cmake-utils_use sdl BUILD_SDL2BACKENDS)
	"
	for module in $FK_MODULES; do
		mycmakeargs+=" $(cmake-utils_use_build $module)"
	done
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	if use doc; then
		einfo "Generating documentation API ..."
		pushd doxy
			doxygen -u ${PN}.conf || die
			doxygen -s ${PN}.conf || die "doxygen failed"
			dohtml -r gen/* || die
		popd
	fi

	insinto /usr/share/cmake/Modules
	doins cmake/modules/FindFeatherkit.cmake
}
