<div align="center">
	<img src="/demo/assets/banner_main.png">
</div>

A simple project skeleton for [LÖVE](https://love2d.org/) games that takes inspiration from [Godot](https://godotengine.org/). It's geared toward low-spec 2D pixel-art games, and includes libraries and assets to get you up and running as soon as you fork the repo.

<div align="center">
	<a href="/LICENSE.md">
		<img alt="GitHub License" src="https://img.shields.io/github/license/rhysuki/love-godot-base?style=for-the-badge">
	</a>
	<img alt="GitHub Release" src="https://img.shields.io/github/v/release/rhysuki/love-godot-base?style=for-the-badge">
	<br>
	<a href="https://github.com/rhysuki/love-godot-base/releases/latest">
		<img alt="What's new?" src="https://img.shields.io/badge/What's%20new%3F-red?style=for-the-badge">
	</a>
</div>

# Usage

To see the demo, run this repo as a LÖVE project. You can safely delete the entire `demo` folder and the line `require("demo")(root)` in `main.lua`.

This project is thoroughly annotated and documented with [Lua Language Server](https://luals.github.io/) annotations, which help tremendously for diagnostics, autocompletion, and opt-in type safety. If your environment doesn't support LLS, you can safely remove comments like `---@class`, `---@field`, etc, to make the code less noisy.

## /src/

> [!IMPORTANT]
> For further info and examples, read the documentation on each module's source files.

[`Node`](/src/Node.lua) is the building block for every ingame object. Nodes can have other Nodes as children, which are updated and drawn automatically, forming a tree structure.

[`Signal`](/src/Signal.lua) implements the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern), making communication between Nodes easy and loosely-coupled.

[`Hitbox`](/src/Hitbox.lua) is a Node wrapper around [bump](https://github.com/kikito/bump.lua) that makes it easy to detect and resolve collisions.

[`Input`](/src/singleton/Input.lua), [`Window`](/src/singleton/Window.lua) and [`Debug`](/src/singleton/Debug.lua) are singletons for accessing and changing game-wide state.

## /lib/

Libraries for common operations. Submodules are included for:

* [anim8](https://github.com/kikito/anim8) - Easily transforms spritesheets into animated objects.
* [baton](https://github.com/tesselode/baton) - Abstracts raw inputs into "actions" which can then be checked, altered or replaced.
* [batteries](https://github.com/1bardesign/batteries) - A better "standard library" for LÖVE games. Has utilities for math, sequencing, timing, vectors and more.
* [bump](https://github.com/kikito/bump.lua) - Collision detection and resolution for axis-aligned bounding boxes (AABBs).
* [classic](https://github.com/rxi/classic) - Tiny, battle-tested class module for object orientation.
* [hump](https://github.com/vrld/hump) - General-purpose utilities for LÖVE. This template mostly uses it for its timing and tweening functions.
* [inspect](https://github.com/kikito/inspect.lua) - Renders tables in a human-readable way.
* [log.lua](https://github.com/rxi/log.lua) - A tiny logging module.
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
To cut down on repeated `require`s, several globals are provided by default. They can be safely disabled by removing the line `require("globals")` from `main.lua`.

See a full list in [`globals.lua`](/globals.lua).

# Contributing
Issues, pull requests and suggestions are welcome. You can poke me in the [LÖVE Discord server](https://discord.gg/rhUets9).

# License
MIT License, see [LICENSE.md](/LICENSE.md) for details.

All libraries and their licenses have been included as-is (see /lib/).