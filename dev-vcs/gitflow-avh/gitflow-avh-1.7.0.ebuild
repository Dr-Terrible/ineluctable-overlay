# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit bash-completion-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/petervanderdoes/gitflow.git"
	#EGIT_BRANCH="master"
	#EGIT_HAS_SUBMODULES=1
else
	SRC_URI="https://github.com/petervanderdoes/${PN//-avh/}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/petervanderdoes/git-flow-completion/archive/0.5.1.tar.gz -> ${PN}-completion-0.5.1.tar.gz"
fi

DESCRIPTION="Git extensions to provide repository operations for Vincent Driessen's branching model (AVH edition)"
HOMEPAGE="https://github.com/petervanderdoes/${PN}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion zsh-completion fish-completion"

RDEPEND="bash-completion? (  app-shells/bash-completion )
	zsh-completion? ( app-shells/zsh-completion )
	fish-completion? ( app-shells/fish )
	sys-apps/util-linux
	>=dev-libs/shflags-1.0.3"

S="${WORKDIR}/${P//-avh}"

src_install() {
	emake prefix="${D}/usr" install || die "emake install failed"

	if use bash-completion; then
		dobashcomp "${WORKDIR}"/git-flow-completion-0.5.1/git-flow-completion.bash
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins \
			"${WORKDIR}"/git-flow-completion-0.5.1/git-flow-completion.zsh \
			"${WORKDIR}"/git-flow-completion-0.5.1/git-flow-completion.plugin.zsh
	fi
	if use fish-completion ; then
		insinto /usr/share/fish/completions
		newins "${WORKDIR}"/git-flow-completion-0.5.1/git.fish git-flow-completion.fish
	fi
}