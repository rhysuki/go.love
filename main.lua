local push = require("lib.push.push")
local timer = require("lib.hump.timer")
local log = require("lib.log.log")
local colors = require("assets.data.collections.colors")
local Window = require("src.singleton.Window")
local Input = require("src.singleton.Input")
local Debug = require("src.singleton.Debug")
local Node
local root
local animations


function love.load()
	Window:setup(3)
	love.window.setTitle("Project Skeleton")
	push:setBorderColor(colors.b16_black)

	Node = require("src.Node")
	root = Node()
	animations = require("assets.data.collections.animations")

	require("globals")
	require("demo")(root, "topdown")
	log.info("Finished loading")
end

function love.update(dt)
	Input:update()
	timer.update(dt)
	animations:update(dt)
	root:update(dt)
	Debug:update(dt)
end

function love.draw()
	push:start()
	root:draw()
	Debug:draw()
	push:finish()
end
