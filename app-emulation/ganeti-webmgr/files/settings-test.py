# Copyright (C) 2010 Oregon State University et al.
# Copyright (C) 2010 Greek Research and Technology Network
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
# USA.

# Django settings for ganeti_webmgr project.

import os.path

DEBUG = True
TEMPLATE_DEBUG = DEBUG

# XXX - Django sets DEBUG to False when running unittests.  They want to ensure
# that you test as if it were a production environment.  Unfortunately we have
# some models and other settings used only for testing.  We use the TESTING flag
# to enable or disable these items.
#
# If you run the unittests without this set to TRUE, you will get many errors!
TESTING = True
# Setting this to False disables south migrations when running tests.
SOUTH_TESTS_MIGRATE = False
SKIP_SOUTH_TESTS = True

ADMINS = (
    # ('Your Name', 'your_email@example.com'),
)

MANAGERS = ADMINS

DATABASES = {
    'default': {
        'ENGINE': 'sqlite3', # Add 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'ganeti.db',                      # Or path to database file if using sqlite3.
        'USER': '',                      # Not used with sqlite3.
        'PASSWORD': '',                  # Not used with sqlite3.
        'HOST': '',                      # Set to empty string for localhost. Not used with sqlite3.
        'PORT': '',                      # Set to empty string for default. Not used with sqlite3.
    }
}

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = 'America/Los_Angeles'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html

# In order to support localization the following have to be added:

ugettext = lambda s: s

# If no other locale is present/supported for the time leave the following as is.
# When locales are added, place them ath the "('yourlang', ugettext('YOUR LANGUAGE')),"
# line. E.g, for the Greek locale, it becomes: ('el', ugettext('Greek'))

LANGUAGES = (
#	 ('yourlang', ugettext('YOUR LANGUAGE')),
    ('el', ugettext('Greek')),
    ('en', ugettext('English')),
)
# end-of localization support

LANGUAGE_CODE = 'en-US'

# Unique site id used by many modules to distinguish site from others.
SITE_ID = 1

# Site name and domain referenced by some modules to provide links back to
#  the site.
SITE_NAME = 'Ganeti Web Manager'
SITE_DOMAIN = 'localhost:8000'

# Enable i18n (translations) and l10n (locales, currency, times).
# You really have no good reason to disable these unless you are only
# going to be using GWM in English.
USE_I18N = True

# If you set this to False, Django will not format dates, numbers and
# calendars according to the current locale
USE_L10N = True

# absolute path to the docroot of this site
DOC_ROOT = os.path.dirname(os.path.realpath(__file__))

# prefix used for the site.  ie. http://myhost.com/<SITE_ROOT>
# for the django standalone server this should be ''
# for apache this is the url the site is mapped to, probably /tracker
SITE_ROOT = ''

# Absolute path to the directory that holds media.
# Example: "/home/media/media.lawrence.com/"
MEDIA_ROOT = '%s/media' % DOC_ROOT

# URL that handles the media served from MEDIA_ROOT.
# XXX contrary to django docs, do not use a trailling slash.  It makes urls
# using this url easier to read.  ie.  {{MEDIA_URL}}/images/foo.png
MEDIA_URL = '%s/media' % SITE_ROOT

# URL prefix for admin media -- CSS, JavaScript and images. Make sure to use a
# trailing slash.
# Examples: "http://foo.com/media/", "/media/".
ADMIN_MEDIA_PREFIX = '/adminmedia/'

# Make this unique, and don't share it with anybody.
SECRET_KEY = '!c&bm88vo=gby*vxf2gydv8hc!+f+eo+yu&!g&!)#n5quwsr82'

AUTHENTICATION_BACKENDS = (
    'django.contrib.auth.backends.ModelBackend',
    'object_permissions.backend.ObjectPermBackend',
)

# List of callables that know how to import templates from various sources.
TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.Loader',
    'django.template.loaders.app_directories.Loader',
#     'django.template.loaders.eggs.Loader',
)

