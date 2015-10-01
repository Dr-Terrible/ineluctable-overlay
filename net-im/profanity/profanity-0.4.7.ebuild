# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="Profanity is a console based XMPP client inspired by irssi"
HOMEPAGE="http://profanity.im"
SRC_URI="https://github.com/boothj5/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~arm"
IUSE="libnotify +otr +themes xscreensaver pgp test"

CDEPEND="dev-libs/glib:2
	dev-libs/libstrophe
	net-misc/curl
	sys-apps/util-linux:0
	sys-libs/ncurses:0/5
	sys-libs/readline:0
	libnotify? (
		x11-libs/libnotify
	)
	otr? ( net-libs/libotr )
	pgp? ( app-crypt/gpgme )
	xscreensaver? ( x11-libs/libXScrnSaver )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	test? (
		dev-util/cmocka
	)"
RDEPEND="${CDEPEND}
	libnotify? ( virtual/notification-daemon )"

src_configure() {
	local myeconfargs=(
		--with-libxml2
		$(use_enable libnotify notifications)
		$(use_enable otr)
		$(use_enable pgp)
		$(use_with themes)
		$(use_with xscreensaver)
	)
	autotools-utils_src_configure
}

pkg_postinst() {
	elog "Profanity User Guide is available online at the following URI:"
	elog "http://www.profanity.im/userguide.html"
}