# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${PN}${PV}"

DESCRIPTION="Tcl Thread extension"
HOMEPAGE="http://www.tcl.tk/"
SRC_URI="https://downloads.sourceforge.net/project/tcl/Thread%20Extension/${PV}/${MY_P}.tar.gz"

S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

DEPEND="dev-lang/tcl:0=[threads]"
RDEPEND="${DEPEND}"

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 # used to test for Large File Support
)

PATCHES=( "${FILESDIR}"/${P}-musl.patch )

src_prepare() {
	default

	# Search for libs in libdir not just exec_prefix/lib
	sed -i -e 's:${exec_prefix}/lib:${libdir}:' \
		aclocal.m4 || die "sed failed"

	sed -i -e "s/relid'/relid/" tclconfig/tcl.m4 || die

	eautoreconf
}

src_configure() {
	econf --with-tclinclude="${EPREFIX}/usr/include" \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
}
