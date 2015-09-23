# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit flag-o-matic autotools-utils

ECOMMIT="6b6a47393127efedca5a75d2adbc70947d37dfa1"

DESCRIPTION="Abook is a text-based addressbook program designed to use with mutt mail client"
HOMEPAGE="http://abook.sourceforge.net"
SRC_URI="http://sourceforge.net/code-snapshots/git/a/ab/${PN}/git.git/${PN}-git-${ECOMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls debug"

RDEPEND="sys-libs/ncurses
	sys-libs/readline
	dev-libs/libvformat
	nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

S="${WORKDIR}/${PN}-git-${ECOMMIT}"

RESTRICT+=" mirror"

DOCS=(BUGS ChangeLog FAQ README TODO sample.abookrc)

src_configure() {
	append-cflags -std=gnu89
	local myeconfargs=(
		--enable-vformat
		$(use_enable nls)
		$(use_enable debug)
	)
	autotools-utils_src_configure
}