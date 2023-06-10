# gentoo-crossdev-podman

<p align="center">
  <a href="./LICENSE">
    <img alt="License: AGPLv3+TRANS RIGHTS" src="./img/license-badge.svg">
  </a>
</p>

This repository contains a `Makefile` that can be used to build Gentoo
`crossdev` toolchains and images.  It leverages the power of Podman to build
and install cross build tools on top of the official `gentoo/stage3` image.

## Building a Toolchain
Assuming [Podman](https://podman.io/) is configured properly on your system, all
you need to do is run `make`.

> #### Note
>
> This `Makefile` defaults to building for a `powerpc-unknown-linux-musl`
> target.  To run targets for something else, you'll need to specify a `TARGET`
> on the `make` command-line (e.g. `make TARGET=i686-unknown-linux-musl`).
>
> For more information about these `TARGET` tuples, see
> [here](https://wiki.gentoo.org/wiki/Cross_build_environment#Create_the_cross_toolchain).
> You can also run `make shell` and then `crossdev -t help` for more information
> on supported targets.

Built prefixes live in the `targets` directory.

## Making Additional Changes
You can install additional packages by running `make shell TARGET=YOUR_TARGET`
followed by `YOUR_TARGET-emerge PKG .. PKG_N`.

For more information on how this works see [this page](https://wiki.gentoo.org/wiki/Cross_build_environment#Build_the_desired_Software)
and the [Gentoo Handbook](https://wiki.gentoo.org/wiki/Handbook:Main_Page).
