# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils git-2

EGIT_REPO_URI="git://github.com/mruby/mruby.git"

DESCRIPTION="mruby is the lightweight implementation of the Ruby language complying to part of the ISO standard"
HOMEPAGE="http://www.mruby.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test static-libs"

DEPEND="sys-devel/bison"
RDEPEND="dev-lang/ruby"

DOCS=(AUTHORS ChangeLog NEWS README.md TODO CONTRIBUTING.md)

src_install() {
	# installing binaries and libraries
	dobin bin/{mirb,mrbc,mruby}
	use static-libs && dolib.a build/host/lib/libmruby.a build/host/lib/libmruby_core.a

	# installing headers
	insinto /usr/include/
	doins -r include/mrbconf.h include/mruby include/mruby.h

	# installing docs
	einstalldocs
}