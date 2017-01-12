## Ineluctable Overlay

[![Build Status](https://travis-ci.org/Dr-Terrible/ineluctable-overlay.png)](https://travis-ci.org/Dr-Terrible/ineluctable-overlay)

Ineluctable Overlay offers a repository of Gentoo ebuilds maintained by me for projects that are not yet available through the Portage tree.

## Managing This Overlay

This section will show you how to install the _Ineluctable Overlay_ into your Gentoo system, hence the following instructions assume a certain level of expertise using [_Portage_](http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=2&chap=1) and [_layman_]( http://layman.sourceforge.net).

### Disclaimer

Keep in mind that this overlay provides packages that differ from the ones in the Portage tree.

> **If you do have troubles with an ebuild provided by this overlay, please take it up with the ebuild provider (the owner of this GitHub account) and not with the official Gentoo's developers. In short, in case of issues, please DO NOT report bugs at bugs.gentoo.org for these ebuilds.**


### Installing the overlay

In order to manage the overlay, the package **app-portage/layman** must be installed into your environment:

```
emerge -av app-portage/layman
```

If the installation of _layman_ was successfully completed, then you are ready to add this overlay by fetching its remote list as showed below:

```
wget -q -O /etc/layman/overlays/ineluctable-overlay.xml https://raw.github.com/Dr-Terrible/ineluctable-overlay/master/overlay.xml
```

At this point you can execute:

```
layman -Lk
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

I welcome issue reports, feedbacks, and ebuild requests; I encourage you to use
the [issues list](https://github.com/Dr-Terrible/ineluctable-overlay/issues) on GitHub to
provide them.

Code contributions and bug fixes are welcome too, and I encourage the use of
pull requests to _discuss_ and _review_ your ebuild code changes. Before
proposing a large change, please discuss it by raising an issue.

### Before You Begin

This overlay assumes that you have read, and properly understood, the
[Gentoo Developer Manual](https://devmanual.gentoo.org).

### Code of Conduct

Help me to keep this overlay open and inclusive for everyone. Please, read and
follow the [Code of Conduct](CODE_OF_CONDUCT.md).

### Making and Submitting Changes

To make the process of pull requests submission as seamless as possible, I ask
for the following:

1. Go ahead and fork this project and make your changes.
2. When your code changes are ready, make sure to run `repoman fix -d`,
   `repoman full -d`, and `repoman -vx full` in the root of the repository to
   ensure that all the Gentoo's QA tests pass. This is necessary to assure
   nothing was accidentally broken by your changes; for the purpose, this GitHub
   repository integrates Travis for Continuous Integration of repoman tests.
   **I only take pull requests with passing repoman tests**.
3. If your commits are all related to the same ebuild, it's advisable to squash
   then into a single one with `git rebase -i`. It's okay to force update your
   pull request with git `push -f`, if necessary.
4. Make sure your git commit messages are in the proper format to make reading
   history easier. Commit message should look like:

   ```
   [category/package-name] Short description

   Long description
   ```

   If you have questions about how to write the short / long descriptions, please
   read these blog articles: [How to Write a Commit Message](http://chris.beams.io/posts/git-commit),
   [5 Useful Tips For A Better Commit Message](https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message). Both of them are excellent resources for learning how to write a
   well-crafted git commit message. If your commit references one or more GitHub
   issues, always end your commit message body with _See #1234_ or _Fixes #1234_
   (replace 1234 with the desired GitHub issue ID).
5. GPG signing your changes is a good idea, but not mandatory.
6. Push your changes to your branch in your fork, and then submit a
   [pull request](https://help.github.com/send-pull-requests) agains this
   repository.
7. Comment in the pull request when you are ready for the changes to be
   reviewed: `PR ready for review`.

At this point you are waiting for my feedbacks. I look at pull requests within
few days. I may suggest some improvements or alternatives.
