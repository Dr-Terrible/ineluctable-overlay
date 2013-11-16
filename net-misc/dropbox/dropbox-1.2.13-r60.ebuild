# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#TODO:
# 1- add use 'gui';
# 2- remove wxGTK /libpng bundled libs only if USE 'server' is enabled and
# USE 'gui' enabled;

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_USE_WITH=sqlite
inherit user eutils python-r1
use gtk && inherit wxwidgets

DESCRIPTION="Official Dropbox CLI"
HOMEPAGE="http://dropbox.com"
SRC_URI="x86? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86_64-${PV}.tar.gz )"

LICENSE="dropbox-EULA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="server gtk"
RESTRICT="mirror strip"

COMMON_DEPEND="x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libSM
	x11-libs/libXrandr
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXcomposite
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/gdk-pixbuf
	dev-libs/dbus-glib
	sys-apps/dbus
	dev-python/dbus-python
	dev-libs/atk
	media-libs/libpng:1.2
	media-libs/fontconfig
	sys-libs/zlib
	app-arch/bzip2
	x11-libs/pango
	x11-libs/gtk+:2
	dev-libs/popt"
#	dev-libs/openssl
#	dev-db/sqlite
#	x11-libs/wxGTK:2.8[X]"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	sys-libs/ncurses
	net-misc/wget
	x11-libs/libnotify"

S="${WORKDIR}/.dropbox-dist"

remove_bundled_lib() {
	einfo "Removing bundled library $1 ..."
	local output="$(find $1 -print -delete)" \
		|| die "failed to remove bundled library $1"
	[[ -z $output ]] && die "no files matched when removing bundled library $1"
}

pkg_setup() {
	enewgroup dropbox
}

src_prepare() {
#	remove_bundled_lib "libdbus-1.so.3"
#	remove_bundled_lib "libdbus-glib-1.so.2"
#	remove_bundled_lib "libsqlite3.so.0"

#	remove_bundled_lib "libz.so.1"
#	remove_bundled_lib "libstdc++.so.6"
#	remove_bundled_lib "libpopt.so.0"

#	if ! use gtk; then
#		remove_bundled_lib "libpng12.so.0"
#		remove_bundled_lib "libwx_baseud-2.8.so.0"
#		remove_bundled_lib "libwx_baseud_net-2.8.so.0"
#		remove_bundled_lib "libwx_baseud_xml-2.8.so.0"
#		remove_bundled_lib "libwx_gtk2ud_adv-2.8.so.0"
#		remove_bundled_lib "libwx_gtk2ud_core-2.8.so.0"
#		remove_bundled_lib "libwx_gtk2ud_qa-2.8.so.0"
#	fi
:;
}

src_install() {
	# installing files
	local DESTDIR="/opt/${PN}"
	insinto "${DESTDIR}"
	if use server; then
		doins -r \
			dropboxd dropbox library.zip \
			_functools.so _ctypes.so _struct.so _random.so _weakref.so \
			_lsprof.so _librsync.so \
			math.so binascii.so time.so collections.so array.so \
			operator.so datetime.so cStringIO.so itertools.so \
			cPickle.so select.so fcntl.so unicodedata.so termios.so \
			librsync.so.1 libbz2.so.1.0 \
			netifaces-0.5-py2.5-linux-i686.egg \
			|| die "doins server failed"
	fi
	if use gtk; then
		doins -r * || die "doins failed"
	fi

	# create dropbox executable with right perms
	fowners root:dropbox "${DESTDIR}"/dropbox
	fperms 0750 "${DESTDIR}"/dropbox
	dosym "${DESTDIR}"/dropbox /opt/bin/dropbox

	# create dropboxs executable with right perms
	if use server; then
		fowners root:dropbox "${DESTDIR}"/dropboxd
		fperms 0750 "${DESTDIR}"/dropboxd
		dosym "${DESTDIR}"/dropboxd /opt/bin/dropboxd
		newinitd "${FILESDIR}"/dropboxd-initd dropboxd
		newconfd "${FILESDIR}"/dropboxd-confd dropboxd
	else
		rm "${D}"/"${DESTDIR}"/dropboxd || die
	fi

	# installing icon and desktop entry.
	newicon "${FILESDIR}"/dropbox_logo.png ${PN}-logo.png || die
	make_desktop_entry dropbox \
		"Dropbox ${PV}" "${PN}-logo" \
		"Network;FileTransfer;P2P"

	# installing revdep-rebuild mask
	dodir  /etc/revdep-rebuild/
	echo "SEARCH_DIRS_MASK=\"${DESTDIR}\"" > "${D}/etc/revdep-rebuild/99-${PN}"
	elog "A revdep-rebuild control file has been installed to prevent"
	elog "reinstalls due to missing dependencies,"
}

pkg_postinst() {
	echo
	elog "You must be in the 'dropbox' group to use Dropbox."
	elog "Just run 'gpasswd -a <USER> dropbox', then have <USER> re-login."
	echo

	if use server ; then
		echo
		ewarn "In order to use the Dropbox init script you must set the"
		ewarn "DROPBOX_USER variable in ${ROOT%/}/etc/conf.d/dropboxd"
		ewarn "to your username."
		echo
	fi
}
