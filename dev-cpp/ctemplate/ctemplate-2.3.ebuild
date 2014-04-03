# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AM_OPTS="--force-missing"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python2_7 )
inherit subversion autotools-utils elisp-common python-any-r1

DESCRIPTION="A simple but powerful template language for C++"
HOMEPAGE="http://code.google.com/p/ctemplate/"
#SRC_URI="http://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.bz2"
ESVN_REPO_URI="http://${PN}.googlecode.com/svn/tags/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc emacs vim-syntax static-libs test"

DEPEND="test? ( ${PYTHON_DEPS} )"
RDEPEND="vim-syntax? ( >=app-editors/vim-core-7 )
	emacs? ( virtual/emacs )"

DOCS=( AUTHORS ChangeLog NEWS README )

SITEFILE="70ctemplate-gentoo.el"

src_compile() {
	autotools-utils_src_compile

	if use emacs ; then
		elisp-compile contrib/tpl-mode.el || die "elisp-compile failed"
	fi
}

src_install() {
	autotools-utils_src_install

	# Installs just every piece
	rm -r "${ED}/usr/share/doc" || die

	use doc && dohtml doc/*

	if use vim-syntax ; then
		cd "${S}/contrib" || die
		sh highlighting.vim || die "unpacking vim scripts failed"
		insinto /usr/share/vim/vimfiles
		doins -r .vim/*
	fi

	if use emacs ; then
		cd "${S}/contrib" || die
		elisp-install ${PN} tpl-mode.el tpl-mode.elc || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}