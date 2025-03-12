local Node = require("src.Node")
---@class Background: Node
local Background = Node:extend()

function Background:new()
	Background.super.new(self)

	self.background = self:add_child(NODE())
	self.background.image = love.graphics.newImage("demo/camera/background.png")
	self.clouds2 = self:add_child(NODE())
	self.clouds2.image = love.graphics.newImage("demo/camera/clouds2.png")
	self.clouds1 = self:add_child(NODE())
	self.clouds1.image = love.graphics.newImage("demo/camera/clouds1.png")
end

function Background:update(dt)
	Background.super.update(self, dt)

	local camera_y = CAMERA.y - WINDOW.half_screen_height

	self.background.y = camera_y * 0.8
	self.clouds2.y = camera_y * 0.5
end

function Background:draw()
	Background.super.draw(self)
end

return Background
