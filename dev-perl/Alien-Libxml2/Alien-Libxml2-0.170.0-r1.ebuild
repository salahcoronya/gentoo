# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PLICEASE
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Install the C libxml2 library on your system"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-perl/Alien-Build-2.120.0
	dev-libs/libxml2:2=
"
DEPEND="
	dev-libs/libxml2:2=
"
BDEPEND="${RDEPEND}
	>=dev-perl/Alien-Build-2.370.0
	virtual/perl-ExtUtils-CBuilder
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	test? (
		>=virtual/perl-Test2-Suite-0.0.60
	)
"
