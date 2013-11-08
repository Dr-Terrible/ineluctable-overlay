# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
DESCRIPTION="mount an archive as filesystem using fuse and libarchive"
HOMEPAGE="http://www.cybernoia.de/software/archivemount/"
SRC_URI="http://www.cybernoia.de/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="sys-fs/fuse
	app-arch/libarchive"
DEPEND="${RDEPEND}"

src_compile() {
	# respect user specified CFLAGS.
	# remove automatically appended -O2 flag by blanking am__append_2.
	emake CFLAGS="${CFLAGS}" am__append_2="" || die "emake failed"
}

src_install() {
	emake DESTDIR="${ED}" install || die "emake install failed"
	dodoc CHANGELOG README
}
