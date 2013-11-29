# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit user multilib

APP_NAME="CodeXL"

DESCRIPTION="CPU/GPU debugging and profiling suite by AMD"
HOMEPAGE="http://developer.amd.com/tools/heterogeneous-computing/codexl/"
SRC_URI="amd64? ( http://developer.amd.com/download/AMD_${APP_NAME}_Linux_x86_64_${PV}.tar.gz -> ${P}.x86_64.tar.gz )"

LICENSE="AMD LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

IUSE="opencl doc examples"
RESTRICT="strip mirror"

# NOTE: opencl only works with AMD so no virtual is used
RDEPEND="${DEPEND}
	dev-libs/glib
	dev-libs/libxml2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/glew
	media-libs/glu
	media-libs/libpng:1.2
	sys-libs/zlib
	x11-libs/gtk+
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	media-libs/libpng:1.2
	dev-util/perf
	amd64? ( dev-util/perf[unwind] )
	opencl? ( >=x11-drivers/ati-drivers-13.11_beta )"

S="${WORKDIR}"/AMD_${APP_NAME}_Linux_x86_64_${PV}/bin

# Ignore QA warnings for this closed-source app, since we can't fix it:
QA_PREBUILT="*"
QA_FLAGS_IGNORED="*"

pkg_setup() {
	enewgroup amdcxl
}
src_prepare() {
	einfo "Removing bundled libs"
	rm -r libGLEW.so* || die
	rm -r libboost* || die
}
src_install() {
	# installing documentation
	local DOCS=(AMD_CodeXL_Release_Notes.pdf Readme.txt Help/CodeXL_Quick_Start_Guide.pdf Legal/GNU_LESSER_GENERAL_PUBLIC_LICENSE2_1.pdf)
	dodoc -r "${DOCS[@]}" || die
	if use doc; then
		dohtml -r "${S}"/webhelp/ || die
	fi
	rm -r "${DOCS[@]}" || die
	rm -r "${S}"/webhelp/ || die

	# installing examples
	if ! use examples; then
		rm -r "${S}"/examples || die
	fi

	# installing desktop menu entries
	insopts -m0655
	insinto /usr/share/applications
	doins "${S}"/amdcodexlicon.desktop "${S}"/amdremoteagenticon.desktop
	rm "${S}"/amdcodexlicon.desktop "${S}"/amdremoteagenticon.desktop || die

	# installing application
	insinto /opt/AMD/${APP_NAME}
	doins -r "${S}"

	# installing executables
	dodir /opt/bin
	dosym /opt/AMD/${APP_NAME}/bin/${APP_NAME} /opt/bin/${APP_NAME} || die

	# Fixing owners and permissions
	fowners -R root:amdcxl /opt/AMD/${APP_NAME}
	#fperms -R ug+s "${S}"/bin
}