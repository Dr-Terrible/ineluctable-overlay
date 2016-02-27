# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit base scons-utils toolchain-funcs

DESCRIPTION="Godot is a fully featured, open source, MIT licensed, game engine"
HOMEPAGE="http://www.godotengine.org"
SRC_URI="https://github.com/okamstudio/${PN}/archive/${PV}-stable.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_MODULES="server"
IUSE="+etc python squirrel +tools lua rfd +vorbis +minizip +opengl +theora +truetype +speex +png +jpeg +webp +dds +pvr +musepack doc examples ssl"

S="${WORKDIR}/${P}-stable"

RESTRICT="mirror"

REQUIRED_USE="
	examples? ( doc )"

DOCS=()

PATCHES=(
	# FIX: the mechanism used by 'spawn_jobs' to autodetect the job numbers
	#      is borked; it's more appropriate to bypass it and use 'escons'
#	"${FILESDIR}"/${PN}-1.0-scons.patch
	"${FILESDIR}"/${P}-bundled.patch
	"${FILESDIR}"/${P}-libs.patch
)

DEPEND="media-sound/pulseaudio:0[alsa]
	media-libs/alsa-lib
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXinerama
	squirrel? ( dev-lang/squirrel )
	lua? ( dev-lang/lua:0 )
	vorbis? ( media-libs/libvorbis media-libs/libogg )
	minizip? ( sys-libs/zlib[minizip] )
	opengl? ( virtual/opengl )
	ssl? ( dev-libs/openssl:0 )
	theora? (
		>=media-libs/libtheora-1.1.1[encode]
		media-libs/libogg
	)
	truetype? ( media-libs/freetype:2 )
	speex? ( >=media-libs/speex-1.2_beta3 )
	png? ( media-libs/libpng:0 )
	jpeg? ( virtual/jpeg:0 )
	webp? ( media-libs/libwebp )
	musepack? ( >=media-sound/musepack-tools-444:0 )"
RDEPEND="${DEPEND}"

src_prepare() {
	# remove some bundled deps
	#	drivers/png/png* \
	rm -r \
		drivers/builtin_zlib \
		drivers/mpc/{mpc*,minimax*,huffman*,internal*,stream*,synth*,requant*,reader*,decoder*,datatypes*} \
		drivers/ogg/{*.c,*.h} \
		drivers/vorbis/{*.c,books,modes,b*.h,c*.h,e*.h,h*.h,l*.h,m*.h,o*.h,p*.h,r*.h,s*.h,v*.h,w*.h} \
		drivers/png/{png*,example*,filter*} \
		|| die

#	ewarn "$(echo "Remaining bundled dependencies:"; ( find drivers -mindepth 1 -maxdepth 1 -type d; ) | sed 's|^|- |')"

	# FIX: filter all hardcoded compilers flags
	sed -e "s/'-O2',//" \
		-i platform/x11/detect.py || die

	base_src_prepare
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
		disable_3d=no
		disable_advanced_gui=no
		gdscript=yes
		old_scenes=yes
		spawn_jobs=no
		squish=yes
		use_theoraplayer_binary=no
		xml=yes
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
		sh doc/make_doc.sh || die
		dohtml -r doc/html/
		cd "${S}" || die
	fi
	if use examples; then
		insinto /usr/share/${PF}/examples
		dodir /usr/share/doc/${PF}/examples
		doins -r demos/*
	fi
}