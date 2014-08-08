# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"
inherit ruby-fakegem

DESCRIPTION="Loofah is a general library for manipulating and transforming
HTML/XML documents and fragments"
HOMEPAGE="https://github.com/flavorjones/loofah"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/nokogiri"
