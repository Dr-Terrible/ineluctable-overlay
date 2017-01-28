# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils user

APP_NAME="CodeXL"

DESCRIPTION="CPU/GPU debugging and profiling suite by AMD"
HOMEPAGE="http://developer.amd.com/tools/heterogeneous-computing/codexl/"
SRC_URI="https://github.com/GPUOpen-Tools/${PN}/releases/download/v2.2/${APP_NAME}_Linux_x86_64_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AMD LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"

IUSE="doc"
RESTRICT="strip mirror test"

# NOTE: dev-libs/boost:58, icu:54, and x11-libs/qscintilla:0/11 are no more in portage
RDEPEND="dev-libs/boost
	dev-db/sqlite:3
	dev-util/oprofile
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-libs/libxslt:0
	dev-libs/qcustomplot:0
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtpositioning:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsensors:5
	dev-qt/qtsql:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/glu:0
	media-libs/mesa:0
	media-sound/pulseaudio:0
	media-libs/libpng:1.2
	sys-libs/zlib:0
	x11-libs/gtk+:2
	x11-libs/libICE:0
	x11-libs/libSM:0
	x11-libs/libX11:0
	x11-libs/libxcb:0
	x11-libs/libXcomposite:0
	x11-libs/libXcursor:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXft:0
	x11-libs/libXi:0
	x11-libs/libXinerama:0
	x11-libs/libXrender:0
	>=dev-util/perf-3.15.0[unwind]
	virtual/opencl"

S="${WORKDIR}"/${APP_NAME}_Linux_x86_64_${PV}

DOCS=(
	CodeXL_Release_Notes.pdf Readme.txt
	Legal/GNU_LESSER_GENERAL_PUBLIC_LICENSE2_1.pdf
)

# Ignore QA warnings since we can't fix it:
QA_PREBUILT="*"
QA_FLAGS_IGNORED="*"

pkg_setup() {
	enewgroup amdcxl
}

src_prepare() {
	default

	einfo "Removing bundled libs ..."
	rm -r libGLEW.so* || die
	#rm -r libboost* || die
	rm -r RuntimeLibs/QT/libQt* || die
	rm -r RuntimeLibs/x86_64 || die
	rm -r RuntimeLibs/x86 || die
	#rm -r libqscintilla* || die

	# fixing desktop menu entries
	for menu in "${S}"/*.desktop; do
		sed -i -e "s:Application;::" \
			"${menu}" || die
	done
}

src_install() {
	# installing documentation
	dodoc "${DOCS[@]}"
	if use doc; then
		dodoc \
			SDK/CXLActivityLogger/doc/AMDTActivityLogger.pdf \
			SDK/CXLPowerProfile/doc/AMDTPowerProfileAPI.pdf \
			Help/CodeXL_Quick_Start_Guide.pdf
		dodoc -r "${S}"/webhelp/*
	fi
	rm SDK/CXLActivityLogger/doc/AMDTActivityLogger.pdf || die
	rm SDK/CXLPowerProfile/doc/AMDTPowerProfileAPI.pdf || die\
	rm Help/CodeXL_Quick_Start_Guide.pdf || die
	rm -r "${DOCS[@]}" || die
	rm -r "${S}"/webhelp/ || die

	# installing desktop menu entries
	insopts -m0655
	insinto /usr/share/applications
	doins "${S}"/*.desktop
	rm "${S}"/*.desktop || die

	# installing application
	insinto /opt/AMD/${APP_NAME}
	doins -r "${S}"/*

	# installing executables
	dodir /opt/bin
	dosym /opt/AMD/${APP_NAME}/${APP_NAME} /opt/bin/${APP_NAME} || die

	# Fixing owners and permissions
	fowners -R root:amdcxl /opt/AMD/${APP_NAME}
	#fperms -R ug+s "${S}"
}

pkg_postinst() {
	elog "For non-root users to run CodeXL CPU profiling,"
	elog "you need to set:"
	elog "  echo '-1' > /proc/sys/kernel/perf_event_paranoid"
}
