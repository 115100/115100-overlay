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

DESTDIR="/opt/${PN}"

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

	sed \
		-e "s,@CEF_ROOT@,${DESTDIR}," \
		"${FILESDIR}/FindCEF.cmake" > "${T}/FindCEF.cmake" || die
	default
}

src_install() {
	insinto ${DESTDIR}
	doins -r Resources
	doins -r include
	doins -r libcef_dll
	doins CMakeLists.txt
	insinto ${DESTDIR}/cmake
	doins cmake/cef_{macros,variables}.cmake

	exeinto ${DESTDIR}/Release
	for exc in chrome-sandbox libcef.so libEGL.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1; do
		doexe Release/${exc} || die
	done
	fperms 4755 "${DESTDIR}/Release/chrome-sandbox"

	insinto /usr/share/cmake/Modules
	doins "${T}/FindCEF.cmake"

	local revord=$(( 9999999 - $(printf "%03d%02d%02d" "$(ver_cut 1)" "$(ver_cut 2)" "$(ver_cut 3)")))
	newenvd - "99cef${revord}" <<-EOF
		LDPATH=${EPREFIX}${DESTDIR}/Release
	EOF

	dodoc README.txt
}
