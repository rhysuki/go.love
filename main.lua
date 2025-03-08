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
local limit_colors = love.graphics.newShader("src/shader/limit_colors.frag")
local palette_swap = love.graphics.newShader("src/shader/palette_swap.frag")
local root = Node()

---Draw function to pass to the Camera singleton, to avoid creating a new function
---every frame.
local function draw()
	---It seems push has trouble
	love.graphics.clear(COLORS.b16_black)
	root:draw()
	Debug:draw()
end

function love.load()
	love.window.setTitle("Project Skeleton")
	push:setBorderColor(colors.b16_black)
	-- These shaders are loaded but won't do anything until you send uniforms to them
	push:setShader({limit_colors, palette_swap})
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
