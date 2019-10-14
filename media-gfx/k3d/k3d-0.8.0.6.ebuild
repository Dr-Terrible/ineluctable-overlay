# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
inherit eutils python-any-r1 cmake-utils flag-o-matic

DESCRIPTION="A free 3D modeling, animation, and rendering system"
HOMEPAGE="http://www.k-3d.org"
SRC_URI="https://github.com/K-3D/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="3ds cuda cgal collada doc gnome gts imagemagick jpeg mime nls openexr osmesa png python svg test tiff truetype threads"

RDEPEND="
	dev-libs/boost[python]
	>=dev-cpp/glibmm-2.6:2
	>=dev-cpp/gtkmm-2.6:2.4
	dev-libs/expat
	>=dev-libs/libsigc++-2.2:2
	media-libs/mesa[osmesa?]
	virtual/glu
	virtual/opengl
	>=x11-libs/gtkglext-1.0.6-r3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXmu
	x11-libs/libXt
	media-libs/ftgl
	dev-cpp/cairomm
	3ds? ( media-libs/lib3ds )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	cgal? ( sci-mathematics/cgal )
	collada? ( media-libs/opencollada )
	gnome? ( gnome-base/gnome-vfs:2 )
	gts? ( sci-libs/gts )
	imagemagick? ( media-gfx/imagemagick )
	jpeg? ( virtual/jpeg:0 )
	openexr? ( media-libs/openexr )
	png? ( >=media-libs/libpng-1.2.43-r2:= )
	python? ( ${PYTHON_DEPS} dev-python/cgkit )
	tiff? ( media-libs/tiff:0 )
	truetype? ( >=media-libs/freetype-2 )
	threads? ( dev-cpp/tbb )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen dev-python/epydoc )
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${PN}-${P}"

# k3d_use_enable()
#

#     that is -DK3D_BUILD_$2
#
# e.g.) k3d_use_enable gnome GNOME_MODULE #=> -DK3D_BUILD_GNOME_MODULE=ON
#
k3d_use_enable() {
	echo "-DK3D_BUILD_$2=$(use $1 && echo ON || echo OFF)"
}

k3d_use_module() {
	echo "-DK3D_BUILD_$2_MODULE=$(use $1 && echo ON || echo OFF)"
}

PATCHES=(
	"${FILESDIR}"/${P}-gcc.patch
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${P}-gold-linker.patch
	"${FILESDIR}"/${P}-libgio.patch
	"${FILESDIR}"/${P}-multilib-strict.patch
	"${FILESDIR}"/${P}-glibmm.patch
)

src_configure() {
	mycmakeargs=(
		-DK3D_BUILD_SVG_IO_MODULE=$(usex svg)
		-DK3D_BUILD_CGAL_MODULE=OFF
		-DK3D_BUILD_GPERFTOOLS_MODULE=OFF
		-DK3D_BUILD_AQSIS_MODULE=OFF
		-DK3D_BUILD_COMPIZ_MODULE=OFF
		-DK3D_BUILD_CARVE_MODULE=OFF
		-DK3D_BUILD_BUNDLED_RENDERMAN_ENGINES_MODULE=ON
		-DK3D_BUILD_SVG_IO_MODULE=$(usex svg)
		$(k3d_use_module 3ds 3DS_IO)
		$(k3d_use_module cuda CUDA)
		$(k3d_use_module cgal CGAL)
		$(k3d_use_module collada CCOLLADA_IO)
		$(k3d_use_module gnome GNOME)
		$(k3d_use_module gts GTS)
		$(k3d_use_module gts GTS_IO)
		$(k3d_use_module imagemagick IMAGEMAGICK_IO)
		$(k3d_use_module jpeg JPEG_IO)
		$(k3d_use_module mime FILE_MAGIC)
		-DK3D_ENABLE_NLS=$(usex nls)
		$(k3d_use_module openexr OPENEXR_IO)
		$(k3d_use_module png PNG_IO)
		-DK3D_ENABLE_PYTHON=$(usex python)
		$(k3d_use_module python PYTHON)
		$(k3d_use_module python PYUI)
		$(k3d_use_module python NGUI_PYTHON_SHELL)
		$(k3d_use_module python NGUI_PYTHON_SHELL_MODULE)
		$(k3d_use_enable python GUIDE)
		$(k3d_use_module tiff TIFF_IO)
		$(k3d_use_module truetype FREETYPE2)
		-DK3D_ENABLE_PARALLEL=$(usex threads)
		-DK3D_BUILD_DOCS=$(usex doc)
		-DK3D_BUILD_GUIDE=$(usex doc)
		-DK3D_ENABLE_TESTING=$(usex test)
	)
	cmake-utils_src_configure
}
