# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils ltprune multilib-minimal

DESCRIPTION="A C/C++ implementation of a Sass CSS compiler"
HOMEPAGE="https://github.com/sass/libsass"
SRC_URI="https://github.com/sass/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 arm x86 amd64-linux"
LICENSE="MIT"
SLOT="0/0.0.9" # libsass soname
IUSE="static-libs"

DOCS=( Readme.md SECURITY.md )

src_prepare() {
	default
	eautoreconf

	# only sane way to deal with various version-related scripts, env variables etc.
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-shared
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
}

multilib_src_install_all() {
	einstalldocs
	dodoc -r "${S}/docs"
}
