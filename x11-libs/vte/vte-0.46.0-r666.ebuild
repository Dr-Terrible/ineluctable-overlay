# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit eutils vala autotools gnome2

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://github.com/thestinger/${PN}-ng"
SRC_URI="https://github.com/thestinger/${PN}-ng/archive/${PV}.a.tar.gz -> ${PF}.tar.gz"

LICENSE="LGPL-2+"
SLOT="2.91"
IUSE="+crypt debug glade +introspection vala nls static-libs test"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=x11-libs/gtk+-3.8:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	sys-libs/zlib

	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	dev-libs/libpcre2
	virtual/pkgconfig

	crypt?  ( >=net-libs/gnutls-3.2.7 )
	vala? ( $(vala_depend) )
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
"

S="${WORKDIR}/${PN}-ng-${PV}.a"

src_prepare() {
	eautoreconf
	use vala && vala_src_prepare

	# build fails because of -Werror with gcc-5.x
	#sed -e 's#-Werror=format=2#-Wformat=2#' -i configure || die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	local myconf=""

	if [[ ${CHOST} == *-interix* ]]; then
		myconf="${myconf} --disable-Bsymbolic"

		# interix stropts.h is empty...
		export ac_cv_header_stropts_h=no
	fi

	# Python bindings are via gobject-introspection
	# Ex: from gi.repository import Vte
	gnome2_src_configure \
		$(use_with crypt gnutls) \
		$(use_enable debug) \
		$(use_enable glade glade-catalogue) \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		${myconf}
}

src_install() {
	gnome2_src_install
	mv "${D}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
