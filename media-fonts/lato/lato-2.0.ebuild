# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit font

GF_ID="NdjKCQMCiQM2g3qf94rrwQ"

DESCRIPTION="Lato is a sanserif typeface family designed in the Summer 2010"
HOMEPAGE="http://www.latofonts.com"
SRC_URI="http://www.google.com/fonts/download?kit=${GF_ID} -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""

S="${WORKDIR}"

FONT_SUFFIX="ttf"
FONT_S="${S}"

# Only installs fonts
RESTRICT="binchecks strip test mirror"