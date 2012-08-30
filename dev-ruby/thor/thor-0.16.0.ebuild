# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ree18 ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.md"
RUBY_FAKEGEM_BINWRAP="thor"

RUBY_S="wycats-${PN}-*"

inherit ruby-fakegem

DESCRIPTION="A scripting framework that replaces rake and sake"
HOMEPAGE="http://github.com/wycats/thor"
SRC_URI="http://github.com/wycats/${PN}/tarball/v${PV} -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

ruby_add_bdepend "
	test? (
		dev-ruby/fakeweb
		dev-ruby/rspec:2
		dev-ruby/childlabor
	)
	doc? (
		dev-ruby/rdoc
	)"

all_ruby_prepare() {
	# Remove rspec default options (as we might not have the last
	# rspec).
	rm .rspec || die

	# Remove Bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Thorfile || die

	# Remove mandatory coverage collection using simplecov which is not
	# packaged.
	sed -i -e '/require .simplecov/, /^end/ d' spec/spec_helper.rb || die
}

all_ruby_compile() {
	if use doc; then
		ruby -Ilib bin/thor rdoc || die "RDoc generation failed"
	fi
}

each_ruby_test() {
	${RUBY} -S rspec spec || die "Tests for ${RUBY} failed"
}
