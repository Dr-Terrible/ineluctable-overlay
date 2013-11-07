# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_EXTRADOC="AUTHORS ChangeLog"
RUBY_FAKEGEM_EXTRAINSTALL="fluent.conf"
inherit ruby-fakegem

DESCRIPTION="Fluentd is a log collector daemon written in Ruby"
HOMEPAGE="http://fluentd.org"
SRC_URI="https://github.com/fluent/${PN}/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/coolio
	dev-ruby/iobuffer
	>=dev-ruby/jeweler-1.8.8
	>=dev-ruby/json-1.5.4
	>=dev-ruby/msgpack-0.5.6
	dev-ruby/yajl-ruby"

all_ruby_install() {
	all_fakegem_install

	# Location of conf files
	keepdir /etc/"${PN}"
}
