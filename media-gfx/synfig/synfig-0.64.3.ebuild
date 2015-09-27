# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
#WANT_AUTOMAKE="1.12"
AUTOTOOLS_AUTORECONF=1
inherit eutils autotools-multilib

DESCRIPTION="Film-Quality Vector Animation (core engine)"
HOMEPAGE="http://www.synfig.org"
SRC_URI="mirror://sourceforge/synfig/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="imagemagick ffmpeg dv openexr truetype jpeg tiff fontconfig debug static-libs nls examples ffmpeg avcodec swscale"

REQUIRED_USE="ffmpeg? ( avcodec swscale )"
DEPEND="dev-libs/libsigc++:2
	>=dev-cpp/libxmlpp-2.6.1
	media-libs/libpng:0
	>=dev-cpp/ETL-0.04.17
	dev-cpp/glibmm:2
	dev-libs/boost:0
	dev-libs/glib:2
	dev-libs/libltdl:0
	media-libs/ilmbase:0
	openexr? ( media-libs/openexr:0 )
	ffmpeg? ( virtual/ffmpeg )
	truetype? ( media-libs/freetype )
	fontconfig? ( media-libs/fontconfig )
	jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0 )"
RDEPEND="${DEPEND}
	!<media-video/ffmpeg-1.2:0
	avcodec? ( virtual/ffmpeg:0 )
	swscale? ( virtual/ffmpeg:0 )
	dv? ( media-libs/libdv )
	imagemagick? ( media-gfx/imagemagick[cxx] )"

PATCHES=(
	# FIX: compilation errors due to missing C/C++ headers
	#"${FILESDIR}"/synfig-headers.patch

	# use ltdl from system
	"${FILESDIR}"/synfig-ltdl.patch
)

src_prepare() {
	# build with external system libltdl
	rm -r libltdl || die

	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		   -e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4

	autotools-utils_src_prepare
}

src_configure() {
	local warnings_level="none"
	use debug && warnings_level="hardcore"
	local myeconfargs=(
		--without-included-ltdl
		--disable-rpath
		--enable-warnings="${warnings_level}"
		$(use_with ffmpeg)
		$(use_with fontconfig)
		$(use_with imagemagick)
		$(use_with dv libdv)
		$(use_with openexr )
		$(use_with truetype freetype)
		$(use_with jpeg)
		$(use_with swscale libswscale)
		$(use_with avcodec libavcodec)
		$(use_enable static-libs static)
		$(use_enable nls)
	)
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install

	if use examples; then
		insinto /usr/share/${PN}/examples
		doins examples/*.sifz
	fi
}
