# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ECOMMIT="fdf2097"

DESCRIPTION="Client library and CLI to deploy apps on Heroku"
HOMEPAGE="https://devcenter.heroku.com/articles/heroku-cli"
#SRC_URI="x86? ( https://cli-assets.heroku.com/${PN}/channels/stable/${PN}-v${PV}-${ECOMMIT}-linux-x86.tar.gz -> ${P}.x86.tar.gz )"
SRC_URI="https://cli-assets.heroku.com/${PN}/channels/stable/${PN}-v${PV}-${ECOMMIT}-linux-x64.tar.gz -> ${P}.x64.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!dev-util/heroku-toolbelt
	net-libs/nodejs[npm]
	dev-vcs/git"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-v${PV}-${ECOMMIT}-linux-x64"

src_install(){
	local npm_module_dir="/usr/$(get_libdir)/node/${PN}"

	# install libraries
	insinto "${npm_module_dir}"
	doins package.json
	doins -r lib
	dodoc *.md

	# install binaries
	# NOTE: 'heroku' binary uses a relative path to find the ./lib
	# directory, so we have to symlink it rather than use dobin().
	exeinto "${npm_module_dir}/bin"
	doexe bin/heroku
	doexe bin/node
	dosym "${npm_module_dir}/bin/heroku" "/usr/bin/heroku"
	insinto "${npm_module_dir}/bin"
	doins bin/*.js

	# install node modules
	cp -ar node_modules "${ED}"/${npm_module_dir} || die
}
