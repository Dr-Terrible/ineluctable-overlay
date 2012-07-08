# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils git-2

DESCRIPTION="VertexDB is a high performance graph database server"
HOMEPAGE="http://www.dekorte.com/projects/opensource/vertexdb/"
EGIT_REPO_URI="git://github.com/stevedekorte/${PN}.git"

LICENSE="BSD"
SLOT="live"
KEYWORDS=""
IUSE="utils server test"

DEPEND="=dev-libs/yajl-1.0.12
	!>=dev-libs/yajl-2.0.0
	dev-db/tokyocabinet
	dev-libs/libevent"
RDEPEND="${DEPEND}"

#src_prepare() {
#	# filtering hard coded cflags
#	epatch "${FILESDIR}/${PN}-cflags.patch"
#	epatch "${FILESDIR}/${PN}-gcc46.patch"
#}

src_install() {
	cmake-utils_src_install

	# installing initd
	if use server; then
		:;
	fi

	# installing ruby utilities
	if use utils; then
		insinto /usr/share/${PN}
		doins "${S}"/vertexdb_admin
	fi

	dohtml -r docs/*
}
