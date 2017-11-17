# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/toolbelt/client}"

DESCRIPTION="Client library and CLI to deploy apps on Heroku"
HOMEPAGE="https://toolbelt.heroku.com"
SRC_URI="https://s3.amazonaws.com/assets.heroku.com/${MY_PN}/${MY_PN}-${PV}.tgz -> ${PF}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}"

RDEPEND="virtual/ruby
	dev-vcs/git"

src_install() {
	dodir /opt
	cp -R "${S}" "${D}/opt/" || die "Install failed"
	dosym "/opt/${MY_PN}/bin/heroku" "/usr/bin/heroku"
}
