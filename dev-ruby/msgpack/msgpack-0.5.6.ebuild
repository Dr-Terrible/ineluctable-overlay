# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# jruby → uses a binary extension
USE_RUBY="ruby18 ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="Binary-based efficient data interchange format for ruby binding"
HOMEPAGE="http://msgpack.sourceforge.jp/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

ruby_add_bdepend "doc? ( dev-ruby/yard )"

each_ruby_prepare() {
	case "${RUBY}" in
		*ruby18)
			# Fix tests as .clear is not available in ruby18
			# Tests are working, but are very slow on ruby18
			sed -i -e 's/s.clear/s.replace ""/' spec/buffer_spec.rb || die
			;;
		*)
			;;
	esac
}

each_ruby_configure() {
	${RUBY} -Cext/${PN} extconf.rb || die "Configuration of extension failed."
}

each_ruby_compile() {
	emake -Cext/${PN}
	cp ext/${PN}/msgpack$(get_modname) lib/${PN} || die "Unable to install msgpack library."
}
