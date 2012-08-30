# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_VERSION="${PV//_/.}"
RUBY_FAKEGEM_VERSION="${RUBY_FAKEGEM_VERSION//rc/rc.}"
RUBY_FAKEGEM_GEMSPEC="feedzirra.gemspec"
RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="A feed fetching and parsing library for Ruby."
HOMEPAGE="https://github.com/pauldix/feedzirra"
SRC_URI="https://github.com/pauldix/${PN}/tarball/v${PV//_/.} -> ${P}.tgz"
RUBY_S="pauldix-${PN}-*"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}
	dev-ruby/rspec"
RDEPEND="${RDEPEND}
	>=dev-ruby/activesupport-3.1.1
	dev-ruby/builder
	dev-ruby/curb
	>=dev-ruby/i18n-0.5.0
	>=dev-ruby/loofah-1.2.1
	>=dev-ruby/nokogiri-1.5.5
	dev-ruby/rake
	>=dev-ruby/gorillib-0.1.9
	>=dev-ruby/sax-machine-0.2.0_rc1"

all_ruby_prepare() {
	# FIX: gemspec is missing a require
	epatch "${FILESDIR}/${PN}.gemspec.patch" || die
}
