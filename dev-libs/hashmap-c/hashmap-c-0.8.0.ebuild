# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Hash map implementation in C."
HOMEPAGE="https://github.com/tidwall/hashmap.c"

SRC_URI="
	https://github.com/tidwall/hashmap.c/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/hashmap.c-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_compile() {
	"$(tc-getCC)" \
		${LDFLAGS} \
		${CFLAGS} \
		${CPPFLAGS} \
		-Wl,-soname,libhashmap.so \
		-fPIC \
		-shared \
		hashmap.c -o libhashmap.so || die "libhashmap.so failed"
}

src_install() {
	dolib.so libhashmap.so
	doheader hashmap.h

	dodoc README.md
}
