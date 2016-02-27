# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby21 ruby20"

RUBY_FAKEGEM_VERSION="${PV//_/.}"
RUBY_FAKEGEM_VERSION="${RUBY_FAKEGEM_VERSION//rc/rc.}"
RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem

DESCRIPTION="Declarative SAX Parsing with Nokogiri"
HOMEPAGE="https://github.com/pauldix/sax-machine"
SRC_URI="https://github.com/pauldix/${PN}/tarball/v${PV//_/.} -> ${P}.tgz"
RUBY_S="pauldix-${PN}-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/nokogiri"
