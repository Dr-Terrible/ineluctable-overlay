# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ree18 ruby19"

RUBY_FAKEGEM_VERSION="${PV//_/.}"
RUBY_FAKEGEM_VERSION="${RUBY_FAKEGEM_VERSION//rc/rc.}"
RUBY_FAKEGEM_DOCDIR="rdoc"

inherit ruby-fakegem

DESCRIPTION="EventMachine is a fast, simple event-processing library for Ruby programs."
HOMEPAGE="http://rubyeventmachine.com"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="${DEPEND}
	dev-libs/openssl"
RDEPEND="${RDEPEND}
	dev-libs/openssl"

each_ruby_configure() {
	for extdir in ext ext/fastfilereader; do
		pushd $extdir
		${RUBY} extconf.rb || die "extconf.rb failed for ${extdir}"
		popd
	done
}

each_ruby_compile() {
	for extdir in ext ext/fastfilereader; do
		pushd $extdir
		# both extensions use C++, so use the CXXFLAGS not the CFLAGS
		emake CFLAGS="${CXXFLAGS} -fPIC" archflag="${LDFLAGS}" || die "emake failed for ${extdir}"
		popd
		cp $extdir/*.so lib/ || die "Unable to copy extensions for ${extdir}"
	done
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb tests/test_*.rb || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}/
	doins -r examples || die "Failed to install examples"
}
