# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO:
# 1- fix misuse of the variable CC inside all the makefiles

EAPI=5
inherit eutils pax-utils bash-completion-r1 toolchain-funcs

DESCRIPTION="Reference compiler for the D programming language"
HOMEPAGE="http://www.digitalmars.com/d/"
SRC_URI="http://ftp.digitalmars.com/${PN}.${PV}.zip"

LICENSE="DMD"
SLOT="2"
KEYWORDS="-* ~amd64 ~x86"
IUSE="doc examples debug"

RESTRICT="mirror"

DEPEND="!dev-lang/dmd-bin
	app-arch/unzip"
PDEPEND="app-admin/eselect-dmd"

S="${WORKDIR}/${PN}${SLOT}"

rdos2unix() {
	edos2unix $(find . -name '*'.$1 -type f) \
		|| die "Failed to convert line-endings of all .$1 files"
}

src_prepare() {
	einfo "Removing precompiled binaries ..."
	rm -r "${S}"/{linux,osx,freebsd,windows} || die

	# convert line-endings of file-types that start
	# as cr-lf and are patched or installed later on
	einfo "Converting line-endings of files ..."
	rdos2unix c
	rdos2unix d
	rdos2unix txt
	rdos2unix css

	# various fixes for the makefiles
	# (LDFLAGS and CFLAGS not respected)
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	# determine architecture model
	MODEL="32"
	use amd64 && MODEL="64"

	# determine dmd binary absoluth path
	DMD="${S}/src/dmd/dmd"

	# determine build type
	BUILD="release"
	use debug && BUILD="debug"

	# compiling dmd, druntime and phobos
	cd "${S}"/src || die
	for project in "${S}"/src/{dmd,druntime,phobos}; do
		local project_name=$( basename ${project} )

		einfo "Compiling ${project_name} ..."
		# note: don't pass CC=$(tc-getCC) to the makefile as CC
		#       is (mis)used inside the makefile as a local variable
		emake -C ${project_name} -f posix.mak \
			CXX="$(tc-getCXX)" \
			DMD="${DMD}" \
			MODEL="${MODEL}" \
			BUILD="${BUILD}"
	done
}

src_install() {
	# Setup dmd.conf
	cat <<END > dmd.conf
[Environment]
DFLAGS=-I/usr/include/${PN}-${SLOT}/phobos -I/usr/include/${PN}-${SLOT}/druntime/import -L-L--no-warn-search-mismatch -L--export-dynamic -L-lrt
END
	insinto /etc
	doins dmd.conf

	# bashcompletion
	newbashcomp "${FILESDIR}/${PN}.bashcomp" "${PN}-${SLOT}.0"

	# Compiler and Elf utils
	einfo "Installing D compiler and Elf utils"
	exeinto /usr/bin
	mv "${S}"/src/dmd/dmd "${S}"/src/dmd/dmd-${SLOT}.0 || die
	doexe "${S}"/src/dmd/dmd-${SLOT}.0
	#doexe bin/rdmd
	#einfo "Installing Elf file dumper"
	#doexe bin/dumpobj
	#einfo "Installing Elf file disassembler"
	#doexe bin/obj2asm

	# D Runtime
	einfo "Installing D Runtime"
	dolib.a "${S}"/src/druntime/lib/libdruntime.a
	insinto /usr/include/${PN}-${SLOT}/druntime
	doins -r "${S}"/src/druntime/src/*
	doins -r "${S}"/src/druntime/import

	# D Standard Library (Phobos)
	einfo "Installing D Standard Library (Phobos)"
	dolib.a "${S}"/src/phobos/generated/linux/release/"${MODEL}"/libphobos2.a
	insinto /usr/include/${PN}-${SLOT}/phobos
	rm -r "${S}"/src/phobos/{*.mak,*.txt,generated,std.ddoc,index.d,etc/c/zlib} || die
	doins -r "${S}"/src/phobos/*

	# Man pages
	#doman man/*/*5 man/*/*1
	for MAN in "${S}"/man/man1/*1; do
		mv ${MAN} ${MAN/.1/\-${SLOT}.1} || die
		doman ${MAN/.1/-${SLOT}.1}
	done

	# Documentation
	use doc && dohtml -r html/d/*

	# Samples
	if use examples; then
		docinto examples
		dodoc -r samples/d/*
	fi
}
src_test() {
	cd "${S}"/src || die
	for project in "${S}"/src/{druntime,phobos}; do
		local project_name=$( basename ${project} )

		einfo "Executing Unit Tests for ${project_name} ..."
		emake -C ${project_name} -f posix.mak \
			unittest \
			CXX="$(tc-getCXX)" \
			DMD="${DMD}" \
			MODEL="${MODEL}" \
			BUILD="${BUILD}"
	done
}
#pkg_postinst() {
	# required for hardened profiles
	# FIX: libphobos2.a: could not read symbols: Bad value
#	pax-mark -m "${EPREFIX}"/usr/$(get_libdir)/libphobos2.a
#	pax-mark -m "${EPREFIX}"/usr/$(get_libdir)/libdruntime.a
#	pax-mark -m "${EPREFIX}"/usr/bin/dmd-${SLOT}.0
#}
