local colors = require("assets.data.collections.colors")
local Node = require("src.Node")
local Signal = require("src.Signal")
local Ball = Node:extend()

function Ball:new()
	Ball.super.new(self)
end

function Ball:update(dt)
	Ball.super.update(self, dt)
	self.x = self.x + 1
	self.y = self.y + 1
end

function Ball:draw()
	Ball.super.draw(self)

	love.graphics.setColor(colors.b16_pink)
	love.graphics.circle("fill", self.x, self.y, 10)
	love.graphics.setColor(colors.white)
end

return Ball
