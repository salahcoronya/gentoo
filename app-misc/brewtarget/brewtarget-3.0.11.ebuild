# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="ast ca cs da de el en en_GB es et eu fr gl hr hu it ja lv nb nl pl pt pt_BR pt_PT ru sr sv tr zh"
inherit cmake plocale xdg-utils virtualx

DESCRIPTION="Application to create and manage beer recipes"
HOMEPAGE="http://www.brewtarget.org/"
SRC_URI="https://github.com/Brewtarget/brewtarget/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-qt/linguist-tools:5
"
DEPEND="
	>=dev-libs/boost-1.83[stacktrace]
	dev-libs/xalan-c
	dev-libs/xerces-c
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.11-fix-docdir.patch"
	"${FILESDIR}/${PN}-3.0.11-fix-boost-requirements.patch"
	)

remove_locale() {
	sed -i -e "/bt_${1}\.ts/d" CMakeLists.txt || die
}

src_prepare() {
	cmake_src_prepare

	plocale_find_changes translations bt_ .ts
	plocale_for_each_disabled_locale remove_locale

	# Tests are bogus, don't build them
	sed -i -e '/Qt5Test/d' CMakeLists.txt || die
	sed -i -e '/=Tests=/,/=Installs=/d' src/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DDO_RELEASE_BUILD=ON
		-DNO_MESSING_WITH_FLAGS=ON
	)
	cmake_src_configure
}

my_test() {
	cmake_src_test
	return $?
}

src_test() {
	virtx my_test
}

pkg_postinst()
{
	xdg_icon_cache_update
}

pkg_postrm()
{
	xdg_icon_cache_update
}
