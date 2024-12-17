local Node = require("src.Node")
local NewClass = Node:extend()

function NewClass:new()
	NewClass.super.new(self)
end

function NewClass:update(dt)
	NewClass.super.update(self, dt)
end

function NewClass:draw()
	NewClass.super.draw(self)
end

return NewClass
