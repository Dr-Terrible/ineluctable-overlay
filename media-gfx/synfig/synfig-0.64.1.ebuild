# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
WANT_AUTOMAKE="1.12"
inherit eutils autotools

DESCRIPTION="Film-Quality Vector Animation (core engine)"
HOMEPAGE="http://www.synfig.org/"
SRC_URI="mirror://sourceforge/synfig/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="imagemagick ffmpeg dv openexr truetype jpeg tiff fontconfig debug"

DEPEND="dev-libs/libsigc++:2
	>=dev-cpp/libxmlpp-2.6.1
	media-libs/libpng:0
	>=dev-cpp/ETL-0.04.17
	ffmpeg? ( virtual/ffmpeg )
	openexr? ( media-libs/openexr )
	truetype? ( media-libs/freetype )
	fontconfig? ( media-libs/fontconfig )
	jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0 )"
RDEPEND="${DEPEND}
	dv? ( media-libs/libdv )
	imagemagick? ( media-gfx/imagemagick )"

src_prepare() {
	# FIX: compilation errors due to missing C/C++ headers
	epatch "${FILESDIR}"/synfig-headers.patch

	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		   -e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4

	# FIX: ax_boost_program_options.m4 doesn't work correctly
	eautoreconf
}

src_configure() {
	local warnings_level="none"
	use debug && warnings_level="hardcore"
	econf \
		--enable-warnings="${warnings_level}" \
		$(use_with ffmpeg) \
		$(use_with fontconfig) \
		$(use_with imagemagick) \
		$(use_with dv libdv) \
		$(use_with openexr ) \
		$(use_with truetype freetype) \
		$(use_with jpeg)
}

src_install() {
	default
	dodoc doc/*.txt
	insinto /usr/share/${PN}/examples
	doins examples/*.sifz
}
