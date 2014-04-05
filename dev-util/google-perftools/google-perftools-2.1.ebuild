# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="https://code.google.com/p/gperftools/"
SRC_URI="http://gperftools.googlecode.com/files/${P//oogle-}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cpu-profiler -debug heap-profiler heap-checker static-libs test minimal"

RDEPEND="sys-libs/libunwind"

S="${WORKDIR}/${PN//oogle-}-${PV}"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	local myeconfargs=(
		$(use_enable cpu-profiler)
		$(use_enable heap-profiler)
		$(use_enable heap-checker)
		$(use_enable debug debugalloc)
		$(use_enable static-libs static)
		$(use_enable minimal)
	)
	autotools-utils_src_configure
}