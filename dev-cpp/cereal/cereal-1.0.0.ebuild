# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit flag-o-matic cmake-utils

DESCRIPTION="Cereal is a header-only C++11 serialization library"
HOMEPAGE="http://uscilab.github.io/cereal"
SRC_URI="https://github.com/USCiLab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

# We need a gcc version high enough to support C++11/14
DEPEND="test? (
		dev-libs/boost
		dev-util/valgrind
	)
	doc? ( app-doc/doxygen )
	>=sys-devel/gcc-4.8.0"

src_prepare() {
	sed -i \
		"s/-Wall -Werror -g -Wextra -Wshadow -pedantic//g" CMakeLists.txt || die
	sed -i -e \
		"s/@CMAKE_CURRENT_SOURCE_DIR@/./g" doc/doxygen.in || die
}

src_configure() {
	use test || return
	cmake-utils_src_configure
}
src_compile() {
	use test || return
	cmake-utils_src_compile
}

# Their makefile has no install target.  Rather, we need to just copy the
# include/cereal directory to /usr/include.
src_install() {
	insinto /usr/include
	doins -r include/cereal

	if use doc; then
		einfo "Generating API documentation with Doxygen ..."
		doxygen -u doc/doxygen.in || die
		doxygen doc/doxygen.in || die "doxygen failed"
		dohtml -r doc/html/*
	fi

#	# Top level include directory.
#	dodir   /usr/include/cereal
#	insinto /usr/include/cereal
#
#	doins include/cereal/access.hpp include/cereal/cereal.hpp
#
#	# Support for different archive formats.
#	dodir   /usr/include/cereal/archives
#	insinto /usr/include/cereal/archives
#
#	doins include/cereal/archives/binary.hpp
#	doins include/cereal/archives/json.hpp
#	doins include/cereal/archives/portable_binary.hpp
#	doins include/cereal/archives/xml.hpp
#
#	# Plumbing
#	dodir   /usr/include/cereal/details
#	insinto /usr/include/cereal/details
#
#	doins include/cereal/details/helpers.hpp
#	doins include/cereal/details/polymorphic_impl.hpp
#	doins include/cereal/details/static_object.hpp
#	doins include/cereal/details/traits.hpp
#	doins include/cereal/details/util.hpp
#
#	# Various STL and Boost types.
#	dodir   /usr/include/cereal/types
#	insinto /usr/include/cereal/types
#
#	doins include/cereal/types/array.hpp
#	doins include/cereal/types/base_class.hpp
#	doins include/cereal/types/bitset.hpp
#	doins include/cereal/types/boost_variant.hpp
#	doins include/cereal/types/chrono.hpp
#	doins include/cereal/types/common.hpp
#	doins include/cereal/types/complex.hpp
#	doins include/cereal/types/deque.hpp
#	doins include/cereal/types/forward_list.hpp
#	doins include/cereal/types/list.hpp
#	doins include/cereal/types/map.hpp
#	doins include/cereal/types/memory.hpp
#	doins include/cereal/types/polymorphic.hpp
#	doins include/cereal/types/queue.hpp
#	doins include/cereal/types/set.hpp
#	doins include/cereal/types/stack.hpp
#	doins include/cereal/types/string.hpp
#	doins include/cereal/types/tuple.hpp
#	doins include/cereal/types/tuple.hpp
#	doins include/cereal/types/unordered_map.hpp
#	doins include/cereal/types/unordered_set.hpp
#	doins include/cereal/types/utility.hpp
#	doins include/cereal/types/vector.hpp
#
#	# External libraries included by cereal.
#	dodir   /usr/include/cereal/external
#	insinto /usr/include/cereal/external
#
#	doins include/cereal/external/base64.hpp
#
#	# RapidJSON
#	dodir   /usr/include/cereal/external/rapidjson
#	insinto /usr/include/cereal/external/rapidjson
#
#	doins include/cereal/external/rapidjson/document.h
#	doins include/cereal/external/rapidjson/filestream.h
#	doins include/cereal/external/rapidjson/genericstream.h
#	doins include/cereal/external/rapidjson/prettywriter.h
#	doins include/cereal/external/rapidjson/rapidjson.h
#	doins include/cereal/external/rapidjson/reader.h
#	doins include/cereal/external/rapidjson/stringbuffer.h
#	doins include/cereal/external/rapidjson/writer.h
#
#	# RapidJSON internals
#	dodir   /usr/include/cereal/external/rapidjson/internal
#	insinto /usr/include/cereal/external/rapidjson/internal
#
#	doins include/cereal/external/rapidjson/internal/pow10.h
#	doins include/cereal/external/rapidjson/internal/stack.h
#	doins include/cereal/external/rapidjson/internal/strfunc.h
#
#	# RapidXML
#	dodir   /usr/include/cereal/external/rapidxml
#	insinto /usr/include/cereal/external/rapidxml
#
#	doins include/cereal/external/rapidxml/rapidxml.hpp
#	doins include/cereal/external/rapidxml/rapidxml_iterators.hpp
#	doins include/cereal/external/rapidxml/rapidxml_print.hpp
#	doins include/cereal/external/rapidxml/rapidxml_utils.hpp
}