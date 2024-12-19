local colors = require("assets.data.collections.colors")
local Node = require("src.Node")
local Window = require("src.singleton.Window")
local NewClass = Node:extend()

function NewClass:new()
	NewClass.super.new(self)

	self._star = love.graphics.newImage("demo/assets/big_star.png")
	self._positions = {}
end

function NewClass:update(dt)
	NewClass.super.update(self, dt)

	table.insert(self._positions, {self.x, self.y})
	if #self._positions >= 10 then table.remove(self._positions, 1) end
end

function NewClass:draw()
	NewClass.super.draw(self)

	for i = 1, #self._positions do
		local x, y = self._positions[i][1], self._positions[i][2]
		local color

		if i > 8 then
			color = colors.b16_pink
		elseif i > 6 then
			color = colors.b16_dark_pink
		elseif i > 4 then
			color = colors.b16_purple
		else
			color = colors.transparent
		end

		love.graphics.setColor(color)
		love.graphics.draw(self._star, x - 8, y - 8)
	end

	love.graphics.setColor(colors.white)
end

return NewClass
