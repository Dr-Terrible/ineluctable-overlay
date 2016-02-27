# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"
RUBY_FAKEGEM_VERSION="${PV//_/.}"
RUBY_FAKEGEM_VERSION="${RUBY_FAKEGEM_VERSION//rc/rc.}"
RUBY_FAKEGEM_GEMSPEC="feedzirra.gemspec"
RUBY_FAKEGEM_DOCDIR="rdoc"
inherit ruby-fakegem eutils

DESCRIPTION="A feed fetching and parsing library for Ruby"
HOMEPAGE="https://github.com/pauldix/feedzirra"
SRC_URI="https://github.com/pauldix/${PN}/tarball/v${PV//_/.} -> ${P}.tgz"
RUBY_S="pauldix-${PN}-*"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/loofah-1.2.1
	>=dev-ruby/sax-machine-0.2.0_rc1
	>=dev-ruby/curb-0.8.5
	dev-ruby/nokogiri"

all_ruby_prepare() {
	# FIX: gemspec is missing a require
	epatch "${FILESDIR}/${PN}.gemspec.patch" || die
}
