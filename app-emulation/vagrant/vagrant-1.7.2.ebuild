# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit rpm

DESCRIPTION="A tool for building and distributing virtual machines"
HOMEPAGE="http://vagrantup.com/"
SRC_URI="amd64? ( https://dl.bintray.com/mitchellh/vagrant/vagrant_${PV}_x86_64.rpm )
	x86? ( https://dl.bintray.com/mitchellh/vagrant/vagrant_${PV}_i686.rpm )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Missing ebuild for contest
RESTRICT="mirror strip"

RDEPEND="!<app-emulation/vagrant-1.7.0
	net-misc/curl:0"

S="${WORKDIR}"

src_install() {
	mv {opt,usr} "${ED}" || die 'install failed'
}