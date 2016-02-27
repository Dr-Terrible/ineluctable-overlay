# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs eutils

DESCRIPTION="Xynth is a portable embedded windowing system"
HOMEPAGE="http://alperakcan.net/?open=projects&project=xynth"
SRC_URI="mirror://sourceforge/xynth/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="server client opengl debug vesa svga sdl fbdev"

DEPEND=""
RDEPEND="sdl? ( >=media-libs/libsdl-1.2.8-r1 )
svga? ( >=media-libs/svgalib-1.9.21-r1 )
vesa? ( >=sys-libs/lrmi-0.8 )"

S="${WORKDIR}/${PN}/"

src_compile() {
	# SDL configuration process
	if use sdl; then
		sed -i -e "s:VIDEO_SDL       = N:VIDEO_SDL       = Y:" Makefile.cfg \
			|| die "Impossible to enable SDL in Makeconfig.cfg"
		einfo "Enabled SDL support"
	else
		sed -i -e "s:VIDEO_SDL       = Y:VIDEO_SDL       = N:" Makefile.cfg \
			|| die "Impossible to disable SDL configuration in Makeconfig.cfg"
		ewarn "Disabled SDL support"

	fi

	# VESA configuration process
	if use vesa; then
		sed -i -e "s:VIDEO_VESA      = N:VIDEO_VESA      = Y:" Makefile.cfg \
			|| die "Impossible to enable VESA in Makeconfig.cfg"
		einfo "Enabled VESA support"
	else
		sed -i -e "s:VIDEO_VESA      = Y:VIDEO_VESA      = N:" Makefile.cfg \
			|| die "Impossible to disable VESA in Makeconfig.cfg"
		ewarn "Disabled VESA support"
	fi

	# FB configuration process
	if use fbdev; then
		sed -i -e "s:VIDEO_FBDev     = N:VIDEO_FBDev     = Y:" Makefile.cfg \
			|| die "Impossible to enable FBDeve in Makeconfig.cfg"
		einfo "Enabled FBDev support"
	else
		sed -i -e "s:VIDEO_FBDev     = Y:VIDEO_FBDev     = N:" Makefile.cfg \
			|| die "Impossible to disable FBDev in Makeconfig.cfg"
		ewarn "Disabled FBDev support"
	fi

	# SVGAlib configuration process
	if use svga; then
		sed -i -e "s:VIDEO_SVGAlib   = N:VIDEO_SVGAlib   = Y:" Makefile.cfg \
			|| die "Impossible to enable SVGAlib in Makeconfig.cfg"
		einfo "Enabled SVGAlib support"
	else
		sed -i -e "s:VIDEO_SVGAlib   = Y:VIDEO_SVGAlib   = N:" Makefile.cfg \
			|| die "Impossible to disable SVGAlib in Makeconfig.cfg"
		ewarn "Disabled SVGAlib support"
	fi

	# DEBUG
	if use debug; then
		sed -i -e "s:DEBUG           = N:DEBUG           = Y:" Makefile.cfg \
			|| die "Impossible to enable the Debugger in Makefile.cfg"
		einfo "Enabled Debugger"
		STRIPE=""
	else
		sed -i -e "s:DEBUG           = Y:DEBUG           = N:" Makefile.cfg \
	    	|| die "Impossible to enable the Debugger in Makefile.cfg"
		ewarn "Disabled Debugger"
		STRIPE="-s"
	fi

	# disable Xynth CFLAGS settings, instead use the one provided by the user
	# in make.conf
	sed -i -e "s:CFLAGS += -O:#CFLAGS += -O:" Makefile.cfg \
		|| die "Impossible to patch Makefile.cfg"

	# compilation process
	einfo "Begin compilation process"
	emake ${STRIPE} || die "compilation problems"
}

src_install() {
	emake _INSTALLDIR="${ED}usr/local/" install || die "emake install failed"
	#dodoc AUTHORS README
}

pkg_postinst() {
	# final message

	if use fbdev; then
		echo
		ewarn "You have selected the USE 'fbdev'. To use it you must enable a fb into the kernel."
		echo
	fi

	echo
	einfo "To start the program type:"
	einfo "xynth& sleep2; desktop"
	einfo "or"
	einfo "xynth& sleep2; term"
	echo
}
