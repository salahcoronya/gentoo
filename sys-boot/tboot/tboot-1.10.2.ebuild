# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic mount-boot toolchain-funcs

DESCRIPTION="Performs a measured and verified boot using Intel Trusted Execution Technology"
HOMEPAGE="https://sourceforge.net/projects/tboot/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="custom-cflags selinux"

# requires patching the kernel src
RESTRICT="test"

DEPEND="dev-libs/openssl:0=[-bindist]"

RDEPEND="${DEPEND}
	sys-boot/grub:2
	selinux? ( sec-policy/selinux-tboot )"

DOCS=( README.md COPYING CHANGELOG )
PATCHES=( "${FILESDIR}/${PN}-1.9.11-genkernel-path.patch" )

src_prepare() {
	sed -i 's/ -Werror//g' Config.mk || die
	sed -i 's/^INSTALL_STRIP ?= -s$//' Config.mk || die # QA Errors

	sed -i "s/\(AS[[:space:]]\{1,\}?= \)as/\1$(tc-getAS)/" Config.mk || die
	sed -i "s/\(LD[[:space:]]\{1,\}?= \)ld/\1$(tc-getLD)/" Config.mk || die
	sed -i "s/\(CC[[:space:]]\{1,\}?= \)gcc/\1$(tc-getCC)/" Config.mk || die
	sed -i "s/\(CPP[[:space:]]\{1,\}?= \)cpp/\1$(tc-getCPP)/" Config.mk || die
	sed -i "s/\(AR[[:space:]]\{1,\}?= \)ar/\1$(tc-getAR)/" Config.mk || die
	sed -i "s/\(RANLIB[[:space:]]\{1,\}?= \)ranlib/\1$(tc-getRANLIB)/" Config.mk || die
	sed -i "s/\(NM[[:space:]]\{1,\}?= \)nm/\1$(tc-getNM)/" Config.mk || die
	sed -i "s/\(STRIP[[:space:]]\{1,\}?= \)strip/\1$(tc-getSTRIP)/" Config.mk || die
	sed -i "s/\(OBJCOPY[[:space:]]\{1,\}?= \)objcopy/\1$(tc-getOBJCOPY)/" Config.mk || die
	sed -i "s/\(OBJDUMP[[:space:]]\{1,\}?= \)objdump/\1$(tc-getOBJDUMP)/" Config.mk || die

	sed -i "s/\(CC[[:space:]]\{1,\}?= \)gcc/\1$(tc-getCC)/" safestringlib/makefile || die

	default
}

src_compile() {
	use custom-cflags && export TBOOT_CFLAGS=${CFLAGS} || unset CCASFLAGS CFLAGS CPPFLAGS LDFLAGS

	if use amd64; then
		export MAKEARGS="TARGET_ARCH=x86_64"
	else
		export MAKEARGS="TARGET_ARCH=i686"
	fi

	default
}

src_install() {
	emake DISTDIR="${D}" install

	dodoc "${DOCS[@]}"
	dodoc docs/*.{txt,md}

	cd "${D}"
	mkdir -p usr/lib/tboot/ || die
	mv boot usr/lib/tboot/ || die
}

pkg_postinst() {
	cp "${ROOT}/usr/lib/tboot/boot/"* "${ROOT}/boot/" || die

	ewarn "Please remember to download the SINIT AC Module relevant"
	ewarn "for your platform from:"
	ewarn "http://software.intel.com/en-us/articles/intel-trusted-execution-technology/"
}
