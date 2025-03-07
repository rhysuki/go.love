local Window = require("src.singleton.Window")
---Setup Window ASAP, as some things rely on window state to load properly
Window:setup(3)

local push = require("lib.push.push")
local timer = require("lib.hump.timer")
local log = require("lib.log.log")
local colors = require("assets.data.collections.colors")
local Input = require("src.singleton.Input")
local Debug = require("src.singleton.Debug")
local Camera = require("src.singleton.Camera")
local Node = require("src.Node")
local animations = require("assets.data.collections.animations")
local root = Node()

---Draw function to pass to the Camera singleton, to avoid creating a new function
---every frame.
local function draw()
	root:draw()
	Debug:draw()
end

function love.load()
	love.window.setTitle("Project Skeleton")
	push:setBorderColor(colors.b16_black)
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
	Camera:update(dt)
end

function love.draw()
	push:start()
	Camera:draw(draw)
	push:finish()
end
