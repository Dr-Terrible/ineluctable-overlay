# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_IN_SOURCE_BUILD=1
inherit java-pkg-2 java-ant-2 cmake-utils

DESCRIPTION="FlatBuffers is a serialization library for memory constrained apps."
HOMEPAGE="https://google.github.io/${PN}"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples java test"

CDEPEND="java? ( >=dev-java/antlr-2.7.7:0[java] )"
DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.6 )"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.6 )"

HTML_DOCS=( docs/html )

pkg_setup() {
	use java && java-pkg-2_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
	use java && java-pkg-2_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFLATBUFFERS_INSTALL=ON
		-DFLATBUFFERS_BUILD_FLATLIB=ON
		-DFLATBUFFERS_BUILD_FLATC=ON
		-DFLATBUFFERS_BUILD_FLATHASH=ON
		$(cmake-utils_use test FLATBUFFERS_BUILD_TESTS)
	)
	cmake-utils_src_configure
}

src_compile() {
	# Compiles C++ libraries
	cmake-utils_src_compile

	# Compiles Java bindings
	if use java; then
		mkdir -p java/target/classes || die

		# compiles classes
		find java -iname "*.java" >> "${T}/sources" || die
		ejavac -d java/target/classes -cp $( java-pkg_getjars antlr ) "@${T}/sources"

		# generates javadoc
		if use doc; then
			mkdir javadoc || die
			javadoc -classpath $( java-pkg_getjars antlr ) -d javadoc "@${T}/sources" || die
		fi

		# jar classes up
		pushd java/target/classes > /dev/null
			find -type f >> "${T}/classes" || die
			jar cf ${PN}.jar "@${T}/classes" || die "jar failed"
		popd > /dev/null
	fi
}

src_install() {
	# Installs C++ libraries, compiler, and docs
	cmake-utils_src_install

	# Fix C++ doc nomenclature
	if use doc; then
		mv \
			"${ED}"/usr/share/doc/${PF}/html/html \
			"${ED}"/usr/share/doc/${PF}/html/cpp-api \
			|| die
	fi

	# Installs examples
	use examples && dodoc -r samples

	# Installs JARs and JavaDoc
	if use java; then
		java-pkg_dojar java/target/classes/${PN}.jar
		use doc && java-pkg_dojavadoc javadoc
		mv \
			"${ED}"/usr/share/doc/${PF}/html/api \
			"${ED}"/usr/share/doc/${PF}/html/java-api \
			|| die
	fi
}