# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PHP_LIB_NAME="Zend"

inherit php-lib-r1

KEYWORDS="amd64 hppa ~ppc x86"

DESCRIPTION="Zend Framework is a high quality and open source framework for developing Web Applications"
HOMEPAGE="http://framework.zend.com"
SRC_URI="!minimal? ( http://framework.zend.com/releases/${P}/${P}.tar.gz )
	minimal? ( http://framework.zend.com/releases/${P}/${P}-minimal.tar.gz )
	doc? (
		http://framework.zend.com/releases/${P}/${P}-apidoc.tar.gz
		http://framework.zend.com/releases/${P}/${P}-manual-en.tar.gz )"
LICENSE="BSD"
SLOT="0"
IUSE="doc examples minimal cli"

DEPEND="cli? ( dev-lang/php[simplexml,tokenizer,cli] )"
RDEPEND="${DEPEND}"
need_php_by_category

src_prepare() {
	if use minimal ; then
		S="${WORKDIR}/${P}-minimal"
		if use doc ; then
			mv "${WORKDIR}/${P}/documentation" "${S}"
		fi
	fi
}

src_install() {
	if use cli ; then
		einfo "Installing cli"
		insinto /usr/bin
		doins bin/zf.php
		dobin bin/zf.sh
		dosym /usr/bin/zf.sh /usr/bin/zf
	fi
	einfo "Installing library"
	insinto /usr/share/php/"${PHP_LIB_NAME}"
	doins -r library/Zend/*

	if ! use minimal ; then
		einfo "Installing Dojo toolkit"
		insinto /usr/share/php
		doins -r externals/dojo
	fi

	if use examples ; then
		einfo "Installing examples"
		insinto /usr/share/doc/${PF}

		if ! use minimal ; then
			doins -r demos
		fi
	fi

	dodoc README.txt
	if use doc ; then
		einfo "Installing documentations"
		dohtml -r documentation/*
	fi
}

pkg_postinst() {
	elog "For more info, please take a look at the manual at:"
	elog "http://framework.zend.com/manual"
	elog ""

	if use minimal; then
		elog "You have installed the minimal version of ZendFramework,"
		elog "so the Dojo toolkit, demos and tests have not been installed."
	else
		elog "You have installed the full version of ZendFramework, which"
		elog "includes the Dojo toolkit, demos and tests."
		elog "To install ZendFramework without these, enable the"
		elog "minimal USE flag."
	fi
}
