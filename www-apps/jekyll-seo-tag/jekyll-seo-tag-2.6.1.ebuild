# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A Jekyll plugin to add metadata tags for search engines"
HOMEPAGE="https://github.com/jekyll/${PN}"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_bdepend "test? ( >=www-apps/jekyll-3 )"
