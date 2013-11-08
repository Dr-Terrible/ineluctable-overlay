# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils libtool

MY_P="${P//-fb/}-stable"
MY_PN="${PN//-fb/}"

DESCRIPTION="A library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="http://libevent.org/"
SRC_URI="mirror://github/${MY_PN}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+ssl static-libs test"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="
	${DEPEND}
	!<=dev-libs/9libs-1.0
"

S=${WORKDIR}/${MY_P}

DOCS=( README ChangeLog )

src_prepare() {
	epatch "${FILESDIR}/facebook-hhvm.patch" || die
	elibtoolize

	# don't waste time building tests/samples
	sed -i \
		-e 's|^\(SUBDIRS =.*\)sample test\(.*\)$|\1\2|' \
		Makefile.in || die "sed Makefile.in failed"
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable ssl openssl)
}

src_test() {
	# The test suite doesn't quite work (see bug #406801 for the latest
	# installment in a riveting series of reports).
	:
	# emake -C test check | tee "${T}"/tests
}

src_install() {
	default
	prune_libtool_files
}
