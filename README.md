# Elanora96's Flake-Templates

## Usage

```sh
nix flake init -t github:elanora96/flake-templates#<template>
```

A common theme among these templates is the use of [`flake-parts`](https://flake.parts) to reduce custom Nix glue.

Additionally, [`treefmt-nix`](https://flake.parts/options/treefmt-nix.html) and [`git-hooks-nix`](https://flake.parts/options/git-hooks-nix.html), which provide `flake-parts` modules, are used to run formatters and checks for many languages with a simple `nix fmt` and `nix check`.

Of course, they all make reproducible builds and deployments as easy as possible.

I fell in love with Nix using these templates in my own projects, I hope they ease the barrier of entry for newcomers to the Nix ecosystem.
