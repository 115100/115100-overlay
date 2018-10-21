EAPI=7

DESCRIPTION="Policy-driven snapshot management and replication tools for ZFS."
HOMEPAGE="https://github.com/jimsalterjrs/sanoid"
SRC_URI="https://github.com/jimsalterjrs/sanoid/archive/v${PV}.zip"

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
DEPEND=""
RDEPEND="
	dev-lang/perl
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

src_install() {
	dobin sanoid
	dobin syncoid

	insinto /etc/sanoid
	doins "sanoid.defaults.conf"

	elog "You will need to set up your /etc/sanoid/sanoid.conf file before"
	elog "running sanoid for the first time. For details, please consult the"
	elog "documentation on https://github.com/jimsalterjrs/sanoid."
}
