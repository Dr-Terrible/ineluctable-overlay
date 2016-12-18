# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit eutils vala autotools gnome2

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://github.com/thestinger/${PN}"
SRC_URI="https://github.com/thestinger/${PN}/archive/${PV}.a.tar.gz -> ${PF}.tar.gz"

LICENSE="LGPL-2+"
SLOT="2.91"
IUSE="crypt debug"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=dev-libs/libpcre2-10.21
	>=x11-libs/gtk+-3.8:3
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	sys-libs/zlib

	crypt?  ( >=net-libs/gnutls-3.2.7 )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2
	dev-util/gtk-doc
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
"

S="${WORKDIR}/${P}.a"

src_prepare() {
	eautoreconf

	# build fails because of -Werror with gcc-5.x
	sed -e 's#-Werror=format=2#-Wformat=2#' -i configure || die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	local myconf=""

	if [[ ${CHOST} == *-interix* ]]; then
		myconf="${myconf} --disable-Bsymbolic"

		# interix stropts.h is empty...
		export ac_cv_header_stropts_h=no
	fi

	# NOTE: we force LINGUAS to 'en' to avoid affecting autoconf
	# macros that install gettext catalog files (*.mo), otherwise
	# (*.mo) files are installed even when --disable-nls is used
	export LINGUAS="en"

	gnome2_src_configure \
		--libdir="${EPREFIX}/usr/$(get_libdir)/${PN}" \
		--includedir="${EPREFIX}/usr/include/${PN}" \
		--disable-test-application \
		--disable-static \
		--disable-glade-catalogue \
		--disable-nls \
		--disable-introspection \
		--disable-vala \
		$(use_with crypt gnutls) \
		$(use_enable debug) \
		${myconf}
}

src_install() {
	gnome2_src_install

	# fix pkg-config
	mkdir -p "${D}"/usr/$(get_libdir)/pkgconfig || die
	mv \
		"${D}"/usr/$(get_libdir)/${PN}/pkgconfig/${PN//-ng/}-${SLOT}.pc \
		"${D}"/usr/$(get_libdir)/pkgconfig/${PN}-${SLOT}.pc || die

	# remove nls/profile files
	rm -r "${D}"/etc/profile.d || die
}
