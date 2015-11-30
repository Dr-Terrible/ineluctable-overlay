# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic

MY_PN="${PN/jarom/JaroM}"
ECOMMIT="e3c34f9020ba5ba2da783ce56849a1ccd0a11e8d"

DESCRIPTION="A command-line MUA to easily and privately handle your e-mails."
HOMEPAGE="https://dyne-org/software/jaro-mail"
SRC_URI="https://github.com/dyne/${PN}/archive/${ECOMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sasl doc"

S="${WORKDIR}/${MY_PN}-${ECOMMIT}"

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

PATCHES=(

)

src_prepare() {
	sed -i \
		-e "s:cc=\"gcc -O3\":cc=\"\${CC}\":" \
		-e "s:which:#which:" \
		build/build-gnu.sh || die

	epatch "${FILESDIR}"/${PN}-filters.patch
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

	# Installing docs
	if use doc; then
		dodoc \
			doc/howto_gmail_fetchmail_procmail.txt \
			doc/*.pdf

		rm doc/howto_gmail_fetchmail_procmail.txt || die
	fi
	einstalldocs

	# Installing configuration files
	insinto /usr/share/${PN}
	doins -r doc/Accounts
	doins doc/*.txt

	# Installing jaromail wrapper
	cat <<EOF > "${T}"/jaro
#!/usr/bin/env zsh
export JAROWORKDIR=/usr/share/${PN}
\${JAROWORKDIR}/bin/jaro \${=@}
EOF
	dobin "${T}"/jaro

}

pkg_postinst() {
	einfo "As a user, initialize your Mail directory by running:"
	einfo "  $ jaro init"
	einfo
	einfo "Default is '\$HOME/Mail', but it can be changed via environment variable JAROMAILDIR."
}