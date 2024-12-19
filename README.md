![](/demo/assets/banner_main.png)

A simple project skeleton for [LÖVE](https://love2d.org/) games that takes inspiration from [Godot](https://godotengine.org/). It's geared toward low-spec pixel-art games, and includes libraries and assets to get you up and running as soon as you fork the repo.

# Usage

To see the demo, run this repo as a LÖVE project. You can safely delete the entire `demo` folder - make sure to also delete the line `require("demo")(root)` in `main.lua`.

## /src/

`Node` is the building block for every ingame object. Nodes can have other Nodes as children, which are updated and drawn automatically, forming a tree structure.

`Signal` implements the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern), making communication between Nodes easy and loosely-coupled.

`Input` and `Window` are singletons to help with input and resolution handling, respectively.

> [!IMPORTANT]
> For further info and examples, read the documentation on the source files for [Node](/src/Node.lua), [Signal](/src/Signal.lua), [Input](/src/singleton/Input.lua) and [Window](/src/singleton/Window.lua)..

## /lib/

Libraries for common operations. This repo includes submodules for:

* [anim8](https://github.com/kikito/anim8) - Easily transforms spritesheets into animated objects.
* [baton](https://github.com/tesselode/baton) - Abstracts raw inputs into "actions" which can then be checked, altered or replaced.
* [batteries](https://github.com/1bardesign/batteries) - A better "standard library" for LÖVE games. Has utilities for math, sequencing, timing, vectors and more.
* [classic](https://github.com/rxi/classic) - Tiny, battle-tested class module for object orientation.
* [hump](https://github.com/vrld/hump) - General-purpose utilities for LÖVE. This repo mostly uses it for its timing and tweening functions.
* [moses](https://github.com/Yonaba/Moses) - An "utility belt" for functional programming; makes it much easier to operate upon tables.
* [push](https://github.com/Ulydev/push) - Easy window resolution handling.

## /assets/

This is where static resources - data that doesn't change during the game - should go. Images, audio, fonts, but also things like Lua tables and Tiled maps.

Included collections:

* [`data/collections/colors.lua`](/assets/data/collections/colors.lua) - A set of basic colors, plus this project's palette of choice, Bubblegum 16.
* [`data/collections/fonts.lua`](/assets/data/collections/fonts.lua) - 3 basic pixel fonts for varying purposes.
* [`data/collections/images.lua`](/assets/data/collections/images.lua) - Placeholder pixel graphics for different occasions, from [Kenney's Micro Roguelike pack](https://kenney.nl/assets/micro-roguelike), already loaded as LÖVE images.
* [`data/collections/animations.lua`](/assets/data/collections/animations.lua) - Preloaded `anim8` animations ready to use, mainly a player character.

# Contributing
Issues, pull requests and suggestions are welcome. You can poke me in the [LÖVE Discord server](https://discord.gg/rhUets9).

# License
MIT License, see [LICENSE.md](/LICENSE.md) for details.

All libraries and their licenses have been included as-is (see /lib/).