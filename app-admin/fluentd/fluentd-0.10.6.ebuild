# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_EXTRADOC="AUTHORS ChangeLog NEWS README*"
RUBY_FAKEGEM_EXTRAINSTALL="fluent.conf"
inherit ruby-fakegem

DESCRIPTION="Fluentd is a log collector daemon written in Ruby"
HOMEPAGE="http://fluentd.org"
SRC_URI="https://github.com/downloads/fluent/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/coolio
	dev-ruby/iobuffer
	dev-ruby/jeweler
	>=dev-ruby/json-1.5.4
	>=dev-ruby/msgpack-0.4.4
	dev-ruby/yajl-ruby"

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}"

all_ruby_install() {
	all_fakegem_install

	# Location of conf files
	keepdir /etc/"${PN}"
}
