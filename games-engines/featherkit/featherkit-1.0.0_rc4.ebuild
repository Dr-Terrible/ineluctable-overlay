# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-multilib

DESCRIPTION="Feather Kit is a lightweight, open source framework for game development in C++"
HOMEPAGE="http://featherkit.therocode.net"
SRC_URI="https://github.com/therocode/${PN}/archive/${PV//_/}.tar.gz -> ${P//_/}.tar.gz"

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
		media-libs/libvorbis[${MULTILIB_USEDEP}]
		media-libs/libogg[${MULTILIB_USEDEP}]
	)
	rendering? (
		virtual/opengl[${MULTILIB_USEDEP}]
		media-libs/glm[${MULTILIB_USEDEP}]
		media-libs/freetype:2[${MULTILIB_USEDEP}]
	)
	sfml? ( >=media-libs/libsfml-2.1[${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )"
DEPEND="doc? ( >=dev-python/sphinx-1.2.2 )"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${P//_/}"

src_prepare() {
	# FIX: multilib-strict check
	sed -i -e "s:DESTINATION lib:DESTINATION $(get_libdir):" CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use !static-libs SHARED_BUILD)
		$(cmake-utils_use_build json)
		$(_use_me_now BUILD_ freetype RENDERING_TEXT)
		$(_use_me_now BUILD_ sfml SFMLBACKENDS)
		$(_use_me_now BUILD_ sdl SDL2BACKENDS)
	)
	for module in $FK_MODULES; do
		mycmakeargs+="$(cmake-utils_use_build $module)"
	done
	cmake-multilib_src_configure
	echo "MULTILIB_ABI_FLAG: $MULTILIB_ABI_FLAG"
}

src_install() {
	cmake-multilib_src_install

	if use doc; then
		einfo "Generating documentation API ..."
		pushd doxy
			doxygen -u ${PN}.conf || die
			doxygen ${PN}.conf || die "doxygen failed"
			dohtml -r gen/* || die
		popd
	fi

	insinto /usr/share/cmake/Modules
	doins cmake/modules/FindFeatherkit.cmake
}
