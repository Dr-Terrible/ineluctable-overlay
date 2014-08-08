# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit netsurf

DESCRIPTION="framebuffer abstraction library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libsvgtiny/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=net-libs/libdom-0.1.0[xml,static-libs?,${MULTILIB_USEDEP}]
	>=dev-libs/libwapcaplet-0.2.1[static-libs?,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/gperf"
