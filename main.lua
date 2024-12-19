local push = require("lib.push.push")
local timer = require("lib.hump.timer")
local Window = require("src.singleton.Window")
local Input = require("src.singleton.Input")
local Node
local root
local animations


function love.load()
	Window:setup(3)
	love.window.setTitle("Project Skeleton")

	Node = require("src.Node")
	root = Node()
	animations = require("assets.data.collections.animations")

	require("sample")(root)
end

function love.update(dt)
	Input:update()

	if Input:pressed("debug_quit") then love.event.quit() end
	if Input:pressed("debug_restart") then love.event.quit("restart") end
	if Input:pressed("debug_increase_window_size") then Window:resize(Window.scale + 1) end
	if Input:pressed("debug_decrease_window_size") then Window:resize(Window.scale - 1) end
	if Input:pressed("debug_enable_debug_mode") then debug.debug() end

	timer.update(dt)
	animations:update(dt)
	root:update(dt)
end

function love.draw()
	push:start()
	root:draw()
	push:finish()
end
