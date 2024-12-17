# About
A lightweight project skeleton for [LÖVE](https://love2d.org/) games that takes
inspiration from [Godot](https://godotengine.org/). It's geared toward low-spec
pixel-art games, and includes libraries to get you up and running as soon as you
fork the repo.

# Cleanup For Usage
You can safely delete this README and the entire `src/sample` folder.

Make sure to delete the line `require("src.sample")` in `main.lua`.

# Style
Classes and class files are in `PascalCase`. Class member naming follows these guidelines:

1. Constants are in `UPPER_SNAKE_CASE`.
2. Variables and functions are in `snake_case`.
3. Private members are prefixed with an underscore `_`. These are generally only supposed to be used within the class itself, and aren't part of its public API.