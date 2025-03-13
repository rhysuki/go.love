local Node = require("src.Node")
---@class Twinkle: Node
local Twinkle = Node:extend()

function Twinkle:new()
	Twinkle.super.new(self)

	self.img = love.graphics.newImage("demo/camera/twinkle.png")
	local grid = LIB.anim8.newGrid(73, 62, self.img:getWidth(), self.img:getHeight())
	self.animation = LIB.anim8.newAnimation(grid("1-3", 1), 0.1)
	self.current_palette = 1
	self.palettes = {}
	self.cycle_palette = false

	for i = 1, 6 do
		self.palettes[i] = love.graphics.newImage("demo/camera/palette_" .. tostring(i) .. ".png")
	end

	LIB.timer.every(0.05, function()
		if self.cycle_palette then
			self.current_palette = LIB.batteries.mathx.wrap(self.current_palette + 1, 1, #self.palettes + 1)
		end
	end)
end

function Twinkle:update(dt)
	Twinkle.super.update(self, dt)
	self.animation:update(dt)

	WINDOW.shaders.palette_swap:send("palette", self.palettes[self.current_palette])
end

function Twinkle:draw()
	Twinkle.super.draw(self)
	self.animation:draw(self.img, CAMERA.x - 37 + self.x, CAMERA.y - 32 + self.y)
end

function Twinkle:die()
	Twinkle.super.die(self)
	WINDOW.shaders.palette_swap:send("palette", IMAGES.empty)
end

return Twinkle
