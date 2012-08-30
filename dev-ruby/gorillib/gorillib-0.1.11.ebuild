# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem

DESCRIPTION="Gorillib is a lightweight subset of ruby convenience methods."
HOMEPAGE="https://github.com/infochimps-labs/gorillib"
#SRC_URI="https://github.com/infochimps-labs/${PN}/tarball/v${PV} -> ${P}.tgz"
#RUBY_S="infochimps-labs-${PN}-*"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}
	dev-ruby/json"
