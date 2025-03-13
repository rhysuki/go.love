local help = require("demo.help")
local Logo = require("demo.Logo")
local Background = require("demo.camera.Background")
local Twinkle = require("demo.camera.Twinkle")
---@class CameraDemo: Node
local CameraDemo = NODE:extend()

function CameraDemo:new()
	CameraDemo.super.new(self)

	self.overlay_color = {1, 1, 1, 1}
	self:add_child(Background())
	self.twinkle = self:add_child(Twinkle(0, -WINDOW.half_screen_height - 30))
	self.async = LIB.batteries.async()

	WINDOW.shaders.limit_colors:send("palette", IMAGES.palette_bubblegum_16)

	self.async:call(function()
		self:wait(2)
		self:await_tween(2, self.overlay_color, {1, 1, 1, 0}, "out-circ")
		LIB.timer.tween(6, self.twinkle, {y = 0}, "out-sine")

		self:wait(1)
		self:await_tween(9, CAMERA, {y = WINDOW.half_screen_height + 650}, "in-out-sine")
		self:wait(1)
		CAMERA:shake(5, 0.5)
		self.twinkle.cycle_palette = true

		self:wait(1.5)
		CAMERA:shake(5, 0.5)
		self.twinkle:die()
		self:add_child(Logo(CAMERA.x, CAMERA.y))

		self:wait(4)
		self.overlay_color = {0, 0, 0, 0}
		LIB.timer.tween(2, self.overlay_color, {0, 0, 0, 1}, "out-circ")
	end)
end

function CameraDemo:update(dt)
	CameraDemo.super.update(self, dt)
	self.async:update(dt)
end

function CameraDemo:draw()
	CameraDemo.super.draw(self)

	love.graphics.setColor(self.overlay_color)
	love.graphics.rectangle(
		"fill",
		CAMERA.x - WINDOW.half_screen_width,
		CAMERA.y - WINDOW.half_screen_height,
		WINDOW.screen_width,
		WINDOW.screen_height
	)
	love.graphics.setColor(COLORS.white)
end

function CameraDemo:await_tween(duration, ...)
	LIB.timer.tween(duration, ...)
	self:wait(duration)
end

return CameraDemo
