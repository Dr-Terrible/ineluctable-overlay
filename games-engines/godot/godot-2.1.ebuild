# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils scons-utils toolchain-funcs

EDOC_COMMIT="8df317bc9c57c7c454da17dfc4f9d9e9f95b1fdf"
EEXAMPLE_COMMIT="210bd8d8c49458078541475a7a4c01d39cc99cfd"

DESCRIPTION="Godot is a fully featured, open source, MIT licensed, game engine"
HOMEPAGE="http://www.godotengine.org"
SRC_URI="https://github.com/${PN}engine/${PN}/archive/${PV}-stable.tar.gz -> ${PF}.tar.gz
doc? ( https://github.com/${PN}engine/${PN}-docs/archive/${EDOC_COMMIT}.tar.gz -> ${PF/godot/godot-docs}.tar.gz )
examples? ( https://github.com/${PN}engine/${PN}-demo-projects/archive/${EEXAMPLE_COMMIT}.tar.gz -> ${PF/godot/godot-examples}.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_MODULES="server"
IUSE="+etc python squirrel +tools lua rfd +vorbis +minizip +opengl +theora +truetype +speex +png +jpeg +webp +dds +pvr +musepack doc examples ssl libressl +pulseaudio +xml +3d squish opus"

S="${WORKDIR}/${P}-stable"

RESTRICT="mirror"

REQUIRED_USE="
	examples? ( doc )"

DOCS=()

PATCHES=(
	# FIX: the mechanism used by 'spawn_jobs' to autodetect the job numbers
	#      is borked; it's more appropriate to bypass it and use 'escons'
#	"${FILESDIR}"/${PN}-1.0-scons.patch
	"${FILESDIR}"/${PN}-1.1-bundled.patch
	"${FILESDIR}"/${PN}-1.1-libs.patch
)

CDEPEND="media-sound/pulseaudio:0[alsa]
	media-libs/alsa-lib
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXinerama
	squirrel? ( dev-lang/squirrel )
	lua? ( dev-lang/lua:0 )
	vorbis? ( media-libs/libvorbis media-libs/libogg )
	minizip? ( sys-libs/zlib[minizip] )
	opengl? ( virtual/opengl )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	theora? (
		>=media-libs/libtheora-1.1.1[encode]
		media-libs/libogg
	)
	truetype? ( media-libs/freetype:2 )
	speex? ( >=media-libs/speex-1.2_beta3 )
	png? ( media-libs/libpng:0 )
	jpeg? ( virtual/jpeg:0 )
	webp? ( media-libs/libwebp )
	musepack? ( >=media-sound/musepack-tools-444:0 )
	opus? ( media-libs/opus )"

DEPEND="doc? (
	dev-python/sphinx
	dev-python/sphinx_rtd_theme
)"

RDEPEND="${DEPEND}"

src_prepare() {
	# remove some bundled deps
	#	drivers/png/png* \
	#rm -r drivers/builtin_zlib || die
	#rm -r drivers/mpc/{mpc*,minimax*,huffman*,internal*,stream*,synth*,requant*,reader*,decoder*,datatypes*} || die
	#rm -r drivers/ogg/{*.c,*.h} || die
	#rm -r drivers/vorbis/{*.c,books,modes,b*.h,c*.h,e*.h,h*.h,l*.h,m*.h,o*.h,p*.h,r*.h,s*.h,v*.h,w*.h} || die
	#rm -r drivers/png/{png*,example*} || die

	#ewarn "$(echo "Remaining bundled dependencies:"; ( find drivers -mindepth 1 -maxdepth 1 -type d; ) | sed 's|^|- |')"

	# FIX: filter all hardcoded compilers flags
	sed -e "s/'-O2',//" \
		-i platform/x11/detect.py || die

	#epatch "${PATCHES[@]}"
	#epatch_user
}

src_configure() {
	USE_SCONS_TRUE="yes"
	USE_SCONS_FALSE="no"
	myesconsargs=(
		target=release
		platform=x11
		CXX="$(tc-getCXX)"
		CCFLAGS="${CXXFLAGS}"
		CFLAGS="${CFLAGS}"
		LINKFLAGS="${LDFLAGS}"
		builtin_zlib=no
		colored=yes
		default_gui_theme=yes
		disable_advanced_gui=no
		gdscript=yes
		old_scenes=yes
		spawn_jobs=no
		use_theoraplayer_binary=no
		$(use_scons 3d disable_3d no yes)
		$(use_scons pulseaudio pulseaudio)
		$(use_scons xml xml)
		$(use_scons squish squish)
		$(use_scons python)
		$(use_scons squirrel)
		$(use_scons tools)
		$(use_scons lua)
		$(use_scons rfd)
		$(use_scons vorbis)
		$(use_scons minizip)
		$(use_scons opengl)
		$(use_scons theora)
		$(use_scons truetype freetype)
		$(use_scons speex)
		$(use_scons png)
		$(use_scons jpeg jpg)
		$(use_scons webp)
		$(use_scons dds)
		$(use_scons pvr)
		$(use_scons etc etc1)
		$(use_scons ssl openssl)
		$(use_scons musepack)
		$(use_scons opus)
	)
	use tools && myesconsargs+=(
		target=release_debug
	)
}

src_compile() {
	escons -D --config=force
}

src_install() {
	# installing binaries and libraries
	cp "bin/${PN}.x11.opt.$(use tools && echo 'tools.')64" bin/${PN} || die
	dobin bin/${PN}

	# installing documentation and examples
	einstalldocs
	if use doc; then
		pushd "${WORKDIR}/${PN}-docs-${EDOC_COMMIT}"
			emake html || die
			dodoc -r _build/html
		popd
	fi
	if use examples; then
		pushd "${WORKDIR}/${PN}-demo-projects-${EEXAMPLE_COMMIT}"
			insinto /usr/share/${PF}/examples
			dodir /usr/share/doc/${PF}/examples
			doins -r *
		popd
	fi
}
