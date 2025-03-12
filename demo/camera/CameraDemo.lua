local help = require("demo.help")
local Logo = require("demo.Logo")
local Background = require("demo.camera.Background")
---@class CameraDemo: Node
local CameraDemo = NODE:extend()

function CameraDemo:new()
	CameraDemo.super.new(self)

	self:add_child(Background())
	LIB.timer.tween(7, CAMERA, {y = WINDOW.half_screen_height + 650}, "in-out-sine")
end

function CameraDemo:update(dt)
	CameraDemo.super.update(self, dt)
end

function CameraDemo:draw()
	CameraDemo.super.draw(self)
end

return CameraDemo
