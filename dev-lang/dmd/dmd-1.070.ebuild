# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils bash-completion-r1 flag-o-matic

DESCRIPTION="Reference compiler for the D programming language"
HOMEPAGE="http://www.digitalmars.com/d/"
SRC_URI="http://ftp.digitalmars.com/${PN}.${PV}.zip"

LICENSE="DMD"
SLOT="1"
KEYWORDS="-* ~amd64 ~x86"
IUSE="doc examples debug"

RESTRICT="mirror"

DEPEND="!dev-lang/dmd-bin
	app-arch/unzip"
PDEPEND="app-admin/eselect-dmd"

S="${WORKDIR}/${PN}"

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

	# misc patches for the build process
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	# determine architecture model
	MODEL=32
	use amd64 && MODEL=64

	# determine dmd binary absoluth path
	DMD="${S}/src/dmd/dmd"

	# determine build type
	BUILD="release"
	use debug && BUILD="debug"

	# Instead of filtering --as-needed (bug #128505), append --no-as-needed
	# fix: gcold.o: No such file or directory
	append-ldflags $(no-as-needed)

	# compiling dmd and phobos
	cd "${S}"/src || die
	for project in "${S}"/src/{dmd,phobos}; do
		local project_name=$( basename ${project} )
		local project_makefile="posix"
		[[ "phobos" == ${project_name} ]] && project_makefile="linux"

		einfo "Compiling ${project_name} ..."
		# note: don't pass CC=$(tc-getCC) to the makefile as CC
		#       is (mis)used inside the makefile as a local variable
		emake -C ${project_name} -f ${project_makefile}.mak \
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

	# D Standard Library (Phobos)
	einfo "Installing D Standard Library (Phobos)"
	dolib.a "${S}"/src/phobos/lib${MODEL}/libphobos.a
	insinto /usr/include/${PN}-${SLOT}/phobos
	rm -r "${S}"/src/phobos/{*.mak,*.txt,lib${MODEL},std.ddoc,etc/c/zlib} || die
	doins -r "${S}"/src/phobos/*

	# Man pages
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

	einfo "Executing Unit Tests for phobos ..."
	emake -C phobos -f linux.mak \
		unittest \
		CXX="$(tc-getCXX)" \
		DMD="${DMD}" \
		MODEL="${MODEL}" \
		BUILD="${BUILD}"
}
