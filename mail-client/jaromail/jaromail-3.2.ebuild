# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic

MY_PN="${PN/jarom/JaroM}"

DESCRIPTION="A command-line MUA to easily and privately handle your e-mails."
HOMEPAGE="https://dyne-org/software/jaro-mail"
SRC_URI="https://github.com/dyne/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+sasl doc"

S="${WORKDIR}/${MY_PN}-${PV}"

RESTRICT="mirror"

# 	mail-client/alot
RDEPEND="mail-client/mutt[imap,mbox,sasl?,smime]
	net-mail/fetchmail[ssl,kerberos]
	mail-mta/msmtp[ssl,sasl?]
	net-mail/notmuch[crypt]
	>=app-misc/abook-0.6.1_pre1
	app-misc/wipe
	app-crypt/pinentry[gnome-keyring,ncurses,caps]
	mail-client/mutt[gpg]
	app-crypt/gnupg[readline,tools]
	dev-db/sqlite[secure-delete]
	app-shells/zsh[pcre]"

DEPEND="sys-devel/bison
	sys-devel/flex
	gnome-base/libgnome-keyring:0"

DOCS=(README.md TODO.md KNOWN_BUGS.md ChangeLog.md)

src_prepare() {
	sed -i \
		-e "s:cc=\"gcc -O3\":cc=\"\${CC}\":" \
		-e "s:which:#which:" \
		build/build-gnu.sh || die
}

src_configure() { :; }

src_compile() {
	tc-export CC
	export CC="$CC $CFLAGS $LDFLAGS"
	default
}

src_install() {
	insinto /usr/share/${PN}/.mutt
	doins -r src/mutt/*

	insinto /usr/share/${PN}/.stats
	doins -r src/stats/*

	# Installing the executables
	exeinto /usr/share/${PN}/bin
	doexe build/gnu/*
	doexe src/jaro

	# Installing ZSH libraries
	insinto /usr/share/${PN}/zlibs
	doins -r src/zlibs/*

	# Installing jaromail wrapper
	cat <<EOF > "${T}"/jaro
#!/usr/bin/env zsh
export JAROWORKDIR=/usr/share/${PN}
\${JAROWORKDIR}/bin/jaro \${=@}
EOF
	dobin "${T}"/jaro

	# Installing docs
	use doc && dodoc -r doc/*
	einstalldocs
}

pkg_postinst() {
	einfo "To initialize your Mail directory use: jaro init"
	einfo "Default is '\$HOME/Mail', but it can be changed via environment variable JAROMAILDIR."
}