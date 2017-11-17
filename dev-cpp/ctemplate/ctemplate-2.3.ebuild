# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python2_7 )
inherit autotools-utils elisp-common python-any-r1

DESCRIPTION="A simple but powerful template language for C++"
HOMEPAGE="http://code.google.com/p/ctemplate/"
SRC_URI="https://github.com/OlafvdSpek/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc emacs vim-syntax static-libs test"

DEPEND="test? ( ${PYTHON_DEPS} )"
RDEPEND="vim-syntax? ( >=app-editors/vim-core-7 )
	emacs? ( virtual/emacs )"

S="${WORKDIR}/${PN}-${PN}-${PV}"

RESTRICT="mirror"

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
		pushd "${S}/contrib"
		sh highlighting.vim || die "unpacking vim scripts failed"
		insinto /usr/share/vim/vimfiles
		doins -r .vim/*
		popd
	fi

	if use emacs ; then
		pushd "${S}/contrib"
		elisp-install ${PN} tpl-mode.el tpl-mode.elc || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		popd
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
