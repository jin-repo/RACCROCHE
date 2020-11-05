#!/usr/bin/python
# -*- coding: utf-8 -*-:
"""Setup script"""
"""
import raccroche
try:
    from setuptools import setup
    from setuptools.command.test import test as TestCommand
except ImportError:
    from distutils.core import setup
    from distutils.core import Command as TestCommand


class PyTest(TestCommand):
    def initialize_options(self):
        pass

    def finalize_options(self):
        self.test_args = []
        self.test_suite = True

    def run_tests(self):
        import pytest
        import sys
        errno = pytest.main(self.test_args)
        sys.exit(errno)

"""

from setuptools import setup

def parse_requirements(requirements):
    """
    Returns the list of requirements found in the requirements file
    """
    with open(requirements, "r") as req_file:
        return [l.strip('\n') for l in req_file if l.strip('\n')
                and not l.startswith('#')]

packages = ['raccroche', 'raccroche.module2']
requires = parse_requirements("requirements.txt")
scripts = ['raccroche/module2_main']

classifiers = [
    "Environment :: Console",
    "Intended Audience :: Science/Research",
    "License :: OSI Approved :: BSD License",
    "Programming Language :: Python :: 3",
    "Operating System :: OS Independent",
    "Topic :: Scientific/Engineering :: Bio-Informatics",
]

with open('README.md') as f:
    long_description = f.read()

setup(
    name='module2',
    packages=packages,
    version='1.0.0',
    description='raccroche demo: Reconstruction of AnCestral COntigs and CHromosomEs',
    long_description=long_description,
    author='Qiaoji Xu',
    author_email='qxu062@uottawa.ca',
    license='BSD-2-Clause',
    platforms='OS Independent',
    package_data={'': ['LICENSE']},
    download_url='https://github.com/jin-repo/RACCROCHE.git',
    url='https://github.com/jin-repo/RACCROCHE.git',
    scripts=scripts,
    include_package_data=True,
    install_requires=requires,
    #tests_require=['pytest'],
    #cmdclass={'tests': PyTest},
    classifiers=classifiers,
    python_requires='>=3'
)
