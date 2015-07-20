# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils user

APP_NAME="CodeXL"

DESCRIPTION="CPU/GPU debugging and profiling suite by AMD"
HOMEPAGE="http://developer.amd.com/tools/heterogeneous-computing/codexl/"
SRC_URI="http://developer.amd.com/download/AMD_${APP_NAME}_Linux_x86_64_${PV}.tar.gz -> ${P}.x86_64.tar.gz"

LICENSE="AMD LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"

IUSE="opencl doc"
RESTRICT="strip mirror test"

# NOTE: opencl only works with AMD CPU/GPU so no virtual is used
# NOTE: x11-libs/qscintilla:0/11
# DEPRECATED: >=x11-libs/gtkglext-1.2.0-r2:0
RDEPEND="dev-libs/boost
	dev-db/sqlite:3
	dev-util/oprofile
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-libs/libxslt:0
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
	x11-libs/libXcursor:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXft:0
	x11-libs/libXi:0
	x11-libs/libXinerama:0
	x11-libs/libXrender:0
	>=dev-util/perf-3.15.0[unwind]
	opencl? ( >=x11-drivers/ati-drivers-14.12 )"

S="${WORKDIR}"/AMD_${APP_NAME}_Linux_x86_64_${PV}

DOCS=(
	AMD_CodeXL_Release_Notes.pdf Readme.txt
	Legal/GNU_LESSER_GENERAL_PUBLIC_LICENSE2_1.pdf
)

# Ignore QA warnings for this closed-source app, since we can't fix it:
QA_PREBUILT="*"
QA_FLAGS_IGNORED="*"

pkg_setup() {
	enewgroup amdcxl
}
src_prepare() {
	einfo "Removing bundled libs ..."
	rm -r libGLEW.so* || die
	rm -r libboost* || die
	rm -r libQt* || die
	rm -r libstdc++* || die
	rm -r x86_64/libstdc++* || die
	rm -r x86/libstdc++* || die
#	rm -r libqscintilla* || die

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
		dodoc AMDTActivityLogger/doc/AMDTActivityLogger.pdf
		dodoc Help/CodeXL_Quick_Start_Guide.pdf
		dohtml -r "${S}"/webhelp/*
	fi
	rm "${S}"/AMDTActivityLogger/doc/AMDTActivityLogger.pdf || die
	rm "${S}"/Help/CodeXL_Quick_Start_Guide.pdf || die
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