# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Trapped in a hostile computer system, you must make a way out"
HOMEPAGE="https://github.com/linleyh/liberation-circuit"
SRC_URI="https://github.com/linleyh/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RESTRICT="mirror"

RDEPEND="media-libs/allegro:5[X,jpeg,png,pulseaudio,vorbis,flac,truetype,gtk]"

src_compile() {
	sh do || die
}

src_install() {
	dodoc bin/{licence.txt,Manual.html,readme.txt}
	rm bin/{licence.txt,Manual.html,readme.txt,libcirc,launcher.sh} || die

	insinto /usr/share/games/${PN}
	doins -r bin/*

	newins src/g_game libcirc
	fperms ugo+x /usr/share/games/${PN}/libcirc

	cat - > "${T}"/libcirc <<EOF
#!/bin/sh
cd /usr/share/games/${PN}
exec /usr/share/games/${PN}/libcirc "\$@"
EOF
	dobin "${T}"/libcirc
}
