# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
inherit cmake lua-single

DESCRIPTION="An alternative launcher for your favourite MMO."
HOMEPAGE="https://github.com/Adamcake/Bolt"

SRC_URI="https://github.com/Adamcake/Bolt/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Bolt-${PV}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="plugins"

REQUIRED_USE="
	plugins? ( ${LUA_REQUIRED_USE} )
"

RDEPEND="
	app-arch/libarchive
	dev-lang/luajit
	dev-libs/libfmt
	dev-libs/miniz
	media-libs/libspng
	net-libs/cef
	x11-libs/libX11
	x11-libs/libxcb
	plugins? (
		dev-libs/hashmap-c
		dev-libs/openssl
		${LUA_DEPS}
	)
"

PATCHES=(
	"${FILESDIR}/0001-browser-add-popup_id-parameter-to-OnBeforePopup.patch"
	"${FILESDIR}/0002-cmake-use-system-libfmt.patch"
	"${FILESDIR}/0003-cmake-use-system-libspng.patch"
	"${FILESDIR}/0004-cmake-use-system-hashmap.patch"
	"${FILESDIR}/0005-cmake-use-system-miniz.patch"
	"${FILESDIR}/0006-cmake-use-system-openssl.patch"
)

src_configure() {
	local CEF_LIB_DIR=/usr/lib64/cef

	local CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/
		-DBOLT_BINDIR=usr/bin
		-DBOLT_LIBDIR=usr/lib64
		-DBOLT_SHAREDIR=usr/share
		-DBUILD_SHARED_LIBS=no
		-DBOLT_CEF_RESOURCEDIR_OVERRIDE=${CEF_LIB_DIR}
		-DBOLT_LIBCEF_DIRECTORY=${CEF_LIB_DIR}
		-DBOLT_SKIP_LIBRARIES=$(usex plugins no yes)
	)
	cmake_src_configure
}
