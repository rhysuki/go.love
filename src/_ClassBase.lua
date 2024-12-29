local Node = require("src.Node")
local NewClass = Node:extend()

function NewClass:new()
	self.super.new(self)
end

function NewClass:update(dt)
	self.super.update(self, dt)
end

function NewClass:draw()
	self.super.draw(self)
end

return NewClass
