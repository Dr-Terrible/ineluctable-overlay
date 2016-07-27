# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A web server that focuses on web applications using modern browser technologies"
HOMEPAGE="http://mongrel2.org"
SRC_URI="https://github.com/${PN}2/${PN}2/archive/v${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples doc test"

DEPEND="net-libs/polarssl:1.3[threads,havege]
	dev-util/ragel
	doc? (
		<=app-doc/dexy-0.6.0
		!>=app-doc/dexy-1.0.0
		virtual/latex-base
		dev-texlive/texlive-fontsrecommended
		dev-tex/tex4ht
		dev-texlive/texlive-fontsextra
	)"
RDEPEND="!www-servers/${PN}:0
	dev-db/sqlite:3
	>=net-libs/zeromq-2.1.4"

S="${WORKDIR}/${PN}2-${PV}"

RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.2-makefile.patch
	"${FILESDIR}"/${PN}-1.9.2-makefile2.patch
	"${FILESDIR}"/${PN}-1.9.2-makefile2a.patch
	"${FILESDIR}"/${PN}-1.9.2-makefile3.patch
	"${FILESDIR}"/${PN}-1.9.2-makefile4.patch
	"${FILESDIR}"/${PN}-1.9.2-makefile5.patch
	"${FILESDIR}"/${PN}-1.9.2-system-polarssl.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
	epatch_user
}
src_configure() { :; }

src_compile() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="/$(get_libdir)" \
		OPTLIBS="-lmbedtls" \
		|| die
}

src_install(){
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="/$(get_libdir)" \
		install \
		|| die

	newconfd "${FILESDIR}"/${PN}2.confd ${PN}2 || die
	newinitd "${FILESDIR}"/${PN}2.initd ${PN}2 || die

	if use doc; then
		${PYTHON} dexy setup || die
		emake -j1 -s manual || die
		dodoc docs/manual/book-final.pdf
	fi
}

src_test(){
	sh ./tests/runtests.sh || die
}
