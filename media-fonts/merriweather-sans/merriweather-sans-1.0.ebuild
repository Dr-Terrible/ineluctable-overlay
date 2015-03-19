# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit font

DESCRIPTION="Merriweather was designed to be a fontset that is pleasant to read on screen."
HOMEPAGE="http://ebensorkin.wordpress.com"
SRC_URI="http://www.google.com/fonts/download?kit=s4O10yPBd1olb1Ov_nSQdJljFZ0yalMVtZRNyYF55rg -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""

S="${WORKDIR}"

FONT_SUFFIX="ttf"
FONT_S="${S}"

# Only installs fonts
RESTRICT="binchecks strip test mirror"