# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils scons-utils toolchain-funcs

EDOCS="8b68ba5c9ebcab08ac4e8e95b486e64a88b1c4ec"
EXAMPLES="d69cc10"
SLOT="3.0"

DESCRIPTION="Godot is a fully featured, open source, MIT licensed, game engine"
HOMEPAGE="http://www.godotengine.org"
SRC_URI="https://github.com/${PN}engine/${PN}/archive/${PV}-stable.tar.gz -> ${P}.tar.gz
doc? ( https://github.com/${PN}engine/${PN}-docs/archive/${EDOCS}.tar.gz -> ${PN}-${SLOT}-${EDOCS:0:7}-docs.tar.gz )
examples? ( https://github.com/${PN}engine/${PN}-demo-projects/archive/${SLOT}-${EXAMPLES}.tar.gz -> ${PN}-${SLOT}-${EXAMPLES}-examples.tar.gz )"

LICENSE="MIT"
KEYWORDS="amd64 x86"
IUSE_COMPONENTS="deprecated minizip xml pulseaudio udev"
IUSE="debug tools lto doc examples libressl +3d $IUSE_COMPONENTS"

S="${WORKDIR}/${P}-stable"

RESTRICT="mirror test"

REQUIRED_USE="examples? ( doc )"

CDEPEND="media-sound/pulseaudio:0[alsa]
	media-libs/alsa-lib:0
	net-libs/enet:1.3
	media-libs/opusfile:0
	virtual/opengl
	dev-libs/libpcre2:0
	media-libs/freetype:2
	media-libs/libogg:0
	media-libs/libpng:0/16
	media-libs/libtheora:0
	media-libs/libvorbis:0
	media-libs/libvpx:0
	media-libs/libwebp:0
	sys-libs/zlib:0
	x11-libs/libX11:0
	x11-libs/libXcursor:0
	x11-libs/libXi:0
	x11-libs/libXinerama:0
	x11-libs/libXrandr:0
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	udev? ( virtual/udev )
	minizip? ( sys-libs/zlib:0[minizip] )"

DEPEND="${CDEPEND}
	doc? (
		dev-python/sphinx
		dev-python/sphinx_rtd_theme
	)"

RDEPEND="${CDEPEND}"

src_configure() {
	USE_SCONS_TRUE="yes"
	USE_SCONS_FALSE="no"

	MYSCONS=(
		# Target build options
		#arch=TODO
		#bits=TODO
		platform=x11
		target=release
		tools=$(usex tools)

		# Compilation environment setup
		CXX="$(tc-getCXX)"
		CC="$(tc-getCC)"
		#LINK="$(tc-getLD)"
		CXXFLAGS="${CXXFLAGS}"
		CFLAGS="${CFLAGS}"
		LINKFLAGS="${LDFLAGS}"
		use_lto=$(usex lto)

		# Components
		deprecated=$(usex deprecated)
		gdscript=1
		minizip=$(usex minizip)
		xaudio2=no
		xml=$(usex xml)
		pulseaudio=$(usex pulseaudio)
		udev=$(usex udev)

		# Advanced options
		disable_3d=$(usex 3d 0 1)
		disable_advanced_gui=0
		vsproj=0
		progress=1
		dev=$(usex debug) # sets both 'verbose' and 'warnings' to max details
		debug_symbols=$(usex debug)
		macports_clang=no

		# Thirdparty libraries
		builtin_bullet=1  # godot 3.0 requires bullet-2.88 which has not being released by upstream
		builtin_enet=0
		builtin_freetype=0
		builtin_libogg=0
		builtin_libpng=0
		builtin_libtheora=0
		builtin_libvorbis=0
		builtin_libvpx=0
		builtin_libwebp=0
		builtin_mbedtls=0
		builtin_opus=0
		builtin_pcre2=0
		builtin_recast=1       # recast is not packaged in Portage
		builtin_squish=1       # libsquish is not packaged in Portage
		builtin_thekla_atlas=1 # thekla_atlas is not packaged in Portage
		builtin_zlib=0

		# zstd 1.3.3 is required, but it's different from the one provided by Portage,
		# leading to compilation errors: error: 'ZSTD_p_compressionLevel' was not declared in this scope
		builtin_zstd=1

		no_editor_splash=0
	)

	use tools && MYSCONS+=(
		target=release_debug
	)
}

src_compile() {
	escons -D --config=force "${MYSCONS[@]}" BUILD_NAME="Gentoo"
}

src_install() {
	newbin "bin/${PN}.x11.opt.$(use tools && echo 'tools.')64" ${PN}-${SLOT}
	doman misc/dist/linux/${PN}.6

	# Install desktop menu+icons
	doicon misc/dist/appimage/${PN}.png
	domenu misc/dist/linux/${PN}.desktop

	# install documentation and examples
	einstalldocs
	if use doc; then
		pushd "${WORKDIR}/${PN}-docs-${EDOCS}" || die
			emake html || die
			dodoc -r _build/html
		popd || die
	fi
	if use examples; then
		pushd "${WORKDIR}/${PN}-demo-projects-${SLOT}-${EXAMPLES}" || die
			insinto /usr/share/${PF}/examples
			dodir /usr/share/doc/${PF}/examples
			doins -r *
		popd || die
	fi
}
