# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

#RUBY_FAKEGEM_VERSION="${PV//_/.}"
#RUBY_FAKEGEM_VERSION="${RUBY_FAKEGEM_VERSION//rc/rc.}"
#RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem

DESCRIPTION="A simple WSDL parser"
HOMEPAGE="https://github.com/rubiii/wasabi"
#SRC_URI="https://github.com/rubiii/${PN}/tarball/v${PV} -> ${P}.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}
	dev-ruby/rake
	dev-ruby/rspec"
RDEPEND="${RDEPEND}
	dev-ruby/httpi
	dev-ruby/nokogiri"

#each_ruby_configure() {
#	for extdir in ext ext/fastfilereader; do
#		pushd $extdir
#		${RUBY} extconf.rb || die "extconf.rb failed for ${extdir}"
#		popd
#	done
#}

#each_ruby_compile() {
#	for extdir in ext ext/fastfilereader; do
#		pushd $extdir
#		# both extensions use C++, so use the CXXFLAGS not the CFLAGS
#		emake CFLAGS="${CXXFLAGS} -fPIC" archflag="${LDFLAGS}" || die "emake failed for ${extdir}"
#		popd
#		cp $extdir/*.so lib/ || die "Unable to copy extensions for ${extdir}"
#	done
#}

#each_ruby_test() {
#	${RUBY} -Ilib -S testrb tests/test_*.rb || die
#}

#all_ruby_install() {
#	all_fakegem_install
#
#	insinto /usr/share/doc/${PF}/
#	doins -r examples || die "Failed to install examples"
#}
