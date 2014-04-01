# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-r3 scons-utils toolchain-funcs

EGIT_REPO_URI="git://github.com/okamstudio/${PN}.git"

DESCRIPTION="Godot is a fully featured, open source, MIT licensed, game engine."
HOMEPAGE="http://www.godotengine.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_MODULES="server"
IUSE="python squirrel +tools lua rfd +vorbis +minizip +opengl +theora +truetype +speex +png +jpeg +webp +dds +pvr +musepack +nedmalloc doc examples"

REQUIRED_USE="
	examples? ( doc )"

DOCS=()

DEPEND="media-libs/alsa-lib
	x11-libs/libX11
	x11-libs/libXcursor
	squirrel? ( dev-lang/squirrel )
	lua? ( dev-lang/lua )
	vorbis? ( media-libs/libvorbis media-libs/libogg )
	minizip? ( sys-libs/zlib[minizip] )
	opengl? ( virtual/opengl )
	theora? (
		>=media-libs/libtheora-1.1.1[encode]
		media-libs/libogg
	)
	truetype? ( media-libs/freetype:2 )
	speex? ( >=media-libs/speex-1.2_beta3 )
	png? ( media-libs/libpng )
	jpeg? ( virtual/jpeg )
	webp? ( media-libs/libwebp )
	musepack? ( >=media-sound/musepack-tools-444:0 )"
RDEPEND="${DEPEND}"

src_prepare() {
	# FIX: the mechanism used by 'spawn_jobs' to autodetect the job numbers
	#      is borked; it's more appropriate to bypass it and use 'escons'
	epatch "${FILESDIR}"/${PN}-scons.patch

	# remove some bundled deps
	#	drivers/png/png* \
	rm -r \
		drivers/builtin_zlib \
		drivers/openssl \
		drivers/mpc/{mpc*,minimax*,huffman*,internal*,stream*,synth*,requant*,reader*,decoder*,datatypes*} \
		drivers/ogg/{*.c,*.h} \
		drivers/vorbis/{*.c,books,modes,b*.h,c*.h,e*.h,h*.h,l*.h,m*.h,o*.h,p*.h,r*.h,s*.h,v*.h,w*.h} \
		drivers/png/{png*,example*,filter*} \
		|| die
	epatch "${FILESDIR}"/${PN}-bundled.patch
	epatch "${FILESDIR}"/${PN}-libs.patch

#	ewarn "$(echo "Remaining bundled dependencies:"; ( find drivers -mindepth 1 -maxdepth 1 -type d; ) | sed 's|^|- |')"

	# FIX: filter all hardcoded compilers flags
	sed -e "s/'-O2',//" \
		-i platform/x11/detect.py || die
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
		gdscript=yes
		squish=yes
		xml=yes
		builtin_zlib=no
		default_gui_theme=yes
		disable_3d=no
		disable_advanced_gui=no
		old_scenes=yes
		spawn_jobs=no
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
		$(use_scons musepack)
		$(use_scons nedmalloc)
	)
}

src_compile() {
	escons -D --config=force
}

src_install() {
	# installing binaries and libraries
	dobin bin/${PN}

	# installing documentation and examples
	einstalldocs
	if use doc; then
		doc/make_doc.sh || die
		dohtml -r doc/html/
		cd "${S}" || die
	fi
	if use examples; then
		insinto /usr/share/${PF}/examples
		dodir /usr/share/doc/${PF}/examples
		doins -r demos/*
	fi
}