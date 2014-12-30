# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit autotools cvs eutils python-single-r1

DESCRIPTION="Panda3D is a framework for 3D rendering and game development"
HOMEPAGE="http://www.panda3d.org"

ECVS_SERVER="panda3d.cvs.sourceforge.net:/cvsroot/panda3d"
ECVS_MODULE="panda3d"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+cg doc ffmpeg fftw fmod +gtk jpeg ode +openal opencv png +python ssl +threads tiff truetype xml +zlib"

RESTRICT="mirror"

RDEPEND="cg? ( media-gfx/nvidia-cg-toolkit )
		dev-libs/libtar
		doc? ( dev-python/epydoc )
		ffmpeg? ( media-video/ffmpeg:0 )
		fftw? ( sci-libs/fftw:2.1 )
		fmod? ( media-libs/fmod:1 )
		gtk? ( x11-libs/gtk+:2 )
		jpeg? ( virtual/jpeg:0 )
		ode? ( dev-games/ode )
		openal? ( media-libs/openal )
		opencv? ( media-libs/opencv )
		png? ( media-libs/libpng:0 )
		python? ( dev-lang/python )
		ssl? ( dev-libs/openssl:0 )
		tiff? ( media-libs/tiff:0 )
		truetype? ( media-libs/freetype )
		virtual/opengl
		xml? ( dev-libs/tinyxml )
		zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
		sys-devel/automake:1.11"

S=${WORKDIR}/${ECVS_MODULE}

panda_cfg() {
	for str in "$@"; do
		echo "${str}" >> Config.pp
	done
}

panda_enable() {
	for str in "$@"; do
		panda_cfg "#define HAVE_${str} 1"
	done
}

panda_disable() {
	for str in "$@"; do
		panda_cfg "#define HAVE_${str}"
	done
}

pkg_setup() {
	use python && python_set_active_version 2
}

src_unpack() {
	cvs_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-jpegint.patch

	cd ppremake
	eautoreconf
}

src_configure() {
	export PPREMAKE_CONFIG="${S}/Config.pp"
	export PATH="${D}opt/panda3d/bin:${PATH}"
	export LD_LIBRARY_PATH="${D}opt/panda3d/lib:${LD_LIBRARY_PATH}"

	# Config.pp
	echo "#define INSTALL_DIR ${D}opt/panda3d" > Config.pp
	use python && {
		panda_enable PYTHON
		panda_cfg "#define PYTHON_IPATH $(python_get_includedir)"
	} || panda_disable PYTHON
	use ssl && {
		panda_enable OPENSSL
		panda_cfg "#define OPENSSL_IPATH /usr/include" "#define OPENSSL_LPATH /usr/lib"
	} || panda_disable OPENSSL
	use jpeg && panda_enable JPEG || panda_disable JPEG
	use png && panda_enable PNG || panda_disable PNG
	use tiff && panda_enable TIFF || panda_disable TIFF
	use fftw && panda_enable FFTW || panda_disable FFTW
	use cg && {
		panda_enable CG
		panda_cfg "#define CG_IPATH	/opt/nvidia-cg-toolkit/include" "#define CG_LPATH /opt/nvidia-cg-toolkit/lib"
	} || panda_disable CG
	use zlib && panda_enable ZLIB || panda_disable ZLIB
	use opencv && {
		panda_enable OPENCV
		panda_cfg "#define OPENCV_IPATH /usr/include/opencv"
	} || panda_disable OPENCV
	use ffmpeg && panda_enable FFMPEG || panda_disable FFMPEG
	use ode && panda_enable ODE || panda_disable ODE
	use threads && panda_enable THREADS || panda_disable THREADS
	use fmod && {
		panda_enable FMODEX
		panda_cfg "#define FMODEX_IPATH /opt/fmodex/api/inc" "#define FMODEX_LPATH /opt/fmodex/api/lib"
	} || panda_disable FMODEX
	use openal && panda_enable OPENAL || panda_disable OPENAL
	use xml && panda_enable TINYXML || panda_disable TINYXML
	use gtk && panda_enable GTK || panda_disable GTK
	use truetype && panda_enable FREETYPE || panda_disable FREETYPE

	# disable some magic deps
	panda_disable SQUISH BDB VRPN HELIX MESA SDL AWESOMIUM NPAPI TAU PHYSX CHROMIUM WX MAYA SOFTIMAGE FCOLLADA ARTOOLKIT

	# custom CFLAGS
	panda_cfg "#define CFLAGS_OPT3 \$[CDEFINES_OPT3:%=-D%] ${CFLAGS}"

	cd ppremake
	econf --prefix="${D}opt/panda3d"
	emake install || die
	cd ..
	for d in dtool panda direct pandatool; do
		cd ${d}
		../ppremake/ppremake
		cd ..
	done
}

src_compile() {
	for d in dtool panda direct pandatool; do
		cd ${d}
		if [ ${d} == "dtool" -o ${d} == "panda" ]; then
			emake install || die
		else
			emake || die
		fi
		cd ..
	done
}

src_install() {
	for d in dtool panda direct pandatool; do
		cd ${d}
		../ppremake/ppremake
		emake install || die
		cd ..
	done
	## we can't put the lib dir in the common environment because at least one
	## shared library (libnet.so) clashes with another package
	#doenvd "${FILESDIR}"/50panda3d
	#sed -i -e "s:lib:$(get_libdir):g" \
		#"${D}"/etc/env.d/50panda3d \
		#|| die "libdir patching failed"

	if use doc; then
		cp -R "${S}"/doc "${D}"/opt/panda3d/
		cp -R "${S}"/models "${D}"/opt/panda3d/
	fi

	if use python ; then
		genPyCode || die
		dodir $(python_get_sitedir)
		cat <<- EOF > "${D}"$(python_get_sitedir)/panda3d.pth
		# This document sets up paths for python to access the
		# panda3d modules
		/opt/panda3d/lib
		/opt/panda3d/lib/direct
		/opt/panda3d/lib/pandac
		EOF
		cat <<- EOF > "${D}"/opt/panda3d/etc/Config.prc
		default-model-extension .egg
		model-path .
		EOF
	fi
	exeinto "/usr/bin"
	doexe "${FILESDIR}/panda3d"
}

pkg_postinst()
{
	elog "Panda3d is installed in /opt/panda3d"
	elog "Use the 'panda3d' wrapper to run the programs. E.g.: 'panda3d pview -h'"
	elog
	if use doc ; then
		elog "Documentation is available in /opt/panda3d/doc"
		elog "Models are available in /opt/panda3d/models"
	fi
	elog "For C++ compiling, the include directory must be set:"
	elog "g++ -I/opt/panda3d/include [other flags]"
	if use python ; then
		elog
		elog "ppython is deprecated and panda3d modules are"
		elog "now installed as standard python modules."
		elog "You need to use the 'panda3d' wrapper with the python interpreter."
	fi
	elog
	elog "Tutorials available at http://panda3d.org"
}