local colors = require("assets.data.collections.colors")
local mathx = require("lib.batteries.mathx")
local Node = require("src.Node")
local StarParticle = Node:extend()
local frame_time = 0.016666

function StarParticle:new(x, y, velocity_x, velocity_y)
	StarParticle.super.new(self, x, y)
	self._elapsed = 0
	self._vx = velocity_x or 0
	self._vy = velocity_y or 0
	self._star = love.graphics.newImage("demo/assets/star.png")
end

function StarParticle:update(dt)
	StarParticle.super.update(self, dt)

	self._elapsed = self._elapsed + dt
	self._vx = mathx.lerp(self._vx, 0, 0.02)
	self._vy = math.min(self._vy + dt * 5, 5)
	self.x = self.x + self._vx * dt * 60
	self.y = self.y + self._vy * dt * 60

	if self._elapsed > frame_time * 100 then self:die() end
end

function StarParticle:draw()
	local scale = mathx.clamp01((frame_time * 80 - self._elapsed) / (frame_time * 60))
	local color

	StarParticle.super.draw(self)

	if self._elapsed < frame_time * 5 then
		color = colors.b16_white
	elseif self._elapsed < frame_time * 30 then
		color = colors.b16_pink
	elseif self._elapsed < frame_time * 50 then
		color = colors.b16_dark_pink
	else
		color = colors.b16_purple
	end

	love.graphics.setColor(color)
	love.graphics.draw(self._star, self.x, self.y, 0, scale, scale, 5, 4)
	love.graphics.setColor(colors.white)
end

return StarParticle
