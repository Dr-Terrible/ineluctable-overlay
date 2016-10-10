# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="Debugger for zsh"
HOMEPAGE="https://github.com/rocky/${PN}"
SRC_URI="https://github.com/rocky/${PN}/archive/release-${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"

RDEPEND="app-shells/zsh"

RESTRICT="mirror"
S="${WORKDIR}/${PN}-release-${PV}"
