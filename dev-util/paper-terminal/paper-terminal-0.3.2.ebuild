# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.2.0

EAPI=7

CRATES="
adler32-1.0.4
aho-corasick-0.7.6
ansi_term-0.11.0
ansi_term-0.12.1
arrayvec-0.4.12
atty-0.2.13
autocfg-0.1.7
bitflags-1.2.1
byteorder-1.3.2
cc-1.0.46
cfg-if-0.1.10
clap-2.33.0
clicolors-control-1.0.1
cloudabi-0.0.3
color_quant-1.0.1
console-0.7.7
crossbeam-deque-0.7.1
crossbeam-epoch-0.7.2
crossbeam-queue-0.1.2
crossbeam-utils-0.6.6
deflate-0.7.20
directories-1.0.2
either-1.5.3
encode_unicode-0.3.6
getopts-0.2.21
gif-0.10.3
heck-0.3.1
hex-0.4.0
image-0.21.3
inflate-0.4.5
itoa-0.4.4
jpeg-decoder-0.1.16
lazy_static-1.4.0
libc-0.2.65
lock_api-0.3.1
lzw-0.10.0
memchr-2.2.1
memoffset-0.5.1
nodrop-0.1.14
num-derive-0.2.5
num-integer-0.1.41
num-iter-0.1.39
num-rational-0.2.2
num-traits-0.2.8
num_cpus-1.10.1
paper-terminal-0.3.2
parking_lot-0.9.0
parking_lot_core-0.6.2
png-0.14.1
proc-macro2-0.4.30
proc-macro2-1.0.6
pulldown-cmark-0.4.1
quote-0.6.13
quote-1.0.2
rayon-1.2.0
rayon-core-1.6.0
redox_syscall-0.1.56
regex-1.3.1
regex-syntax-0.6.12
rustc_version-0.2.3
ryu-1.0.2
scoped_threadpool-0.1.9
scopeguard-1.0.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.101
serde_derive-1.0.101
serde_json-1.0.41
smallvec-0.6.10
strsim-0.8.0
structopt-0.2.18
structopt-derive-0.2.18
syn-0.15.44
syn-1.0.5
syncat-stylesheet-0.2.2
terminal_size-0.1.8
termios-0.3.1
textwrap-0.11.0
thread_local-0.3.6
tiff-0.2.2
tree-sitter-0.3.10
unicase-2.5.1
unicode-segmentation-1.3.0
unicode-width-0.1.6
unicode-xid-0.1.0
unicode-xid-0.2.0
vec_map-0.8.1
version_check-0.1.5
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Writes a file to a paper in your terminal. Especially if that file is Markdown."
HOMEPAGE="https://github.com/foxfriends/paper-terminal"
SRC_URI="$(cargo_crate_uris ${CRATES})"

RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

DOCS=( README.md )

src_install() {
	dobin target/release/paper
	einstalldocs
}