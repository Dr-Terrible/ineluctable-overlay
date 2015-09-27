# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils linux-info

DESCRIPTION="The ARToolKit library"
HOMEPAGE="http://www.hitl.washington.edu/artoolkit/"
SRC_URI="mirror://sourceforge/artoolkit/ARToolKit-${PV}.tgz"

S="${WORKDIR}/ARToolKit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug jpeg gstreamer dv v4l ieee1394 doc examples utils"
REQUIRED_USE="dv? ( ieee1394 )
	ieee1394? ( gstreamer )"

DEPEND="media-libs/freeglut
	virtual/opengl
	jpeg? ( virtual/jpeg:0 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		jpeg? ( media-plugins/gst-plugins-jpeg:1.0 )
		dv? (
			media-plugins/gst-plugins-dv:1.0
		)
		ieee1394? ( media-plugins/gst-plugins-raw1394:1.0 )
		v4l? ( media-plugins/gst-plugins-v4l2:1.0 )
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/ARToolKit"

pkg_setup() {
	CONFIG_CHECK=""

	if use ieee1394 ; then
		CONFIG_CHECK="${CONFIG_CHECK} IEEE1394 IEEE1394_OHCI1394 IEEE1394_VIDEO1394 FIREWIRE"

		if use dv ; then
			CONFIG_CHECK="${CONFIG_CHECK} IEEE1394_DV1394"
		fi
	fi
	if use v4l ; then
		CONFIG_CHECK="${CONFIG_CHECK} VIDEO_V4L1_COMPAT VIDEO_V4L2"
	fi
	[[ -n $CONFIG_CHECK ]] && linux-info_pkg_setup
}

src_prepare() {
	einfo "pwd: $( pwd )"
	mv "${S}"/Configure "${S}"/configure || die
	exit
}

#src_compile() {
#	local method
#	if use gstreamer; then
#		method="5"
#		if use dv; then
#			elog "Installing with Gstreamer framework with dv and ieee1394 support"
#		elif use ieee1394; then
#			elog "Installing with Gstreamer framework ieee1394 support."
#		elif use jpeg; then
#			elog "Installing with Gstreamer framework V4L and jpeg support."
#		else
#		elog "Installing with Gstreamer framework V4L support."
#		fi
#	elif use ieee1394; then
#		if use dv; then
#			method="3"
#			elog "Installing with ieee1394 and dv support, ignoring jpeg flag."
#		else
#			method="4"
#			elog "Installing with ieee1394 support, ignoring dv and jpeg flags."
#		fi
#	else
#		if use jpeg; then
#			method="2"
#			elog "Installing with Video4Linux + JPEG support, ignoring dv flag."
#			cp lib/SRC/VideoLinuxV4L/jpegtorgb.h include/AR
#		else
#			method="1"
#			elog "Installing with Video4Linux support."
#		fi
#	fi
#	{
#	{
#	sleep 2
#	echo "${method}"
#	sleep 2
#	if [ method="1" ] || [ method="2" ]; then
#		if linux_chkconfig_present 64BIT; then
#			echo n
#		else
#			echo y
#		fi
#	fi
#	sleep 2
#	if use debug; then
#		echo "y"
#	else
#		echo "n"
#	fi
#	sleep 2
#	echo "y"
#	} | econf --prefix=/usr
#	}  || die "Configuration failed!"
#	emake || die "make failed"
#}

src_install() {
	if use doc; then
		dodir /usr/share/doc/${PN}
		dohtml -r doc/*
	fi
	if use utils; then
		dodir /usr/share/apps/${PN}
		insinto /usr/share/apps/${PN}
		doins bin/calib* bin/graphicsTest bin/mk_patt bin/videoTest
	fi
	rm bin/calib* bin/graphicsTest bin/mk_patt bin/videoTest
	if use examples; then
		dodir /usr/share/doc/${PN}/examples
		insinto /usr/share/doc/${PN}/examples
		doins bin/*
	fi
	dodir /usr/include/AR
	insinto /usr/include/AR
	doins include/AR/*
	dodir /usr/include/AR/sys
	insinto /usr/include/AR/sys
	doins include/AR/sys/*
	insinto /usr/lib
	doins lib/*.a
}
