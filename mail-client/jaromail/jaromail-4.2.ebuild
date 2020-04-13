# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic

MY_PN="${PN/jarom/JaroM}"

DESCRIPTION="A command-line MUA to easily and privately handle your e-mails."
HOMEPAGE="https://dyne.org/software/jaro-mail"
SRC_URI="https://github.com/dyne/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+sasl doc"

S="${WORKDIR}/${MY_PN}-${PV}"

RESTRICT="mirror"

# 	mail-client/alot
RDEPEND="mail-client/mutt[imap,mbox,sasl?,smime]
	net-mail/fetchmail[ssl]
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
	"${FILESDIR}"/${PN}-filters.patch
)

src_prepare() {
	sed -i \
		-e "s:cc=\"gcc -O3\":cc=\"\${CC}\":" \
		-e "s:which:#which:" \
		build/build-gnu.sh || die

	default
	#epatch "${FILESDIR}"/${PN}-filters.patch
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
		pwd
		ls -la
		dodoc \
			doc/howto_gmail_fetchmail_and_procmail.txt
			doc/*.pdf

		rm doc/howto_gmail_fetchmail_and_procmail.txt || die
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
