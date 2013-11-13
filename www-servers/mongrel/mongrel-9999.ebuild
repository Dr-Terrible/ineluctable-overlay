# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils multilib git-2

EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/zedshaw/mongrel2.git"

DESCRIPTION="Mongrel is an agnostic web server that focuses on web applications using modern browser technologies"
HOMEPAGE="https://mongrel2.org"

LICENSE="BSD"
SLOT="2"
KEYWORDS=""
IUSE="examples doc"

DEPEND="doc? (
	app-doc/dexy
	virtual/latex-base
	dev-texlive/texlive-fontsextra
	dev-texlive/texlive-fontsrecommended
	dev-tex/tex4ht
	)"
RDEPEND="!www-servers/mongrel:0
	dev-db/sqlite:3
	>=net-libs/zeromq-2.1.4"

S="${WORKDIR}/${PN}2-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/mongrel-makefile.patch
	#epatch "${FILESDIR}"/mongrel-makefile2.patch
	epatch "${FILESDIR}"/mongrel-makefile3.patch
	epatch "${FILESDIR}"/mongrel-makefile4.patch
	epatch "${FILESDIR}"/mongrel-makefile5.patch
	epatch "${FILESDIR}"/mongrel-latex.patch
}
src_install(){
	if use doc; then
		${PYTHON} dexy setup || die
		emake manual || die
		dodoc "${S}"/output/docs/manual/book-final.pdf || die
	fi

	emake \
		DESTDIR="${ED}" \
		PREFIX="${EPREFIX}"/usr/$(get_libdir) \
		install || die
	newconfd "${FILESDIR}"/mongrel2.confd mongrel2 || die
	newinitd "${FILESDIR}"/mongrel2.initd mongrel2 || die
}

#pkg_postinst(){
#	echo
#	einfo "If you are upgrading mongrel:2, remember to update your database config:"
#	einfo "Schema modifications for 1.7.x"
#	einfo "alter table server add column use_ssl INTEGER default 0;"
#	einfo
#	einfo "Since column default_host changed from INTEGER to TEXT and"
#	einfo "sqlite does not support column dropping we must re-create the"
#	einfo "server table, changing the type of default_host column:"
#	einfo
#	einfo "  create table s2 as select id, uuid, access_log, error_log, chroot, pid_file, name, bind_addr, port, use_ssl from server;"
#	einfo "  alter table s2 add column default_host TEXT default '';"
#	einfo "  update s2 set default_host = (select default_host from server s1 where s1.id = s2.id);"
#	einfo "  drop table server;"
#	einfo "  create table server as select * from s2;"
#	echo
#}
