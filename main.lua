local push = require("lib.push.push")
local timer = require("lib.hump.timer")
local log = require("lib.log.log")
local colors = require("assets.data.collections.colors")
-- local gamera = require("gamera")
-- local camera = require("lib.hump.camera")
local Window = require("src.singleton.Window")
local Input = require("src.singleton.Input")
local Debug = require("src.singleton.Debug")
local Camera
local Node
local root
local animations
-- local cam

---Draw function to pass to the Camera singleton, to avoid creating a new function
---every frame.
local function draw()
	root:draw()
	Debug:draw()

	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.setLineWidth(5)
	love.graphics.rectangle("line", 0, 0, Window.screen_width, Window.screen_height)
	-- love.graphics.circle("fill", 0, 0, 10000)
	love.graphics.setLineWidth(1)

	-- local mx, my = Window:get_mouse_position()
	-- -- local x, y = Camera:to_screen_position(mx, my)
	-- local x, y = Camera:to_screen_position(0, 0)
	-- love.graphics.circle("fill", x, y, 15)

	love.graphics.setColor(1, 1, 1, 1)
end

function love.load()
	Window:setup(3)
	---! Camera MUST be required AFTER WINDOW SETUP!!!!!!!!!
	Camera = require("src.singleton.Camera")
	love.window.setTitle("Project Skeleton")
	push:setBorderColor(colors.b16_black)

	Node = require("src.Node")
	root = Node()
	animations = require("assets.data.collections.animations")

	require("globals")
	require("demo")(root, "topdown")
	log.info("Finished loading")

	-- cam = gamera.new(-math.huge, -math.huge, math.huge, math.huge)
	-- cam = gamera.new(0, 0, 2000, 2000)
	-- Camera positions are based around its middle point
	-- cam:setPosition(Window.screen_width, Window.screen_height)
	-- Camera.x = Window.screen_width
	-- Camera.y = Window.screen_height
end

function love.update(dt)
	Input:update()
	timer.update(dt)
	animations:update(dt)
	-- cam:setPosition(cam.x + 2.5, cam.y + 2.5)
	-- print(Window:get_mouse_position())
	local mx, my = Window:get_mouse_position()
	Camera.x = Window.screen_width + mx
	Camera.y = Window.screen_height + my

	-- if Input:pressed("menu") then Camera.scale = 0.5 end
	-- cam:setPosition(0, 0)
	-- cam:setScale((Window:get_mouse_position()) / 100)
	-- print(cam.x, cam.y)
	-- Camera.x = Camera.x + 2.5
	-- Camera.y = Camera.y + 2.5
	-- print(Camera.gamera.x, Camera.gamera.y)
	print(Camera.x, Camera.gamera.x)
	root:update(dt)
	Debug:update(dt)
	Camera:update(dt)
end

function love.draw()
	push:start()
	Camera:draw(draw)
	-- draw()
	push:finish()
end
