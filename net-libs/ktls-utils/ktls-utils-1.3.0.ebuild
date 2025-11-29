# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd

DESCRIPTION="TLS handshake utilities for in-kernel TLS consumers"
HOMEPAGE="https://github.com/oracle/ktls-utils"
SRC_URI="https://github.com/oracle/ktls-utils/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="systemd"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libnl:3
	net-libs/gnutls
	sys-apps/keyutils
"

DEPEND="${RDEPEND}"

pkg_setup() {
	CONFIG_CHECK="TLS KEYS KEYS_REQUEST_CACHE"
	check_extra_config
}

src_configure() {
	econf --with-systemd=$(usex systemd "$(systemd_get_systemunitdir)")
}
