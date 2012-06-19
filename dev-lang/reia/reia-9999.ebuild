# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18"
inherit git-2 ruby-ng

DESCRIPTION="Reia is a Ruby-like scripting language for the Erlang virtual machine."
HOMEPAGE="http://www.reia-lang.org"
EGIT_REPO_URI="git://github.com/tarcieri/reia.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-lang/erlang-13.2.4
	dev-ruby/rails"
RDEPEND="${DEPEND}"
