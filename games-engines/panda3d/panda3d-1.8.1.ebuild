# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit base flag-o-matic eutils multiprocessing python-single-r1

DESCRIPTION="Panda3D is a framework for 3D rendering and game development"
HOMEPAGE="http://www.panda3d.org"
SRC_URI="http://www.panda3d.org/download/${P}/${P}.tar.gz
	doc? (
		http://www.panda3d.org/download/${P}/manual-${PV}-cxx.zip
		http://www.panda3d.org/download/${P}/reference-${PV}-cxx.zip
		python? (
			http://www.panda3d.org/download/${P}/manual-${PV}-python.zip
			http://www.panda3d.org/download/${P}/reference-${PV}-python.zip
		)
	)
	examples? (
		http://www.panda3d.org/download/${P}/${P}-samples.zip
		http://www.panda3d.org/download/noversion/bullet-samples.zip -> ${P}-bullet-samples.zip
	)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: add static-libs
IUSE="artoolkit bullet cg doc egl eigen +ffmpeg fftw fmod gles1 gles2 +jpeg npapi ode +openal opencv osmesa +png +python rocket examples contrib +squish +ssl sse threads +tiff +truetype xml +zlib pstats +xrandr"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="mirror"

# TODO: create ebuild for artoolkit and libsquish
# artoolkit? ( media-libs/artoolkit )
# squish? ( media-libs/squish )
COMMON_DEPEND="bullet? ( sci-physics/bullet )
	cg? ( media-gfx/nvidia-cg-toolkit )
	egl? ( media-libs/mesa[egl] )
	eigen? ( dev-cpp/eigen:3 )
	ffmpeg? ( virtual/ffmpeg )
	fftw? ( sci-libs/fftw:2.1 )
	fmod? ( media-libs/fmod )
	gles1? ( media-libs/mesa[gles1] )
	gles2? ( media-libs/mesa[gles2] )
	jpeg? ( virtual/jpeg )
	npapi? ( net-misc/npapi-sdk )
	ode? ( dev-games/ode )
	openal? ( media-libs/openal )
	opencv? ( media-libs/opencv )
	osmesa? ( media-libs/mesa[osmesa] )
	png? ( media-libs/libpng )
	python? ( ${PYTHON_DEPS} )
	rocket? ( dev-libs/libRocket )
	ssl? ( dev-libs/openssl )
	tiff? ( media-libs/tiff )
	truetype? ( media-libs/freetype )
	zlib? ( sys-libs/zlib )
	pstats? ( dev-cpp/gtkmm:2.4 )
	xml? ( dev-libs/tinyxml )
	xrandr? ( x11-libs/libXrandr )
	x11-libs/libXcursor
	x11-libs/libX11
	virtual/opengl"
RDEPEND="${COMMON_DEPEND}"
DEPEND="sys-devel/bison
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/${P}-pkgconfig.patch
)

use_no() {
	local UWORD="$2"
	if [ -z "${UWORD}" ]; then
		UWORD="$1"
	fi

	if use $1 ; then
		echo "--use-${UWORD}"
	else
		echo "--no-${UWORD}"
	fi
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	base_src_prepare

	# move bullet samples together with all the other examples
	if use examples; then
		mv "${WORKDIR}"/bullet-samples "${S}"/samples || die
	fi

	python_fix_shebang . || die

	#TODO: remove bundled libs
}

# TODO: fix makepanda.py to use pkg-config for nvidia-cg
src_compile() {
	if use cg; then
		append-flags "$($(tc-getPKG_CONFIG) --cflags nvidia-cg-toolkit)"
		append-ldflags "$($(tc-getPKG_CONFIG) --libs-only-L nvidia-cg-toolkit)"
	fi

	# TODO --use-xf86dga
	local myeconfargs=(
		--nothing
		--optimize=3
		--threads=$( makeopts_jobs )
		--use-deploytools
		--use-direct
		--use-gl
		--use-pandafx
		--use-pandaparticlesystem
		--use-pandaphysics
		--use-pandatool
		--use-pview
		--use-skel
		--use-touchinput
		--use-x11
		--use-xcursor
		$(use_no artoolkit)
		$(use_no bullet)
		$(use_no cg nvidiacg)
		$(use_no egl)
		$(use_no eigen)
		$(use_no contrib)
		$(use_no examples skel)
		$(use_no ffmpeg)
		$(use_no fftw)
		$(use_no fmod fmodex)
		$(use_no jpeg)
		$(use_no ode)
		$(use_no openal)
		$(use_no opencv)
		$(use_no osmesa)
		$(use_no python)
		$(use_no png)
		$(use_no pstats gtk2)
		$(use_no rocket)
		$(use_no squish)
		$(use_no sse sse2)
		$(use_no ssl openssl)
		$(use_no tiff)
		$(use_no truetype freetype)
		$(use_no zlib)
		$(use_no xrandr)
	)
	einfo "CXXFLAGS: ${CXXFLAGS}"
	einfo "LDFLAGS : ${LDFLAGS}"
	${PYTHON} ./makepanda/makepanda.py ${myeconfargs[@]} || die
}

src_install() {
	# TODO: remove the hardcoded rpm binary from the python script
	${PYTHON} ./makepanda/installpanda.py \
		--destdir="${ED}" \
		--prefix=/usr || die "install failed"

	# TODO: remove /usr/bin/ppython symlink

	# install PAnda3D's mime types
	domenu makepanda/panda3d.desktop
	domenu makepanda/pview.desktop

	# install python modules
	if use python ; then
		python_fix_shebang "${ED}"
		#python_optimize "${ED}"
	fi

	# install documentation
	if use doc; then
		docinto manual-cxx
		dohtml -r "${WORKDIR}"/manual-cxx/*

		docinto reference-cxx
		dohtml -r "${WORKDIR}"/reference-cxx/*

		if use python; then
			docinto manual-python
			dohtml -r "${WORKDIR}"/manual-python/*

			docinto reference-python
			dohtml -r "${WORKDIR}"/reference-python/*
		fi
	fi
}

pkg_postinst() {
	elog
	elog "For C++ compiling, include directory must be set:"
	elog "g++ -I/usr/include/panda3d [other flags]"
	elog
	elog "Tutorials available at http://panda3d.org"
	elog
}
