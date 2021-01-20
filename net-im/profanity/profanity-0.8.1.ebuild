# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A console based XMPP client inspired by Irssi"
HOMEPAGE="http://www.profanity.im"
SRC_URI="https://profanity-im.github.io/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="libnotify libressl otr gpg xscreensaver"

DEPEND="
	dev-libs/expat
	dev-libs/glib
	dev-libs/libstrophe:=
	net-misc/curl
	sys-apps/util-linux
	sys-libs/ncurses:=[unicode]
	gpg? ( app-crypt/gpgme:= )
	libnotify? ( x11-libs/libnotify )
	otr? ( net-libs/libotr )
	xscreensaver? (
		x11-libs/libXScrnSaver
		x11-libs/libX11 )
	"
RDEPEND="${DEPEND}
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )"

src_configure() {
	econf \
		$(use_enable libnotify notifications) \
		$(use_enable otr) \
		$(use_enable gpg pgp) \
		$(use_with xscreensaver)
}
