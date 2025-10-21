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

# Copied from net-im/discord
RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
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

	exeinto ${CEF_LIB_DIR}
	doexe Release/*.so Release/*.so.*  Release/chrome-sandbox
	fowners root "${CEF_LIB_DIR}/chrome-sandbox"
	fperms 4711 "${CEF_LIB_DIR}/chrome-sandbox"

	insinto ${CEF_LIB_DIR}
	doins Release/*.bin Release/vk_swiftshader_icd.json
	doins -r Resources/locales
	doins Resources/*.dat
	doins Resources/*.pak

	insinto ${CEF_INCLUDE_DIR}
	doins -r include

	insinto /usr/share/cmake/Modules
	doins "${T}/FindCEF.cmake"

	dodoc README.txt
}
