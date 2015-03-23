# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
#inherit git-r3

EGIT_COMMIT="30e8afd4aee46e6f9cc233b35d81be22f5eab542"

DESCRIPTION="Game Programming Patterns"
HOMEPAGE="http://gameprogrammingpatterns.com"
SRC_URI="https://github.com/munificent/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k ~s390 ~sh ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

DEPEND="dev-python/markdown[pygments]
	dev-python/smartypants
	>=dev-ruby/sass-3.4.0:3.4"

# Only installs fonts
RESTRICT="binchecks strip test mirror"

src_compile() {
	${PYTHON} script/format.py
}

src_install() {
	dohtml -r html/*
}
