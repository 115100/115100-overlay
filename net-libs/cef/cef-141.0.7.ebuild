# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2

DESCRIPTION="A simple framework for embedding Chromium-based browsers in other applications."
HOMEPAGE="https://bitbucket.org/chromiumembedded/cef"

# Grab from https://cef-builds.spotifycdn.com/index.html#linux64
CEF_VERSION="141.0.7+ga5714cc+chromium-141.0.7390.108"
SRC_URI="https://cef-builds.spotifycdn.com/cef_binary_${CEF_VERSION}_linux64_minimal.tar.bz2 -> ${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# Copied almost wholesale from www-client/chromium
RDEPEND="
	>=dev-libs/libxml2-2.12.4:=[icu]
	dev-libs/nspr:=
	>=dev-libs/nss-3.26:=
	dev-libs/libxslt:=
	media-libs/fontconfig:=
	>=media-libs/freetype-2.11.0-r1:=
	>=media-libs/harfbuzz-3:0=[icu(-)]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=[-apng(-)]
	>=media-libs/libwebp-0.4.0:=
	media-libs/mesa:=[gbm(+)]
	>=media-libs/openh264-1.6.0:=
	dev-libs/glib:2
	>=media-libs/alsa-lib-1.0.19:=
	sys-apps/pciutils:=
	x11-base/xorg-proto:=
	x11-libs/libX11:=
	x11-libs/libxcb:=
	x11-libs/libXext:=
	x11-libs/libxkbcommon:=
	dev-libs/libffi:=
	dev-libs/wayland:=
	media-video/pipewire:=
	app-arch/bzip2:=
	dev-libs/expat:=
	net-misc/curl[ssl]
	sys-apps/dbus:=
	media-libs/flac:=
	sys-libs/zlib:=[minizip]
	>=app-accessibility/at-spi2-core-2.46.0:2
	media-libs/mesa:=
	virtual/udev
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/pango:=
	>=net-print/cups-1.3.11:=
	dev-qt/qtbase:6[gui,widgets]
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXtst:=
	x11-libs/libxshmfence:=
	|| (
		x11-libs/gtk+:3
		gui-libs/gtk:4
	)
	dev-qt/qtbase:6
	virtual/ttf-fonts
"

CEF_INCLUDE_DIR=/usr/include/cef
CEF_LIB_DIR=/usr/lib64/cef
CEF_SRC_DIR=/usr/src/${P}

src_configure() {
	default
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	default_src_unpack
	mv "${WORKDIR}/cef_binary_${CEF_VERSION}_linux64_minimal" "${S}" || die
}

src_prepare() {
	# cleanup languages
	pushd "Resources/locales/" >/dev/null || die "location change for language cleanup failed"
	chromium_remove_language_paks
	popd >/dev/null || die "location reset for language cleanup failed"

	# Copied logic from https://src.fedoraproject.org/rpms/cef/blob/4b5a9c1/f/cef.spec#_1532-1538
	sed -i -e '/\.\.\/include/d' "${S}/libcef_dll/CMakeLists.txt" || die
	sed \
		-e "s,__CEF_INCLUDE__,${CEF_INCLUDE_DIR}," \
		-e "s,__CEF_LIB__,${CEF_LIB_DIR}," \
		-e "s,__CEF_SRC__,${CEF_SRC_DIR}," \
		"${FILESDIR}/FindCEF.cmake" > "${T}/FindCEF.cmake" || die
	default
}

src_install() {
	insinto ${CEF_SRC_DIR}
	doins -r libcef_dll

	insinto ${CEF_LIB_DIR}
	doins -r Resources/locales
	doins Resources/*.dat
	doins Resources/*.pak

	exeinto ${CEF_LIB_DIR}
	# No dolib.so here because it nests a lib64 dir
	doexe Release/*.so
	doexe Release/*.so.1
	doexe Release/chrome-sandbox
	insinto ${CEF_LIB_DIR}
	doins Release/*.bin
	doins Release/vk_swiftshader_icd.json

	insinto ${CEF_INCLUDE_DIR}
	doins -r include

	insinto /usr/share/cmake/Modules
	doins "${T}/FindCEF.cmake"

	dodoc README.txt
}
