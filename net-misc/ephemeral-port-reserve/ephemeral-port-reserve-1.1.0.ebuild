# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Find an unused port, reliably"
HOMEPAGE="https://github.com/Yelp/${PN}"
SRC_URI="https://github.com/Yelp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"

RESTRICT+=" mirror"
