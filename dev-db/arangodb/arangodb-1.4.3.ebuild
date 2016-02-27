# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib systemd autotools

DESCRIPTION="The universal nosql database"
HOMEPAGE="http://www.arangodb.org/"
SRC_URI="http://www.arangodb.org/repositories/Source/ArangoDB-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="ruby debug"

DEPEND=">=sys-libs/readline-6.2_p1:0
	>=dev-libs/openssl-1.0.0j
	media-gfx/graphviz
	dev-libs/libev
	dev-libs/icu
	dev-util/valgrind
	ruby? ( dev-ruby/mruby )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/ArangoDB-${PV}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	einfo "Removing bundled libraries"
	rm -r "${S}"/3rdParty/icu || die
	rm -r "${S}"/3rdParty/libev || die
	rm -r "${S}"/3rdParty/valgrind || die
	rm -r "${S}"/3rdParty/zlib* || die
	rm -r "${S}"/3rdParty/mruby || die

	# FIX: make optional the bundled zlib
	epatch "${FILESDIR}"/${P}.zlib.patch
	epatch "${FILESDIR}"/${P}.valgrind.patch
	eautoreconf
}

src_configure() {
	econf --localstatedir="${EPREFIX}"/var \
		$(use_enable ruby mruby) \
		$(use_enable debug gcov) \
		$(use_enable debug eff-cpp) \
		$(use_enable debug silent-rules) \
		--disable-all-in-one-zlib \
		--enable-all-in-one-v8 \
		--enable-readline \
		--with-readline="/usr/includes" \
		--with-readline-lib="/usr/$(get_libdir)" \
		--disable-all-in-one-libev \
		--with-libev="/usr/includes" \
		--with-libev-lib="/usr/$(get_libdir)" \
		--disable-all-in-one-icu \
		--with-icu-config=/usr/bin/icu-config \
		|| die "configure failed"
}

src_install() {
	default

	# install init scripts
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	# fix permissions
	keepdir /var/log/${PN}
	fperms 0740 /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	fperms 0700 /var/lib/${PN}
	fowners ${PN}:root /var/lib/${PN}

	fperms 0700 /var/lib/${PN}-apps/
	fowners ${PN}:root /var/lib/${PN}-apps/
}
