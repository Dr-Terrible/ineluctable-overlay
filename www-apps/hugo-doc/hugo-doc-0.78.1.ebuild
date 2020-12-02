# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Documentation for Hugo www-apps/hugo"
HOMEPAGE="https://gohugo.io"
SRC_URI="https://github.com/gohugoio/hugoDocs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=www-apps/hugo-$(ver_cut 1-2)"

S="${WORKDIR}/${P/-doc/Docs}"

pkg_setup() {
	if has network-sandbox $FEATURES; then
		eerror "Doc generation require 'network-sandbox' to be disabled in FEATURES."
	fi
}

src_install() {
	einfo "Updating theme"
	hugo mod get -u github.com/gohugoio/gohugoioTheme || die
	hugo mod vendor || die

	einfo "Building documentation"
	HUGO_IGNOREERRORS=error-remote-getjson \
	HUGO_UGLYURLS=true \
	HUGO_CANONIFYURLS=true \
	hugo -d "${T}"/docs \
		--baseURL="file:///usr/share/doc/${PF}/html/" \
		--disableKinds=404 \
		--disableKinds=RSS \
		--disableKinds=sitemap \
		--noTimes=true \
		--enableGitInfo=false \
		--verbose \
		--gc \
		--minify \
		|| die
	docinto html
	dodoc -r "${T}"/docs/*
}
