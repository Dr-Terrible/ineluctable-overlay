# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20"

RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem

DESCRIPTION="Gorillib is a lightweight subset of ruby convenience methods."
HOMEPAGE="https://github.com/infochimps-labs/gorillib"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/multi_json
	dev-ruby/json
	>=dev-ruby/configliere-0.4.18-r1"
