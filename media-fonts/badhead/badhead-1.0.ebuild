# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit font

DESCRIPTION="Badhead typefaces suitable for branding, logotypes, or any design with strong and elegant touch."
HOMEPAGE="http://ianmikraz.com"
SRC_URI="http://pixelbuddha.net/sites/default/files/freebie/freebie-archive-1427098078.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""

RESTRICT="mirror"

S="${WORKDIR}/Badhead-Typeface"

FONT_SUFFIX="ttf otf eot svg woff woff2"