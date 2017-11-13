# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit eutils autotools-multilib

ECOMMIT="ac0cfb03001b33066c28a1568ad45d9387934e3e"

DESCRIPTION="Film-Quality Vector Animation (core engine)"
HOMEPAGE="http://www.synfig.org"
#SRC_URI="mirror://sourceforge/synfig/${P}.tar.gz"
SRC_URI="https://github.com/${PN}/${PN}/archive/${ECOMMIT}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="imagemagick +ffmpeg libav dv opengl opencl +openexr +truetype +jpeg +tiff fontconfig debug static-libs nls examples avcodec +swscale"

REQUIRED_USE="ffmpeg? ( avcodec swscale )"
DEPEND="dev-libs/libsigc++:2
	dev-cpp/libxmlpp:2.6
	dev-libs/libxml2:2
	media-libs/libpng:0
	>=dev-cpp/ETL-0.04.20
	dev-cpp/glibmm:2
	dev-libs/boost:0
	dev-libs/glib:2
	dev-libs/libltdl:0
	media-libs/ilmbase:0
	media-libs/libmng:0/2
	>=media-libs/mlt-6.0.0
	sys-libs/zlib:0
	x11-libs/cairo:0
	x11-libs/pango:0
	openexr? ( media-libs/openexr:0 )
	ffmpeg? ( virtual/ffmpeg )
	truetype? ( media-libs/freetype )
	fontconfig? ( media-libs/fontconfig )
	jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0 )"
RDEPEND="${DEPEND}
	avcodec? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:0= )
	)
	swscale? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:0= )
	)
	opengl? ( virtual/opengl )
	opencl? ( virtual/opencl )
	dv? ( media-libs/libdv )
	imagemagick? ( media-gfx/imagemagick[cxx] )"

S="${WORKDIR}/${PN}-${ECOMMIT}/${PN}-core"
RESTRICT+=" mirror"
PATCHES=(
	# use ltdl from system
	#"${FILESDIR}"/synfig-ltdl.patch

	# see http://www.synfig.org/issues/thebuggenie/synfig/issues/904
	#"${FILESDIR}"/${PN}-c++11.patch
)

src_prepare() {
	# build with external system libltdl
	#rm -r libltdl || die

	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		   -e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4

	autotools-utils_src_prepare
}

src_configure() {
	# synfig relies on libsigc++ which in turn relies on C++11,
	# see https://bugs.gentoo.org/566328
	#if has_version \>=dev-libs/libsigc++-2.6 ; then
	#	append-cxxflags -std=c++11
	#fi

	local warnings_level="none"
	use debug && warnings_level="hardcore"

	local myeconfargs=(
		--without-included-ltdl
		--disable-rpath
		--disable-option-checking
		--disable-dependency-tracking
		--enable-branch-probabilities
		--enable-warnings="${warnings_level}"
		$(use_with ffmpeg)
		$(use_with fontconfig)
		$(use_with imagemagick)
		$(use_with dv libdv)
		$(use_with openexr )
		$(use_with opengl)
		$(use_with opencl)
		$(use_with truetype freetype)
		$(use_with jpeg)
		$(use_with swscale libswscale)
		$(use_with avcodec libavcodec)
		$(use_enable static-libs static)
		$(use_enable nls)
		$(use_enable debug)
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
