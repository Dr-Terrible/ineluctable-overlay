# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 cmake-multilib git-r3

DESCRIPTION="http://ffevotte.github.io/clang-tags/"
HOMEPAGE="https://github.com/ffevotte/clang-tags"

EGIT_REPO_URI="https://github.com/ffevotte/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

DEPEND=""
RDEPEND="${DEPEND}
	dev-libs/boost
	>=dev-libs/jsoncpp-1.4.0
	>=sys-devel/clang-3.2
	dev-db/sqlite:3
	net-misc/socat
	dev-util/strace"

src_prepare() {
	python_fix_shebang . || die
}