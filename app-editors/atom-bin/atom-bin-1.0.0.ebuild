# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit rpm

MY_PN="${PN//-bin}"

DESCRIPTION="A hackable text editor for the 21st Century"
HOMEPAGE="https://atom.io"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/releases/download/v${PV}/${MY_PN}.x86_64.rpm
	doc? (
		http://orm-atlas2-prod.s3.amazonaws.com/html/b521a5963a9d32543e07dd7cbaab4c09.zip -> ${MY_PN}-flight-manual-v${PV}.zip
	)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="!app-editors/atom
	|| ( >=net-libs/nodejs-0.10.30[npm] net-libs/iojs[npm] )
	dev-libs/atk:0
	dev-libs/expat:0
	dev-libs/glib:2
	dev-libs/libgpg-error:0
	dev-libs/nspr:0
	dev-libs/nss:0
	gnome-base/gconf:2
	gnome-base/libgnome-keyring:0
	media-libs/alsa-lib:0
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	net-print/cups:0
	sys-apps/dbus:0
	sys-libs/libcap:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libnotify:0
	x11-libs/libX11:0
	x11-libs/libXcomposite:0
	x11-libs/libXcursor:0
	x11-libs/libXdamage:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXi:0
	x11-libs/libXrandr:0
	x11-libs/libXrender:0
	x11-libs/libXtst:0
	x11-libs/pango:0"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

QA_PRESTRIPPED="usr/share/${MY_PN}/.*"
QA_PREBUILT="usr/share/${MY_PN}/resources/app/apm/bin/node"
QA_FLAGS_IGNORED="usr/share/${MY_PN}/resources/app/apm/bin/node"

src_unpack() {
	# FIX: source directory
	srcrpm_unpack ${MY_PN}.x86_64.rpm
	mkdir -p "${S}" || die
	mv "${WORKDIR}"/usr "${S}"/ || die

	if use doc; then
		unzip -q -d "${WORKDIR}"/docs "${DISTDIR}"/${MY_PN}-flight-manual-v${PV}.zip
	fi
}

src_install() {
	# Install package
	insinto /usr
	doins -r "${S}"/usr/*

	# Install documentation
	use doc && dohtml -r "${WORKDIR}"/docs/*

	# Fix permissions
	fperms +x "${EPREFIX}"/usr/bin/${MY_PN}
	fperms +x "${EPREFIX}"/usr/share/${MY_PN}/${MY_PN}
	fperms +x "${EPREFIX}"/usr/share/${MY_PN}/resources/app/${MY_PN}.sh
	fperms +x "${EPREFIX}"/usr/share/${MY_PN}/resources/app/apm/bin/*
	fperms +x "${EPREFIX}"/usr/share/${MY_PN}/resources/app/apm/node_modules/npm/bin/node-gyp-bin/node-gyp
}