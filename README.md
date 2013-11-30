Ineluctable Overlay
===================

[![Build Status](https://travis-ci.org/toffanin/ineluctable-overlay.png)](https://travis-ci.org/toffanin/ineluctable-overlay)

Ineluctable Overlay offers a repository of Gentoo ebuilds made by me (Mauro Toffanin, official Gentoo/FreeBSD Arch Tester) for projects that I am interested in and are not yet available through Portage tree.

Instructions for the installation of the overlay are provided here:
https://github.com/toffanin/ineluctable-overlay/wiki/Install

Feel free to fork and add more ebuilds.


## Installing This Overlay

#### Introduction

This section will show you how to install the _Ineluctable Overlay_ into your Gentoo system, hence the following instructions assume a certain level of expertise using _Portage_ and [_layman_]( http://layman.sourceforge.net).

Keep in mind that this overlay provides packages that aren't in the Portage tree. **If you do have troubles with an ebuild provided by this overlay, please take it up with the ebuild provider (the owner of this overlay) and not with the official Gentoo's developers. In short, in case of issues, please DO NOT report bugs at bugs.gentoo.org for these ebuilds.**


#### Adding the overlay

In order to manage the overlay, the package **app-portage/layman** must be installed into your environment:

```emerge -av app-portage/layman```

If the installation of _layman_ was successfully completed, then you are ready to add this overlay by fetching its remote list as showed below:

```wget -q -O /etc/layman/overlays/ineluctable-overlay.xml https://raw.github.com/toffanin/ineluctable-overlay/master/overlay.xml```

At this point you can execute:

```layman -a ineluctable-overlay```


#### Updating the overlay

Keep the overlay up to date with:

```layman -s ineluctable-overlay```


#### Removing the overlay

The process of removing this overlay from your Gentoo environment is quite straightforward:

```layman -d ineluctable-overlay```
```rm -r /etc/layman/overlays/ineluctable-overlay```


Overlay Package Tree
====================

```
	ineluctable-overlay
	├── app-admin
	│   └── fluentd
	├── app-arch
	│   └── archivemount
	├── app-doc
	│   └── dexy
	├── app-emulation
	│   ├── ganeti-webmgr
	│   └── hhvm
	│   └── lxc
	├── dev-db
	│   ├── arangodb
	│   └── vertexdb
	├── dev-embedded
	├── dev-lang
	│   ├── dmd
	│   ├── efene
	│   └── reia
	├── dev-libs
	│   ├── hhvm-libevent
	│   ├── icu
	│   ├── libdwarf
	│   └── oniguruma
	├── dev-php
	│   └── ZendFramework
	├── dev-python
	│   ├── django-fields
	│   ├── django-haystack
	│   ├── django-muddle-users
	│   ├── django-object-log
	│   ├── django-object-permissions
	│   ├── ganeti-webmgr-layout
	│   ├── idiopidae
	│   ├── muddle
	│   ├── ordereddict
	│   ├── plugnplay
	│   ├── python-modargs
	│   └── zapps
	├── dev-ruby
	│   ├── configliere
	│   ├── feedzirra
	│   ├── god
	│   ├── gorillib
	│   ├── jeweler
	│   ├── loofah
	│   ├── msgpack
	│   └── sax-machine
	├── dev-util
	│   ├── codeanalyst
	│   ├── codexl
	│   └── cxxtest
	├── media-gfx
	│   ├── opencsg
	│   └── openscad
	├── media-libs
	├── net-libs
	│   └── zeromq
	├── net-misc
	│   ├── dropbox
	│   └── vde
	├── olpc-glucose
	│   ├── sugar
	│   ├── sugar-artwork
	│   ├── sugar-base
	│   ├── sugar-datastore
	│   ├── sugar-presence-service
	│   └── sugar-toolkit
	├── sys-libs
	│   └── hoard
	├── www-apache
	│   ├── mod_atom
	│   └── mod_qos
	├── www-apps
	│   └── redmine
	├── www-servers
	│   ├── mongrel
	│   ├── thin
	│   └── wsgid
	├── x11-base
	│   └── xynth
	└── x11-wm
		└── scrotwm
```
