# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit user autotools-utils

DESCRIPTION="A purely functional package manager"
HOMEPAGE="http://nixos.org/nix"
SRC_URI="http://nixos.org/releases/${PN}/${P}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+boehm-gc doc perl test"

DEPEND=">=sys-devel/bison-2.6
	sys-devel/flex
	virtual/perl-ExtUtils-ParseXS
	doc? (
		dev-libs/libxml2
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
	)	"

RDEPEND="dev-lang/perl
	app-arch/bzip2
	dev-db/sqlite
	boehm-gc? ( dev-libs/boehm-gc[cxx] )
	dev-libs/openssl
	dev-perl/DBD-SQLite
	dev-perl/DBI
	dev-perl/WWW-Curl
	net-misc/curl[ssl]"

pkg_setup() {
	enewgroup nix
}

src_configure() {
	local myeconfargs=(
		$(use_enable boehm-gc gc)
		$(use_enable perl perl-bindings)
	)
	autotools-utils_src_configure
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	emake installcheck || die 'emake check failed.'
	popd > /dev/null || die
}