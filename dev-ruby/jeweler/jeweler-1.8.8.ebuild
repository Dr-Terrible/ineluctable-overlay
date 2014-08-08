# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"
RUBY_FAKEGEM_TASK_DOC="-Ilib yard"
RUBY_FAKEGEM_DOCDIR="doc"

# Tests and features also need the same set of dependencies present.
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="ChangeLog.markdown README.markdown"
RUBY_FAKEGEM_GEMSPEC="jeweler.gemspec"

inherit ruby-fakegem

DESCRIPTION="Rake tasks for managing gems and versioning and a generator for creating a new project"
HOMEPAGE="http://wiki.github.com/technicalpickles/jeweler"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/yard )"

ruby_add_rdepend "dev-ruby/bundler dev-ruby/nokogiri >=dev-ruby/highline-1.6.20 dev-ruby/rdoc dev-ruby/builder dev-ruby/rake"

# We do not depend on all runtime dependencies since the usage of jeweler in
# Rakefile's does not require this. However, the generator does, but it
# depends on gems that are obsolete and not supported in Gentoo.

all_ruby_prepare() {
	# Remove bundler support.
	rm Gemfile || die
	sed -i -e '/bundler/d' -e '/Bundler.setup/d' Rakefile test/test_helper.rb features/support/env.rb || die

	# Remove (currently) unused targets from the Rakefile that require
	# additional dependencies.
	sed -i -e '/rcov/,$d' Rakefile || die

	# Remove a runtime dependency that we can't satisfy.
	sed -i -e '/github_api/d' jeweler.gemspec || die
}
