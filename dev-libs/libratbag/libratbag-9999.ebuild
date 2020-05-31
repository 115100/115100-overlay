# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{4,5,6} )
inherit python-single-r1 meson git-r3 udev

DESCRIPTION="Library to configure gaming mice"
HOMEPAGE="https://github.com/libratbag/libratbag"
EGIT_REPO_URI="https://github.com/libratbag/libratbag.git"

LICENSE="MIT"
SLOT="0"
IUSE="doc systemd test"

DEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/valgrind )
	!systemd? ( sys-auth/elogind )
"
RDEPEND="
	dev-libs/libevdev
	virtual/libudev
"

src_prepare() {
	default
	python_setup 'python3*'
}

src_configure() {
	local emesonargs=(
		-Ddocumentation=$(usex doc true false)
		-Dtests=$(usex test true false)
		-Dudev-dir=$(get_udevdir)
		-Dlogind-provider=$(usex systemd systemd elogind)
		-Dsystemd=$(usex systemd true false)
	)
	meson_src_configure
}
