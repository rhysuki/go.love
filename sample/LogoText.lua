local timer = require("lib.hump.timer")
local colors = require("assets.data.collections.colors")
local Node = require("src.Node")
local LogoText = Node:extend()

function LogoText:new(x, y)
	LogoText.super.new(self, x, y)

	self._progress = 0
	self._pink = {unpack(colors.b16_pink)}
	self._dark_pink = {unpack(colors.b16_dark_pink)}
	self._star = love.graphics.newImage("sample/assets/small_star.png")

	timer.tween(0.5, self, {_progress = 1}, "out-back")
end

function LogoText:update(dt)
	LogoText.super.update(self, dt)

	-- Update alpha
	self._pink[4] = self._progress
	self._dark_pink[4] = self._progress
end

function LogoText:draw()
	LogoText.super.draw(self)

	love.graphics.setColor(self._pink)
	love.graphics.draw(self._star, self.x + 7 - self._progress * 13, self.y + 6)

	love.graphics.setColor(self._dark_pink)
	love.graphics.printf(
		"Love-Godot Template\nv1.0.0",
		self.x - 37,
		self.y + self._progress * 10,
		100,
		"center"
	)

	love.graphics.setColor(colors.b16_pink)
	love.graphics.print("rhysuki", self.x + self._progress * 4, self.y)
	love.graphics.setColor(colors.white)
end

return LogoText
