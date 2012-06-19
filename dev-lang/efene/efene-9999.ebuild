# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit git-2

DESCRIPTION="efene provides an alternative syntax to erlang similar to Java, C, C++, C#, Javascript"
HOMEPAGE="http://www.efenelang.org"
EGIT_REPO_URI="git://github.com/marianoguerra/efene.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-lang/erlang-11.2.5"
RDEPEND="${DEPEND}"

src_compile() {
	sh "${S}"/build.sh || die
}
