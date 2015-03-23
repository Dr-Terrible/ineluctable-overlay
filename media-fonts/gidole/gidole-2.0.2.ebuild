# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit font

EGIT_COMMIT="c22ede81d113e9b873009c410b2d61b2e36d87a3"

DESCRIPTION="Gidole is a Modern DIN fontset"
HOMEPAGE="http://gidole.github.io"
SRC_URI="https://github.com/${PN}/Gidole-Typefaces/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""

S="${WORKDIR}/Gidole-Typefaces-${EGIT_COMMIT}"

FONT_SUFFIX="ttf otf"
FONT_S="${S}/Resources/GidoleFont/"

# Only installs fonts
RESTRICT="binchecks strip test mirror"