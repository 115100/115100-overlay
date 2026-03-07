# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An open-source AI agent that lives in your terminal."
HOMEPAGE="https://github.com/QwenLM/qwen-code"

SRC_URI="
	https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-${PV}.tgz -> ${P}.tar.gz
"
S=${WORKDIR}/package

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	net-libs/nodejs
	sys-apps/ripgrep
"

src_compile() {
	:
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/@${PN}/${PN}
	doins -r locales
	insopts -m0755
	doins cli.js

	dodoc README.md

	dosym "../$(get_libdir)/node_modules/@${PN}/${PN}/cli.js" "${EPREFIX}/usr/bin/qwen"
}
