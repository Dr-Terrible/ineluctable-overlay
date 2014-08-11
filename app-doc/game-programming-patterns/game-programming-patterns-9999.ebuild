# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-r3

DESCRIPTION="Game Programming Patterns"
HOMEPAGE="http://gameprogrammingpatterns.com"
EGIT_REPO_URI="https://github.com/munificent/${PN}.git"

LICENSE="CC-BY-SA-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k ~s390 ~sh ~x86"
IUSE=""

DEPEND="dev-python/markdown[pygments]
	dev-python/smartypants
	dev-ruby/sass:3.3"

src_compile() {
	${PYTHON} script/format.py
}

src_install() {
	dohtml -r html/*
}
