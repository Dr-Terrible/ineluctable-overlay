# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils autotools multilib

MY_P="${P//hhvm-/}-stable"
MY_PN="${PN//hhvm-/}"

DESCRIPTION="A customized dev-libs/libevent used by HipHop Virtual Manager"
HOMEPAGE="http://libevent.org"
SRC_URI="mirror://github/${MY_PN}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

RDEPEND="!<=dev-libs/9libs-1.0"

S=${WORKDIR}/${MY_P}
PREFIX="/opt/hhvm"

src_prepare() {
	# apply Facebook patchset
	epatch "${FILESDIR}/facebook-hhvm.patch" || die
	eautoreconf

	# don't waste time building tests/samples
	sed -i \
		-e 's|^\(SUBDIRS =.*\)sample test\(.*\)$|\1\2|' \
		Makefile.in || die "sed Makefile.in failed"
}

src_configure() {
	# thi package is prefixed with a namespace to avoid
	# file collision and cluttering of the LIBDIR
	#econf \
	#	--libdir="${PREFIX}/$(get_libdir)/hhvm" \
	#	--includedir="${PREFIX}/include/hhvm" \
	econf $(use_enable static-libs static) \
		--prefix="${PREFIX}" || die
}

src_test() {
	# The test suite doesn't quite work (see bug #406801 for the latest
	# installment in a riveting series of reports).
	:
}

src_install() {

	default
	use static-libs || prune_libtool_files

	# these files aren't used by HHVM, so there isn't
	# the need to install them
	#rm "${D}/${PREFIX}/bin/event_rpcgen.py" || die
	rm -r "${D}"/usr/share/man || die
	rm -r "${D}"/usr/share/doc || die
}
