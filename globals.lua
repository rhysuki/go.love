---Global variables for commonly used tables, like collections, libraries, and Node.
---All globals are immutable tables, and named in UPPER_SNAKE_CASE.

-- Classes
NODE = require("src.Node")
SIGNAL = require("src.Signal")

-- Singletons
INPUT = require("src.singleton.Input")
WINDOW = require("src.singleton.Window")
DEBUG = require("src.singleton.Debug")

-- Libraries
LIB = {
	anim8 = require("lib.anim8.anim8"),
	baton = require("lib.baton.baton"),
	batteries = require("lib.batteries"),
	bump = require("lib.bump.bump"),
	classic = require("lib.classic.classic"),
	timer = require("lib.hump.timer"),
	moses = require("lib.moses.moses"),
	push = require("lib.push.push")
}

-- Collections
ANIMATIONS = require("assets.data.collections.animations")
COLORS = require("assets.data.collections.colors")
FONTS = require("assets.data.collections.fonts")
IMAGES = require("assets.data.collections.images")
SOUNDS = require("assets.data.collections.sounds")
