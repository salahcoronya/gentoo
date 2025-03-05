# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi toolchain-funcs

DESCRIPTION="C parser and AST generator written in Python"
HOMEPAGE="
	https://github.com/eliben/pycparser/
	https://pypi.org/project/pycparser/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-python/ply:=[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-2.22-pycparser-Respect-CPP-environmental-variable-in-prep.patch"
	"${FILESDIR}/${PN}-2.22-tests-test_util.py-Respect-CPP-environmental-variabl.patch"
)

distutils_enable_tests unittest

python_prepare_all() {
	# remove the original files to guarantee their regen
	rm pycparser/{c_ast,lextab,yacctab}.py || die

	# kill sys.path manipulations to force the tests to use built files
	sed -i -e '/sys\.path/d' tests/*.py || die

	# unbundle ply
	rm -r pycparser/ply || die
	sed -i -e 's:\(from \)[.]\(ply\b\):\1\2:' pycparser/*.py || die
	sed -i -e "s:'pycparser.ply'::" setup.py || die

	ln -s "${S}"/examples tests/examples || die

	rm tests/test_examples.py || die

	distutils-r1_python_prepare_all
}

src_test() {
	local -x CPP="$(tc-getCPP)"

	rm -fr pycparser || die
	distutils-r1_src_test
}
