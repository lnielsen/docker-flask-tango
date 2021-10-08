import os

from setuptools import setup

setup(
    name='myapp',
    version='1.0.0',
    packages=[
        'myapp',
    ],
    zip_safe=False,
    include_package_data=True,
    platforms='any',
    install_requires=['flask'],
)
