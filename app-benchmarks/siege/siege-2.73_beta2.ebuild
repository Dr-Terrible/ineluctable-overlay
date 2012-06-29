# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

WANT_AUTOMAKE=1.9
WANT_AUTOCONF=2.5
inherit eutils bash-completion-r1 autotools

DESCRIPTION="A HTTP regression testing and benchmarking utility"
HOMEPAGE="http://www.joedog.org/JoeDog/Siege"
SRC_URI="http://www.joedog.org/pub/siege/beta/${PN}-${PV//_b*/}b2.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~x86"
SLOT="0"
IUSE="ssl static-libs"

RDEPEND="ssl? ( >=dev-libs/openssl-0.9.6d )"
DEPEND="${RDEPEND}
	sys-devel/libtool"

S="${WORKDIR}/${PN}-${PV//_b*/}b2"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PV//_b*/}-makefile.patch

	# bundled macros break recent libtool
	rm *.m4 || die "failed to remove bundled macros"

	eautoreconf
}

src_configure() {
	econf \
		$(use_with ssl) \
		$(use enable static-libs static) \
		--disable-dependency-tracking
}

src_install() {
	make DESTDIR="${D}" install

	# remove useless .la files
	find "${D}" -name '*.la' -delete

	# remove useless .a (only for non static compilation)
	use static-libs || find "${D}" -name '*.a' -delete

	# install doc
	dodoc AUTHORS ChangeLog INSTALL MACHINES README* KNOWNBUGS \
		doc/siegerc doc/urls.txt

	# install bashcomp
	newbashcomp "${FILESDIR}"/${PN}.bash-completion ${PN}
}

pkg_postinst() {
	echo
	elog "An example ~/.siegerc file has been installed in"
	elog "/usr/share/doc/${PF}/"
}
