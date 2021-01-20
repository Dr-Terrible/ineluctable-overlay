# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="A lightweight implementation of Ruby complying to part of the ISO standard"
HOMEPAGE="http://www.mruby.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test static-libs"

CDEPEND="sys-libs/readline:0"
DEPEND="${CDEPEND}
	sys-devel/bison
	dev-lang/ruby"
RDEPEND="${CDEPEND}"

RESTRICT="mirror"

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
