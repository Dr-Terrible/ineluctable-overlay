# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="CLI that provides on-demand secrets access for common DevOps tools"
HOMEPAGE="https://github.com/cyberark/summon"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* amd64 arm64"
IUSE="+pie"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md SECURITY.md )

#RDEPEND=">=gui-apps/wl-clipboard-2.0.0
#	libnotify? ( x11-libs/libnotify )"

EGO_SUM=(
	"github.com/codegangsta/cli v1.20.0"
	"github.com/codegangsta/cli v1.20.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/gopherjs/gopherjs v0.0.0-20181103185306-d547d1d9531e"
	"github.com/gopherjs/gopherjs v0.0.0-20181103185306-d547d1d9531e/go.mod"
	"github.com/jtolds/gls v4.20.0+incompatible"
	"github.com/jtolds/gls v4.20.0+incompatible/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/smartystreets/assertions v0.0.0-20180927180507-b2de0cb4f26d"
	"github.com/smartystreets/assertions v0.0.0-20180927180507-b2de0cb4f26d/go.mod"
	"github.com/smartystreets/goconvey v0.0.0-20181108003508-044398e4856c"
	"github.com/smartystreets/goconvey v0.0.0-20181108003508-044398e4856c/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.6.1"
	"github.com/stretchr/testify v1.6.1/go.mod"
	"golang.org/x/net v0.0.0-20181201002055-351d144fa1fc"
	"golang.org/x/net v0.0.0-20181201002055-351d144fa1fc/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
	)
go-module_set_globals

SRC_URI="https://github.com/cyberark/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

src_compile() {
	go build ${GOFLAGS} -buildmode="$(usex pie pie default)" -o bin/${PN} ./cmd || die "compile failed"
}

src_install() {
	dobin bin/${PN}
	default
}
