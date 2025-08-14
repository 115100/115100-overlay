# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
inherit cmake lua-single

DESCRIPTION="An alternative launcher for your favourite MMO."
HOMEPAGE="https://github.com/Adamcake/Bolt"

# CEF distributions are used because Gentoo does not package them. I'm not compiling these from source either.
CEF_VERSION="139.0.17+g6c347eb+chromium-139.0.7258.31" # Grab from https://cef-builds.spotifycdn.com/index.html#linux64
SRC_URI="
	https://github.com/Adamcake/Bolt/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://cef-builds.spotifycdn.com/cef_binary_${CEF_VERSION}_linux64_minimal.tar.bz2
"
S="${WORKDIR}/Bolt-${PV}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
"

RDEPEND="
	app-arch/libarchive
	dev-lang/luajit
	dev-libs/hashmap-c
	dev-libs/libfmt
	media-libs/libspng
	x11-libs/libX11
	x11-libs/libxcb
	${LUA_DEPS}
"

PATCHES=(
	"${FILESDIR}/0001-browser-add-popup_id-parameter-to-OnBeforePopup.patch"
	"${FILESDIR}/0002-cmake-use-system-libfmt.patch"
	"${FILESDIR}/0003-cmake-use-system-libspng.patch"
	"${FILESDIR}/0004-cmake-use-system-hashmap.patch"
)

src_unpack() {
	default_src_unpack
	mv "${WORKDIR}/cef_binary_${CEF_VERSION}_linux64_minimal" "${S}/cef/dist" || die
}

src_configure() {
	local CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DBOLT_CEF_INCLUDEPATH="${S}/cef/dist"
		-DBOLT_LUAJIT_INCLUDE_DIR="$(lua_get_include_dir)"
		-DCMAKE_INSTALL_PREFIX=/
		-DBOLT_BINDIR=usr/bin
		-DBOLT_LIBDIR=usr/lib64
		-DBOLT_SHAREDIR=usr/share
		-DBUILD_SHARED_LIBS=no
	)
	cmake_src_configure
}
