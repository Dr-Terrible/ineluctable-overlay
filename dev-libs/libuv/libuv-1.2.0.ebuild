# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils autotools multilib-minimal

DESCRIPTION="A new platform layer for Node"
HOMEPAGE="https://github.com/joyent/libuv"
SRC_URI="https://github.com/libuv/libuv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD BSD-2 ISC MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs doc test"

DEPEND="virtual/pkgconfig
	doc? ( dev-python/sphinx )"

src_prepare() {
	echo "m4_define([UV_EXTRA_AUTOMAKE_FLAGS], [serial-tests])" \
		> m4/libuv-extra-automake-flags.m4 || die

	sed -i \
		-e '/libuv_la_CFLAGS/s#-g##' \
		Makefile.am || die "fixing CFLAGS failed!"

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static)
}

multilib_src_test() {
	mkdir "${BUILD_DIR}"/test || die
	cp -pPR "${S}"/test/fixtures "${BUILD_DIR}"/test/fixtures || die
	default
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files

	if use doc; then
		cd "${S}"/docs || die
		emake singlehtml || die
		local HTML_DOCS=( "${S}"/docs/build/singlehtml/. )
		einstalldocs
	fi
}