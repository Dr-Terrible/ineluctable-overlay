# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTES:
# 1- use flag 'pgm' (OpenPGM support) must be masked by profiles for ARM archs;
# 2- $(use_with pgm) doesn't work due to a broken configure.in (I'm fixing it
#    with upstream);
# 3- libpgm is bundled inside 0MQ's source because the library isn't complete
#    and fully installable alone, so for now upstream has decided to bundle
#    it until libpgm can be packaged as a separate component;
# 4- pkgconfig is an automagic dep (I'm fixing it with upstream);

EAPI=5
inherit git-2 autotools

EGIT_REPO_URI="http://github.com/zeromq/zeromq2.git"

DESCRIPTION="ZeroMQ is a brokerless messaging kernel with extremely high performance."
HOMEPAGE="http://www.zeromq.org/"
SRC_URI=""

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="pgm static-libs"

RDEPEND="sys-apps/util-linux"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
	pgm? (
		virtual/pkgconfig
		app-arch/gzip
		dev-lang/perl
		dev-lang/python:2.6
	)"

src_prepare() {
	eautoreconf
}

src_configure() {
	local myconf
	use pgm && myconf="--with-pgm"
	econf \
		$(use_enable static-libs static) \
		${myconf} \
		--disable-dependency-tracking \
		--enable-fast-install
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc NEWS README AUTHORS || die "dodoc failed."

	# remove useless .la files (only for non static compilation)
	find "${D}" -name '*.la' -delete
}
