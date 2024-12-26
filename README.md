<div align="center">
	<img src="/demo/assets/banner_main.png">
</div>

A simple project skeleton for [LÖVE](https://love2d.org/) games that takes inspiration from [Godot](https://godotengine.org/). It's geared toward low-spec 2D pixel-art games, and includes libraries and assets to get you up and running as soon as you fork the repo.

<div align="center">
	<img alt="GitHub License" src="https://img.shields.io/github/license/rhysuki/love-godot-base">
	<img alt="GitHub Release" src="https://img.shields.io/github/v/release/rhysuki/love-godot-base">
	<br>
	<a href="https://github.com/rhysuki/love-godot-base/releases/latest">What's new?</a>
</div>

# Usage

To see the demo, run this repo as a LÖVE project. You can safely delete the entire `demo` folder - make sure to also delete the line `require("demo")(root)` in `main.lua`.

This project is thoroughly annotated and documented with [Lua Language Server](https://luals.github.io/) annotations, which help tremendously for diagnostics, autocompletion, and opt-in type safety. If your environment doesn't support LLS, you can safely remove comments like `---@class`, `---@field`, etc, to make the code less noisy.

## /src/

> [!IMPORTANT]
> For further info and examples, read the documentation on each of the linked modules' source files.

[`Node`](/src/Node.lua) is the building block for every ingame object. Nodes can have other Nodes as children, which are updated and drawn automatically, forming a tree structure.

[`Signal`](/src/Signal.lua) implements the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern), making communication between Nodes easy and loosely-coupled.

[`Hitbox`](/src/Hitbox.lua) is a Node wrapper around [bump](https://github.com/kikito/bump.lua) that makes it easy to detect and resolve collisions between Nodes, with helpful Signals to boot.

[`Input`](/src/singleton/Input.lua) and [`Window`](/src/singleton/Window.lua) are singletons to help with input and resolution handling, respectively.

## /lib/

Libraries for common operations. Submodules are included for:

* [anim8](https://github.com/kikito/anim8) - Easily transforms spritesheets into animated objects.
* [baton](https://github.com/tesselode/baton) - Abstracts raw inputs into "actions" which can then be checked, altered or replaced.
* [batteries](https://github.com/1bardesign/batteries) - A better "standard library" for LÖVE games. Has utilities for math, sequencing, timing, vectors and more.
* [bump](https://github.com/kikito/bump.lua) - Collision detection and resolution for axis-aligned bounding boxes (AABBs).
* [classic](https://github.com/rxi/classic) - Tiny, battle-tested class module for object orientation.
* [hump](https://github.com/vrld/hump) - General-purpose utilities for LÖVE. This template mostly uses it for its timing and tweening functions.
* [moses](https://github.com/Yonaba/Moses) - An "utility belt" for functional programming; makes it much easier to operate upon tables.
* [push](https://github.com/Ulydev/push) - Easy window resolution handling.

## /assets/

This is where static resources - data that doesn't change during the game - should go. Images, audio, fonts, but also things like Lua tables and Tiled maps.

Included collections:

* [`data/collections/animations.lua`](/assets/data/collections/animations.lua) - Preloaded `anim8` animations ready to use, mainly a player character.
* [`data/collections/colors.lua`](/assets/data/collections/colors.lua) - A set of basic colors, plus this project's palette of choice, Bubblegum 16.
* [`data/collections/fonts.lua`](/assets/data/collections/fonts.lua) - 3 basic pixel fonts for varying purposes.
* [`data/collections/images.lua`](/assets/data/collections/images.lua) - Placeholder pixel graphics for different occasions, from [Kenney's Micro Roguelike pack](https://kenney.nl/assets/micro-roguelike), already loaded as LÖVE images.
* [`data/collections/sounds.lua`](/assets/data/collections/sounds.lua) - Placeholder sound effects for different occasions, from [various Kenney packs](/assets/audio/credits.txt), already loaded as LÖVE sources.

## Globals
To cut down on repeated `require`s, several globals are provided by default. They can be safely disabled by removing the line `require("globals")` from `main.lua`, and a full list can be found in [`globals.lua`](/globals.lua).

# Contributing
Issues, pull requests and suggestions are welcome. You can poke me in the [LÖVE Discord server](https://discord.gg/rhUets9).

# License
MIT License, see [LICENSE.md](/LICENSE.md) for details.

All libraries and their licenses have been included as-is (see /lib/).