# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit font

DESCRIPTION="This font is based on the handwriting of a Korean high school student"
HOMEPAGE="http://www.kimberlygeswein.com"
SRC_URI="http://www.google.com/fonts/download?kit=arxgS292ade0M86y2fSGafomiPJVUWlZDkpzTy57LNo -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""

S="${WORKDIR}"

FONT_SUFFIX="ttf"
FONT_S="${S}"

# Only installs fonts
RESTRICT="binchecks strip test mirror"