# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Policy-driven snapshot management and replication tools for ZFS."
HOMEPAGE="https://github.com/jimsalterjrs/sanoid"
SRC_URI="https://github.com/jimsalterjrs/sanoid/archive/v${PV}.zip -> ${P}.zip"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"

IUSE="
	lzop

	-gzip
	-mbuffer
	-pigz
	-pv
	-zstd
"
DEPEND="
	dev-lang/perl
"
RDEPEND="
	dev-lang/perl
	dev-perl/Capture-Tiny
	dev-perl/Config-IniFiles
	sys-fs/zfs
	virtual/ssh

	gzip?    ( app-arch/gzip )
	lzop?    ( app-arch/lzop )
	mbuffer? ( sys-block/mbuffer )
	pigz?    ( app-arch/pigz )
	pv?      ( sys-apps/pv )
	zstd?    ( app-arch/zstd )
"

src_compile() {
	perldoc -oman -dsanoid.1 sanoid || die "Failed to compile sanoid.1!"
	perldoc -oman -dsyncoid.1 syncoid || die "Failed to compile syncoid.1!"
}

src_install() {
	dobin sanoid
	dobin syncoid

	doman sanoid.1 syncoid.1

	insinto /etc/sanoid
	doins "sanoid.defaults.conf"

	elog "You will need to set up your /etc/sanoid/sanoid.conf file before"
	elog "running sanoid for the first time. For details, please consult the"
	elog "documentation on https://github.com/jimsalterjrs/sanoid."
}
