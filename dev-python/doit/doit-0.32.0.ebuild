# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit eutils distutils-r1

DESCRIPTION="Automation tool"
HOMEPAGE="http://python-doit.sourceforge.net/ https://pypi.org/project/doit/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
DEPEND="test? ( ${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}] )
"
PDEPEND=">=dev-python/doit-py-0.3.0[${PYTHON_USEDEP}]"

# Required for test phase
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Disable test failing due to impact on PATH run in a sandbox
	sed -e s':test_target:_&:' -i tests/test_cmd_strace.py || die

	# Test requires connection to an absent database
	sed -e s':testIgnoreAll:_&:' -i tests/test_cmd_ignore.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	local -x TMPDIR="${T}"
	# disable tests where pypy's treatment of some tests' use of a db is incompatible

	if [[ "${EPYTHON}" == pypy ]]; then
		sed -e 's:test_remove_all:_&:' -i tests/test_dependency.py || die
		sed -e 's:testForgetAll:_&:' -i tests/test_cmd_forget.py || die
		sed -e 's:test_not_picklable:_&:' \
			-e 's:test_task_not_picklabe_multiprocess:_&:' \
			-i tests/test_runner.py || die
	fi

	py.test || die "Tests failed under ${EPYTHON}"
}

src_install() {
	use doc && HTML_DOCS=( doc/_build/html/. )

	distutils-r1_src_install
}
