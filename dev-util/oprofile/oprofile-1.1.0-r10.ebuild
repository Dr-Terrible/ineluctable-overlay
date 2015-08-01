# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit user java-pkg-opt-2 linux-info autotools-utils

MY_P=${PN}-${PV/_/-}
DESCRIPTION="A transparent low-overhead system-wide profiler"
HOMEPAGE="http://${PN}.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="java pch X static-libs test"

CDEPEND=">=dev-libs/popt-1.7-r1
	>=sys-devel/binutils-2.14.90.0.6-r3:*[cxx,zlib]
	virtual/libc
	java? ( >=virtual/jdk-1.5:= )"
DEPEND="${CDEPEND}
	>=sys-kernel/linux-headers-2.6.31"
RDEPEND="${CDEPEND}
	dev-util/perf"

S="${WORKDIR}/${MY_P}"

CONFIG_CHECK="PERF_EVENTS"
ERROR_PERF_EVENTS="CONFIG_PERF_EVENTS is mandatory for ${PN} to work."

CONFIG_CHECK="~!OPROFILE"
ERROR_OPROFILE="CONFIG_OPROFILE is no longer used, you may remove it from your kernels."

pkg_setup() {
	linux-info_pkg_setup
	if ! kernel_is -ge 2 6 ; then
		echo
		elog "Support for kernels before 2.6 has been dropped in ${PN}-0.9.8."
		echo
	fi

	# Required for JIT support, see README_PACKAGERS
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}

	use java && java-pkg_init
}

src_configure() {
	local myeconfargs=(
		--includedir="${EPREFIX}/usr/include/${PN}"
		--disable-dependency-tracking
		--disable-werror
		--disable-account-check
		$(use_with java java ${JAVA_HOME})
		$(use_with X x)
		$(use_enable pch)
		$(use_enable static-libs static)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install htmldir="/usr/share/doc/${PF}"

	dodir /etc/env.d
	echo "LDPATH=${PREFIX}/usr/$(get_libdir)/${PN}" > "${T}/10${PN}"
	doenvd "${T}/10${PN}"
}

pkg_postinst() {
	echo
	elog "Starting from ${PN}-1.0.0 opcontrol was removed, use operf instead."
	elog "Please read manpages and this html doc:"
	elog "  /usr/share/doc/${PF}/${PN}.html"
	echo
}