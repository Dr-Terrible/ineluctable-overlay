# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit versionator subversion

DESCRIPTION="Style guides for Google-originated open-source projects"
HOMEPAGE="https://code.google.com/p/google-styleguide/"

REV="$( get_version_component_range 1 )"
ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk@${REV}"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

src_prepare() {
	rm -r cpplint || die
}

src_install() {
	dohtml -A xml,xsl -r ./.
}