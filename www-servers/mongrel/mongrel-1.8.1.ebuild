# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils multilib

DESCRIPTION="Mongrel is an agnostic web server that focuses on web applications using modern browser technologies"
HOMEPAGE="http://mongrel2.org"
SRC_URI="https://github.com/zedshaw/${PN}2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples doc test"

DEPEND="dev-util/ragel
	doc? (
	<=app-doc/dexy-0.6.0
	!>=app-doc/dexy-1.0.0
	virtual/latex-base
	dev-texlive/texlive-fontsrecommended
	dev-tex/tex4ht
	dev-texlive/texlive-fontsextra
)"
RDEPEND="!www-servers/mongrel:0
	dev-db/sqlite:3
	>=net-libs/zeromq-2.1.4"

S="${WORKDIR}/${PN}2-${PV}"

RESTRICT="mirror"

src_prepare() {
	epatch "${FILESDIR}"/mongrel-makefile.patch
	epatch "${FILESDIR}"/mongrel-makefile2a.patch
	epatch "${FILESDIR}"/mongrel-makefile3.patch
	epatch "${FILESDIR}"/mongrel-makefile4.patch
	epatch "${FILESDIR}"/mongrel-makefile5.patch
	epatch "${FILESDIR}"/mongrel-makefile6.patch
	#epatch "${FILESDIR}"/mongrel-makefile7.patch
	epatch "${FILESDIR}"/mongrel-latex.patch
}
src_install(){
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="/$(get_libdir)" \
		install || die
	newconfd "${FILESDIR}"/mongrel2.confd mongrel2 || die
	newinitd "${FILESDIR}"/mongrel2.initd mongrel2 || die

	if use doc; then
		${PYTHON} dexy setup || die
		make -j1 -s manual || die
		dodoc output/docs/manual/book-final.pdf
	fi
}

src_test(){
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		tests || die
}