TEMPLATE_CONTEXT_PROCESSORS = (
    'django.contrib.auth.context_processors.auth',
    'django.contrib.messages.context_processors.messages',
    'django.core.context_processors.debug',
    'django.core.context_processors.i18n',
    'django.core.context_processors.media',
    'ganeti_web.context_processors.site',
    'ganeti_web.context_processors.common_permissions'
)

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.locale.LocaleMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.csrf.CsrfResponseMiddleware'
)

ROOT_URLCONF = 'urls'

TEMPLATE_DIRS = (
    # Put strings here, like "/home/html/django_templates" or "C:/www/django/templates".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
    'templates/'
)

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.messages',
    'django.contrib.sessions',
    'django.contrib.sites',
    'registration',
    'deprecated.ganeti', # XXX deprecated ganeti MUST come before ganeti_web
    'ganeti_web_layout',
    'ganeti_web',        # XXX must come before object permissions for migration to 0.7
    'object_permissions', 
    'object_log',
    'south',
    'haystack',
    'muddle',
#    'muddle.shots',
    'muddle_users',
)

# Search settings
HAYSTACK_SITECONF = 'search_sites'
HAYSTACK_SEARCH_ENGINE = 'whoosh'
HAYSTACK_WHOOSH_PATH = os.path.join(DOC_ROOT, 'whoosh_index')

AUTH_PROFILE_MODULE = 'ganeti_web.Profile'
LOGIN_REDIRECT_URL = '/'

DATE_FORMAT = "d/m/Y"
DATETIME_FORMAT = "d/m/Y H:i"

ACCOUNT_ACTIVATION_DAYS = 7

# Email settings for registration
EMAIL_HOST = "localhost"
EMAIL_PORT = "25"
# DEFAULT_FROM_EMAIL = "noreply@example.org"

# Whether users should be able to create their own accounts. 
# False if accounts can only be created by admins. 
ALLOW_OPEN_REGISTRATION = True

# A sample logging configuration. The only tangible logging
# performed by this configuration is to send an email to
# the site admins on every HTTP 500 error.
# See http://docs.djangoproject.com/en/dev/topics/logging for
# more details on how to customize your logging configuration.
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'mail_admins': {
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler'
        }
    },
    'loggers': {
        'django.request': {
            'handlers': ['mail_admins'],
            'level': 'ERROR',
            'propagate': True,
        },
    }
}

# default items per page
ITEMS_PER_PAGE = 10

# Ganeti Cached Cluster Objects Timeouts
#    LAZY_CACHE_REFRESH (milliseconds) is the fallback cache timer that is
#    checked when the object is instantiated.
#
#    PERIODIC_CACHE_REFRESH - timer used by an outside process twisted process
#    that uses bulk methods for keeping the cache in sync with ganeti.  If used
#    this value should *always* be less than LAZY_CACHE_REFRESH.  Note that this
#    process still takes time to update object.  If it does not complete fast
#    enough LAZY_CACHE_REFRESH will still be checked
#
#    Start this process this this command:
#       twistd gwm_cache
#
LAZY_CACHE_REFRESH = 600000
PERIODIC_CACHE_REFRESH = 300

# VNC Proxy. This will use a proxy to create local ports that are forwarded to
# the virtual machines.  It allows you to control access to the VNC servers.
#
# Expected values:
#   String syntax: "HOST:CONTROL_PORT", for example: "localhost:8888". If
#   localhost is used then the proxy will only be accessible to clients and
#   browsers on localhost. Production servers should use a publicly accessible
#   hostname or IP
#
# Firewall Rules:
#   Control Port: 8888, must be open between Ganeti Web Manager and Proxy
#   Internal Ports: 12000+ must be open between the Proxy and Ganeti Nodes
#   External Ports: default is 7000-8000, must be open between Proxy and Clients
#   Flash Policy Server: 843, must open between Proxy and Clients

VNC_PROXY='localhost:8888'


# API Key for authenticating scripts that pull information from ganeti, such as
# list of sshkey's to assign to a virtual machine
#
# XXX this is a temporary feature that will eventually be replaced by a system
#     that automatically creates keys per virtual machine.  This is just a quick
#     way of enabled a secure method to pull sshkeys from ganeti web manager
WEB_MGR_API_KEY = "CHANGE_ME"
