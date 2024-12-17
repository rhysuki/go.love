local colors = require("assets.data.collections.colors")
local Node = require("src.Node")
local Window = require("src.singleton.Window")
local NewClass = Node:extend()

function NewClass:new()
	NewClass.super.new(self)

	self._star = love.graphics.newImage("sample/assets/big_star.png")
	self._positions = {}
end

function NewClass:update(dt)
	NewClass.super.update(self, dt)

	table.insert(self._positions, {x = self.x, y = self.y})
	if #self._positions >= 10 then table.remove(self._positions, 1) end
end

function NewClass:draw()
	NewClass.super.draw(self)

	for i = 1, #self._positions do
		local pos = self._positions[i]
		local color

		if i > 8 then
			color = colors.b16_pink
		elseif i > 6 then
			color = colors.b16_dark_pink
		elseif i > 4 then
			color = colors.b16_purple
		elseif i > 2 then
			color = colors.transparent
		else
			color = colors.transparent
		end

		love.graphics.setColor(color)
		love.graphics.draw(self._star, pos.x - 8, pos.y - 8)
	end

	love.graphics.setColor(colors.white)
end

return NewClass
