# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils ltprune autotools multilib-minimal

DESCRIPTION="Film-Quality Vector Animation (core engine)"
HOMEPAGE="https://www.synfig.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> synfig-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="imagemagick +ffmpeg libav dv opengl opencl +openexr +truetype +jpeg +tiff fontconfig debug static-libs nls examples +swscale"

REQUIRED_USE="ffmpeg? ( swscale )"
DEPEND="dev-libs/libsigc++:2
	dev-cpp/libxmlpp:2.6
	dev-libs/libxml2:2
	media-libs/libpng:0
	>=dev-cpp/ETL-${PV}
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
	swscale? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:0= )
	)
	opengl? ( virtual/opengl )
	opencl? ( virtual/opencl )
	dv? ( media-libs/libdv )
	imagemagick? ( media-gfx/imagemagick[cxx] )"

RESTRICT+=" mirror"

S="${WORKDIR}/synfig-${PV}/${PN}-core"

src_prepare() {
	eapply_user
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local warnings_level="none"
	use debug && warnings_level="hardcore"

	local myconf=(
		--without-included-ltdl
		--disable-rpath
		--disable-option-checking
		--disable-dependency-tracking
		--disable-update-mimedb
		--enable-branch-probabilities
		--enable-warnings="${warnings_level}"

		$(use_with ffmpeg)
		$(use_with libav ffmpeg)
		$(use_with fontconfig)
		$(use_with imagemagick)
		$(use_with dv libdv)
		$(use_with openexr )
		$(use_with opengl)
		$(use_with opencl)
		$(use_with truetype freetype)
		$(use_with jpeg)
		$(use_with swscale libswscale)
		$(use_enable static-libs static)
		$(use_enable nls)
		$(use_enable debug)
	)
	econf "${myconf[@]}"
}

multilib_src_install_all() {
	prune_libtool_files --all

	if use examples; then
		insinto /usr/share/${PN}/examples
		doins examples/*.sifz
	fi
}
