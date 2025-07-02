# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
inherit cmake lua-single

DESCRIPTION="An alternative launcher for your favourite MMO."
HOMEPAGE="https://github.com/Adamcake/Bolt"

# CEF distributions are used because Gentoo does not package them. I'm not compiling these from source either.
CEF_VERSION="138.0.15+gd0f1f64+chromium-138.0.7204.50" # Grab from https://cef-builds.spotifycdn.com/index.html#linux64
TIDWALL_HASHMAP_C_VERSION="0.8.0"
SRC_URI="
	https://github.com/Adamcake/Bolt/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://cef-builds.spotifycdn.com/cef_binary_${CEF_VERSION}_linux64_minimal.tar.bz2
	https://github.com/tidwall/hashmap.c/archive/refs/tags/v${TIDWALL_HASHMAP_C_VERSION}.tar.gz
	-> hashmap.c-v${TIDWALL_HASHMAP_C_VERSION}.tar.gz
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
"

RDEPEND="
	app-arch/libarchive
	dev-lang/luajit
	dev-libs/libfmt
	media-libs/libspng
	x11-libs/libX11
	x11-libs/libxcb
	${LUA_DEPS}
"

PATCHES=(
	"${FILESDIR}/0001-src-browser-add-popup_id-parameter-to-OnBeforePopup.patch"
	"${FILESDIR}/0002-cmake-use-system-libfmt.patch"
	"${FILESDIR}/0003-cmake-use-system-libspng.patch"
)

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi
	mv "${WORKDIR}/Bolt-${PV}" "${P}" || die
	mv "${WORKDIR}/cef_binary_${CEF_VERSION}_linux64_minimal" "${WORKDIR}/${P}/cef/dist" || die
	mv "${WORKDIR}/hashmap.c-${TIDWALL_HASHMAP_C_VERSION}/hashmap."{c,h} "${WORKDIR}/${P}/modules/hashmap" || die
}

src_configure() {
	local CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DBOLT_CEF_INCLUDEPATH="${WORKDIR}/${P}/cef/dist"
		-DBOLT_LUAJIT_INCLUDE_DIR="$(lua_get_include_dir)"
		-DCMAKE_INSTALL_PREFIX=/
		-DBOLT_BINDIR=usr/bin
		-DBOLT_LIBDIR=usr/lib64
		-DBOLT_SHAREDIR=usr/share
		-DBUILD_SHARED_LIBS=no
	)
	cmake_src_configure
}
