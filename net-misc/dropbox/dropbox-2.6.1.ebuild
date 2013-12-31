# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils gnome2-utils pax-utils systemd

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="http://dropbox.com/"
SRC_URI="
	x86? ( http://dl-web.dropbox.com/u/17/${PN}-lnx.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/${PN}-lnx.x86_64-${PV}.tar.gz )"

LICENSE="CC-BY-ND-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="+librsync-bundled X systemd cli"
RESTRICT="mirror strip"

QA_PREBUILT="opt/.*"
QA_EXECSTACK="opt/dropbox/dropbox"

DEPEND="librsync-bundled? ( dev-util/patchelf )"

# Be sure to have GLIBCXX_3.4.9, #393125
# USE=X require wxGTK's dependencies. system-library cannot be used due to
# missing symbol (CtlColorEvent). #443686
RDEPEND="
	X? (
		dev-libs/glib:2
		media-libs/libpng:1.2
		sys-libs/zlib
		virtual/jpeg
		x11-libs/gtk+:2
		x11-libs/libSM
		x11-libs/libXinerama
		x11-libs/libXxf86vm
		x11-libs/pango[X]
		x11-themes/hicolor-icon-theme
	)
	app-arch/bzip2
	dev-libs/popt
	net-misc/wget
	>=sys-devel/gcc-4.2.0
	sys-libs/zlib
	systemd? ( sys-apps/systemd )
	cli? ( net-misc/dropbox-cli )
	!librsync-bundled? ( net-libs/librsync )"

pkg_setup() {
	enewgroup dropbox
}

src_unpack() {
	unpack ${A}
	mkdir -p "${S}"
	mv "${WORKDIR}"/.dropbox-dist/* "${S}" || die
	rmdir .dropbox-dist || die
}

src_prepare() {
	rm libbz2* libpopt.so.0 libpng12.so.0 || die
	if use X ; then
		mv images/hicolor/16x16/status "${T}" || die
	else
		rm -r *wx* images || die
	fi
	if use librsync-bundled ; then
		patchelf --set-rpath '$ORIGIN' _librsync.so || die
	else
		rm librsync.so.1 || die
	fi
	#mv cffi-*.egg "${T}" || die
	#rm -r *.egg library.zip || die
	#mv "${T}"/cffi-*.egg "${S}" || die
	#ln -s dropbox library.zip || die
	pax-mark cm dropbox
	mv README ACKNOWLEDGEMENTS "${T}" || die
}

src_install() {
	local targetdir="/opt/dropbox"

	# installing dropbox
	insinto "${targetdir}"
	doins -r *
	dosym "${targetdir}/dropboxd" "/opt/bin/dropbox"
	use X && doicon -s 16 -c status "${T}"/status

	# fixing perms
	fperms ug+x "${targetdir}"/{dropbox,dropboxd}
	fowners -R root:dropbox "${targetdir}"

	# installing init scripts
	newinitd "${FILESDIR}"/${PN}.initd dropbox
	newconfd "${FILESDIR}"/${PN}.confd dropbox
	if use systemd; then
		cp "${FILESDIR}"/${PN}.service "${T}"/${PN}.service

		if use X; then
cat <<EOF >> "${T}"/${PN}.service

[Service]
Environment=DISPLAY=%i

[Unit]
After=xorg.target
EOF
		fi

		systemd_newunit "${T}"/${PN}.service "${PN}@.service"
		systemd_install_serviced "${FILESDIR}"/${PN}.service.conf
	fi

	dodoc "${T}"/{README,ACKNOWLEDGEMENTS}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "You must be in the 'dropbox' group to use DropBox."
	elog "Just run (replace <USER> with the desired username):"
	elog "    gpasswd -a <USER> dropbox"
	elog
	elog "then have <USER> re-login."

	if use systemd; then
		elog
		elog "If you want to enable the service for a specific user, so that it will"
		elog "start when the user login into the system, then execute the following"
		elog "commands (replace <USER> with the desired username):"
		elog "   systemctl enable dropbox@<USER>"
		elog "   systemctl start dropbox@<USER>"

		if ! use X; then
			elog
			elog "You installed dropbox without the USE flag 'X', which means"
			elog "the service will run Dropbox as a daemon that syncs your data"
			elog "in the background. No icon will be available in the system tray."
			elog "Enable the USE flag 'X' if you want to have tray support."
		fi
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}