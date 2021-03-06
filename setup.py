try:
    from setuptools import setup, find_packages
except ImportError:
    from ez_setup import use_setuptools
    use_setuptools()
    from setuptools import setup, find_packages

setup(
    name='debexpo',
    version="",
    #description='',
    #author='',
    #author_email='',
    #url='',
    scripts=['bin/debexpo-importer'],
    install_requires=[
        "Pylons>=0.9.6.1",
        "SQLAlchemy>=0.4.6",
        "Webhelpers>=0.6.1",
        "Babel"],
    packages=find_packages(exclude=['ez_setup']),
    include_package_data=True,
    test_suite='nose.collector',
    package_data={'debexpo': ['i18n/*/LC_MESSAGES/*.mo']},
    message_extractors = {'debexpo': [
            ('**.py', 'python', None),
            ('templates/**.mako', 'mako', None),
            ('public/**', 'ignore', None)]},
    entry_points="""
    [paste.app_factory]
    main = debexpo.config.middleware:make_app

    [paste.app_install]
    main = pylons.util:PylonsInstaller
    """,
)
