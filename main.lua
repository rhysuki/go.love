local Window = require("src.singleton.Window")
-- Setup Window ASAP, as some things rely on window state to load properly
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
	-- Seems push has trouble getting shaders to draw over backgrounds properly,
	-- unless we clear it again after it's activated
	love.graphics.clear(colors.b16_black)
	root:draw()
	Debug:draw()
end

function love.load()
	love.window.setTitle("Project Skeleton")
	push:setBorderColor(colors.b16_black)
	-- These shaders are loaded but won't do anything until you send uniforms to them
	require("globals")
	log.info("Finished loading")

	local Demo = require("demo")
	Demo:run(root, Demo.topdown)
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
	-- Rumored workaround for LÖVE games misbehaving when streaming/recording
	-- Apparently, when trying to capture the game, primitive draw calls flicker
	-- until the first non-primitive one (e.g. text, images).
	-- I hear doing this helps
	love.graphics.setColor(colors.transparent)
	love.graphics.print(Debug.project_name)
	love.graphics.setColor(colors.white)

	push:start()
	Camera:draw(draw)
	push:finish()
end
