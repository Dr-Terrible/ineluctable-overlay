# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7)
inherit user python-r1 gnome2-utils pax-utils systemd

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="http://dropbox.com/"
SRC_URI="
	x86? ( http://dl-web.dropbox.com/u/17/${PN}-lnx.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/${PN}-lnx.x86_64-${PV}.tar.gz )"

LICENSE="CC-BY-ND-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="system-librsync X systemd cli"
RESTRICT="mirror strip"

QA_PREBUILT="opt/.*"
QA_EXECSTACK="opt/dropbox/dropbox"

DEPEND="!system-librsync? ( dev-util/patchelf )"

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
	sys-apps/coreutils
	app-arch/bzip2
	dev-libs/popt
	net-misc/wget
	>=sys-devel/gcc-4.2.0
	sys-libs/zlib
	systemd? ( >=sys-apps/systemd-219 )
	cli? ( >=net-misc/dropbox-cli-1.6.2 )
	system-librsync? ( net-libs/librsync )"

DOCS=(README,ACKNOWLEDGEMENTS)

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
	pushd "${PN}-lnx.x86_64-${PV}"

#	rm libpopt.so.0 || die
	if use X ; then
		mv images/hicolor/16x16/status "${T}" || die
	fi
#	else
#		rm -r *wx* images || die
#	fi
	if ! use system-librsync ; then
		patchelf --set-rpath '$ORIGIN' _librsync.so || die
	fi
#	else
#		rm librsync.so.1 || die
#	fi

	#mv cffi-0.7.2-py2.7-*.egg dropbox_sqlite_ext-0.0-py2.7.egg distribute-0.6.26-py2.7.egg "${T}" || die
	#rm -rf *.egg library.zip || die
	#mv "${T}"/cffi-0.7.2-py2.7-*.egg "${T}"/dropbox_sqlite_ext-0.0-py2.7.egg "${T}"/distribute-0.6.26-py2.7.egg "${S}" || die
	#ln -s dropbox library.zip || die
	pax-mark cm dropbox
	mv README ACKNOWLEDGEMENTS "${T}" || die
}

src_install() {
	local targetdir="/opt/${PN}"

	rm "${PN}-lnx.x86_64-${PV}/${PN}d" || die

	# installing dropbox
	insinto "${targetdir}"
	doins -r "${PN}-lnx.x86_64-${PV}"/*

	# fixing perms
	fperms 755 "${targetdir}/${PN}"
	fowners -R root:dropbox "${targetdir}"

	# installing init scripts
	newinitd "${FILESDIR}"/${PN}.initd dropbox
	newconfd "${FILESDIR}"/${PN}.confd dropbox
	if use systemd; then

#		if use X; then
#cat <<EOF >> "${T}"/${PN}.service
#
#[Install]
#WantedBy=graphical.target
#
#[Unit]
#After=graphical.target
#EOF
#		fi

		systemd_newunit "${FILESDIR}"/${PN}.system.service "${PN}.service"
		systemd_newunit "${FILESDIR}"/${PN}.system.service "${PN}@.service"
		systemd_newuserunit "${FILESDIR}"/${PN}.user.service "${PN}.service"
		#systemd_newuserunit "${FILESDIR}"/${PN}.user.service "${PN}@.service"
	fi

	dodoc "${T}"/{README,ACKNOWLEDGEMENTS}

	# installing sysctl files
	dodir /etc/sysctl.d
	cp "${FILESDIR}"/${PN}.sysctl "${D}"/etc/sysctl.d/100-${PN}.conf
}

pkg_preinst() {
	use X && gnome2_icon_savelist
}

pkg_postinst() {
	use X && gnome2_icon_cache_update

	elog
	elog "You must be in the 'dropbox' group to use DropBox."
	elog "Just run (replace <USER> with the desired username):"
	elog "    gpasswd -a <USER> dropbox"
	elog
	elog "then have <USER> re-login."

	if use systemd; then
		elog
		elog "If you want to enable the service for a specific user when your system boots"
		elog "then execute the following commands (replace <USER> with the desired username):"
		elog "   systemctl enable dropbox@<USER>"
		elog "   systemctl start dropbox@<USER>"
		elog
		elog "If you want to enable the service when a specific user log in"
		elog "then execute the following commands as a logged user (non root):"
		elog "   systemctl --user enable dropbox"
		elog "   systemctl --user start dropbox"

		if use X; then
		elog
		elog "By default, running the service doesn't give you an icon in the system tray"
		elog "because it doesn't know which X display to use. If you want Dropbox to appear"
		elog "into your system tray, you must edit the provided service:"
		elog "   systemctl --user edit dropbox"
		elog
		elog "and add the following snippet:"
		elog "[Service]"
		elog "Environment=DISPLAY=${DISPLAY}"
		fi

		elog
		elog "If you have a lot of files in your Dropbox folder, Dropbox's speed may decrease."
		elog "This can be fixed easily by tweaking the value of fs.inotify.max_user_watches of"
		elog "the sysctl configuration file /etc/sysctl.d/100-${PN}.conf and then reload"
		elog "the kernel parameters:"
		elog "    sysctl --system"

		if ! use X; then
			echo
			elog "You installed dropbox without the USE flag 'X', which means"
			elog "the service will run Dropbox as a daemon that syncs your data"
			elog "in the background. No icon will be available in the system tray."
			elog "Enable the USE flag 'X' if you want to have tray support."
		fi
	fi
}

pkg_postrm() {
	use X && gnome2_icon_cache_update
}