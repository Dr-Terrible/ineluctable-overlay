# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Bash Automated Testing System"
HOMEPAGE="https://github.com/sstephenson/%{PN}"
SRC_URI="https://github.com/sstephenson/${PN}/archive/v${PV}.tar.gz -> ${PN}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE="test"

src_install() {
	dobin bin/*

	insinto /usr/libexec
	doins libexec/*

	doman man/${PN}.{1,7}
}

src_test() {
	bin/bats --tap test || die
}
