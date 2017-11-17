# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-multilib

MY_PN="${PN//oogle-}"

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="https://github.com/gperftools/gperftools"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"
#SRC_URI="https://googledrive.com/host/0B6NtGsLhIcf7MWxMMF9JdTN3UVk/${P//oogle-}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+cpu-profiler -debug heap-profiler heap-checker static-libs test minimal doc"

RDEPEND="sys-libs/libunwind"

S="${WORKDIR}/${MY_PN}-${MY_PN}-${PV}"

RESTRICT+=" mirror"

DOCS=( AUTHORS ChangeLog NEWS README TODO)
PATCHES=(
	"${FILESDIR}/"google-perftools-makefile.patch
)

src_prepare() {
	# Fix docdir path
	sed -i "s:^docdir =.*:docdir = \$(prefix)/share/doc/${PF}/html:" \
		Makefile.am || die "docdir substitution failed"

	autotools-multilib_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable cpu-profiler)
		$(use_enable heap-profiler)
		$(use_enable heap-checker)
		$(use_enable debug debugalloc)
		$(use_enable static-libs static)
		$(use_enable minimal)
	)
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install

	if ! use doc; then
		rm -r "${ED}/usr/share/doc/${PF}/html" || die
	fi
}
