# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils

DESCRIPTION="jsoncpp is an implementation of a JSON (http://json.org) reader and writer in C++"
HOMEPAGE="http://jsoncpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

DEPEND="dev-util/scons
	doc? ( app-doc/doxygen[-nodot] )"
RDEPEND="!dev-libs/json-c"

S="${WORKDIR}/${PN}-src-${PV}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-paths.patch" || die
	epatch "${FILESDIR}/${PN}-doxygen.patch" || die
}
src_compile() {
	scons platform=linux-gcc || die
}
src_install() {
	insinto /usr/lib
	doins "${S}"/libs/libjson.so

	insinto /usr/include
	doins -r "${S}"/include/*

	# installing API(s) docs
	if use doc; then
		einfo "Generating API(S) documentation…"
		pushd "${S}"/doc > /dev/null
			doxygen -s doxyfile.in || die
			dohtml -r html/* || die
		popd > /dev/null
	fi
}
src_test() {
	pushd "${S}"/test > /dev/null
		einfo "Running Reader/Writer tests"
		python runjsontests.py "${S}"/bin/jsontestrunner || die

		einfo "Running Unit Tests (mostly Value)"
		python rununittests.py "${S}"/bin/test_lib_json || die
	popd > /dev/null
}
