# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit bash-completion-r1 eutils python-r1

DESCRIPTION="DuckDuckGo from the terminal"
HOMEPAGE="https://github.com/jarun/${PN}"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bash-completion fish-completion zsh-completion"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

src_compile() { :; }

src_install(){
	emake PREFIX="/usr" DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" install
	use bash-completion && newbashcomp auto-completion/bash/${PN}-completion.bash ${PN}
	if use fish-completion; then
		insinto /usr/share/fish/vendor_completions.d/
		doins auto-completion/fish/${PN}.fish
	fi
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins auto-completion/zsh/_${PN}
	fi
}
