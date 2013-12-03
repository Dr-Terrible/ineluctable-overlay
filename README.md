## Ineluctable Overlay

[![Build Status](https://travis-ci.org/toffanin/ineluctable-overlay.png)](https://travis-ci.org/toffanin/ineluctable-overlay)

Ineluctable Overlay offers a repository of Gentoo ebuilds made by me (Mauro Toffanin, official Gentoo/FreeBSD Arch Tester) for projects that I am interested in and are not yet available through Portage tree.

## Managing This Overlay

This section will show you how to install the _Ineluctable Overlay_ into your Gentoo system, hence the following instructions assume a certain level of expertise using [_Portage_](http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=2&chap=1) and [_layman_]( http://layman.sourceforge.net).

### Disclaimer

Keep in mind that this overlay provides packages that aren't in the Portage tree.

> **If you do have troubles with an ebuild provided by this overlay, please take it up with the ebuild provider (the owner of this GitHub account) and not with the official Gentoo's developers. In short, in case of issues, please DO NOT report bugs at bugs.gentoo.org for these ebuilds.**


### Installing the overlay

In order to manage the overlay, the package **app-portage/layman** must be installed into your environment:

```
emerge -av app-portage/layman
```

If the installation of _layman_ was successfully completed, then you are ready to add this overlay by fetching its remote list as showed below:

```
wget -q -O /etc/layman/overlays/ineluctable-overlay.xml https://raw.github.com/toffanin/ineluctable-overlay/master/overlay.xml
```

At this point you can execute:

```
layman -a ineluctable-overlay
```


### Updating the overlay

Keep the overlay up to date with:

```
layman -s ineluctable-overlay
```


### Removing the overlay

The process of removing this overlay from your Gentoo environment is quite straightforward:

```
layman -d ineluctable-overlay
rm -r /etc/layman/overlays/ineluctable-overlay.xml
```

## Supported Architectures

This repository offers packages that are known to work on the following architectures:

1. x86 (32bit)
2. amd64 (64bit)
3. arm
4. x86-fbsd (experimental)


## Contributing

This overlay is still under development. Feedbacks and pull requests are very welcome and I encourage you to use the [issues list](https://github.com/toffanin/ineluctable-overlay/issues) on GitHub to provide your contributions.

I rarely reject pull requests.


## Overlay Package Tree

```
├── app-admin
│   └── fluentd
├── app-arch
│   └── archivemount
├── app-doc
│   └── dexy
├── app-emulation
│   ├── ganeti-webmgr
│   ├── hhvm
│   └── lxc
├── dev-db
│   ├── arangodb
│   └── vertexdb
├── dev-embedded
├── dev-lang
│   ├── dmd
│   ├── efene
│   ├── reia
│   └── v8
├── dev-libs
│   ├── hhvm-libevent
│   ├── icu
│   ├── libdwarf
│   ├── oniguruma
│   └── shflags
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
│   ├── mruby
│   ├── msgpack
│   ├── rspec
│   └── sax-machine
├── dev-util
│   ├── codeanalyst
│   ├── codexl
│   ├── cxxtest
│   └── oprofile
├── dev-vcs
│   └── gitflow-avh
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
├── www-servers
│   ├── mongrel
│   ├── thin
│   └── wsgid
├── x11-base
│   └── xynth
└── x11-wm
    └── scrotwm
```