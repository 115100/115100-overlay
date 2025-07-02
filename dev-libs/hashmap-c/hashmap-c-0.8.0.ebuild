# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Hash map implementation in C."
HOMEPAGE="https://github.com/tidwall/hashmap.c"

SRC_URI="
	https://github.com/tidwall/hashmap.c/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi
	mv "${WORKDIR}/hashmap.c-${PV}" "${P}" || die
}

src_compile() {
	$(tc-getCC) ${CFLAGS} \
		${LDFLAGS} -shared hashmap.c \
		-o hashmap.so
}

src_install() {
	dolib.so hashmap.so
	insinto /usr/include
	doins hashmap.h
	dodoc README.md
}
