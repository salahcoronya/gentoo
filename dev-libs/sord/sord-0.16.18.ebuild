# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/drobilla/sord.git"
else
	SRC_URI="https://download.drobilla.net/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
fi

DESCRIPTION="Library for storing RDF data in memory"
HOMEPAGE="https://drobilla.net/software/sord.html"

LICENSE="ISC"
SLOT="0"
IUSE="doc test tools"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		dev-python/sphinx
		dev-python/sphinx-lv2-theme
		dev-python/sphinxygen
	)
"
# Take care on bumps to check minimum versions!
RDEPEND="
	>=dev-libs/serd-0.30.10[${MULTILIB_USEDEP}]
	>=dev-libs/zix-0.4.0[${MULTILIB_USEDEP}]
	tools? ( dev-libs/libpcre2[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# fix doc installation path
	sed -i "s/versioned_name/'${PF}'/g" doc/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature doc docs)
		$(meson_feature test tests)
		$(meson_feature tools)
	)

	meson_src_configure
}

multilib_src_install_all() {
	local DOCS=( AUTHORS NEWS README.md )
	einstalldocs
}
