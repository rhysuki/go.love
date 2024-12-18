# About
A lightweight project skeleton for [LÖVE](https://love2d.org/) games that takes inspiration from [Godot](https://godotengine.org/). It's geared toward low-spec pixel-art games, and includes libraries to get you up and running as soon as you fork the repo.

# Usage

To see the sample, run this repo as a LÖVE project. You can safely delete the entire `sample` folder - make sure to also delete the line `require("sample")(root)` in `main.lua`.

## /src/

`Node` is the building block for every ingame object. Nodes can have other Nodes as children, which are updated and drawn automatically, forming a tree structure.

`Signal` implements the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern), making communication between Nodes easy and loosely-coupled.


> [!IMPORTANT]
> For further info and examples, read the documentation on the source files for [Node](/src/Node.lua) and [Signal](/src/Signal.lua).

## /lib/

Libraries for common operations. This repo includes submodules for:

* [anim8]() - Easily transforms spritesheets into animated objects.
* [baton]() - Abstracts raw inputs into "actions" which can then be checked, altered or replaced.
* [batteries]() - A better "standard library" for LÖVE games. Has utilities for math, sequencing, timing, vectors and more.
* [classic]() - Tiny, battle-tested class module for object orientation.
* [hump]() - General-purpose utilities for LÖVE. This repo mostly uses it for its timing and tweening functions.
* [push]() - Window resolution handling.

## /assets/

This is where static resources - data that doesn't change during the game - should go. Images, audio, fonts, but also things like Lua tables and Tiled maps.

# Contributing
Issues, pull requests and suggestions are welcome. You can poke me in the [LÖVE Discord server](https://discord.gg/rhUets9).

# License
MIT License, see [LICENSE.md](/LICENSE.md) for details.

All libraries and their licenses have been included as-is (see /lib/).