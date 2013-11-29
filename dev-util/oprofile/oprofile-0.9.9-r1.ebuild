# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils linux-info multilib user java-pkg-opt-2

MY_P=${PN}-${PV/_/-}
DESCRIPTION="A transparent low-overhead system-wide profiler"
HOMEPAGE="http://${PN}.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="java pch qt4"

DEPEND=">=dev-libs/popt-1.7-r1
	>=sys-devel/binutils-2.14.90.0.6-r3
	>=sys-libs/glibc-2.3.2-r1
	qt4? ( dev-qt/qtgui:4[qt3support] )
	java? ( >=virtual/jdk-1.5 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	linux-info_pkg_setup
	if ! linux_config_exists || ! linux_chkconfig_present OPROFILE ; then
		echo
		elog "In order for ${PN} to work, you need to configure your kernel"
		elog "with CONFIG_OPROFILE set to 'm' or 'y'."
		echo
	fi

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
	econf \
		--includedir="${EPREFIX}/include/${PN}" \
		--disable-werror \
		$(use_with qt4 x) \
		$(use_enable qt4 gui qt4) \
		$(use_enable pch) \
		$(use_with java java ${JAVA_HOME})
}

src_install() {
	emake DESTDIR="${D}" htmldir="/usr/share/doc/${PF}" install

	# installing missing headers
	insinto /usr/include/"${PN}"
	doins libop/op_sample_file.h
	doins libutil++/op_bfd.h libutil++/string_filter.h
	doins libpp/profile.h libpp/parse_filename.h libpp/arrange_profiles.h libpp/locate_images.h libpp/image_errors.h libpp/populate_for_spu.h
	doins libregex/demangle_symbol.h
	doins libutil/op_types.h libutil/op_list.h
	doins libutil++/bfd_support.h libutil++/utility.h libutil++/cached_value.h libutil++/op_exception.h
	doins libdb/odb.h

	dodoc ChangeLog* README TODO

	dodir /etc/env.d
	echo "LDPATH=${PREFIX}/usr/$(get_libdir)/${PN}" > "${D}"/etc/env.d/10${PN} || die "env.d failed"
}

pkg_postinst() {
	echo
	elog "Now load the ${PN} module by running:"
	elog "  # opcontrol --init"
	elog "Then read manpages and this html doc:"
	elog "  /usr/share/doc/${PF}/${PN}.html"
	echo
}
