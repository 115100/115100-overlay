# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
inherit cmake lua-single

DESCRIPTION="An alternative launcher for your favourite MMO."
HOMEPAGE="https://codeberg.org/Adamcake/Bolt"

SRC_URI="https://codeberg.org/Adamcake/Bolt/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/bolt"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="plugins"

REQUIRED_USE="
	plugins? ( ${LUA_REQUIRED_USE} )
"

QA_PRESTRIPPED="
	opt/${PN}/libEGL.so
	opt/${PN}/chrome-sandbox
	opt/${PN}/libcef.so
	opt/${PN}/libvulkan.so.1
	opt/${PN}/libvk_swiftshader.so
	opt/${PN}/libGLESv2.so
"

COMMON_DEPEND="
	app-arch/libarchive
	dev-libs/libfmt
	dev-libs/miniz
	media-libs/libspng
	x11-libs/libX11
	x11-libs/libxcb
	plugins? (
		dev-libs/hashmap-c
		dev-libs/openssl
		${LUA_DEPS}
	)
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	net-libs/cef:=
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/cmake-use-system-hashmap.patch"
	"${FILESDIR}/cmake-use-system-libfmt.patch"
	"${FILESDIR}/cmake-use-system-libspng.patch"
	"${FILESDIR}/cmake-use-system-miniz.patch"
	"${FILESDIR}/cmake-use-system-openssl.patch"
)

src_configure() {
	local CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=no
		-DCMAKE_INSTALL_PREFIX=/
		-DBOLT_BINDIR=usr/bin
		-DBOLT_LIBDIR=usr/lib64
		-DBOLT_SHAREDIR=usr/share
		-DBOLT_SKIP_LIBRARIES=$(usex plugins no yes)
	)
	cmake_src_configure
}
