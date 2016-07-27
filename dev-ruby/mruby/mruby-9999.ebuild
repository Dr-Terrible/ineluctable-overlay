# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

EGIT_REPO_URI="git://github.com/mruby/mruby.git"

DESCRIPTION="A lightweight implementation of Ruby complying to part of the ISO standard"
HOMEPAGE="http://www.mruby.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test static-libs"

CDEPEND="sys-libs/readline:0"
DEPEND="${CDEPEND}
	sys-devel/bison
	dev-lang/ruby[ncurses]"
RDEPEND="${CDEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README.md TODO CONTRIBUTING.md)

src_install() {
	# installing binaries and libraries
	dobin bin/{mirb,mrbc,mruby}
	use static-libs && dolib.a build/host/lib/libmruby.a build/host/lib/libmruby_core.a

	# installing headers
	doheader -r include/mrbconf.h include/mruby include/mruby.h

	# installing docs
	einstalldocs
}
