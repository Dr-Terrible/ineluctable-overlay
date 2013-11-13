# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20"
inherit git-2 ruby-ng

DESCRIPTION="Reia is a Ruby-like scripting language for the Erlang virtual machine."
HOMEPAGE="http://www.reia-lang.org"
EGIT_REPO_URI="git://github.com/tarcieri/reia.git"

LICENSE="HPND"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-lang/erlang-13.2.4
	dev-ruby/rails"
RDEPEND="${DEPEND}"
