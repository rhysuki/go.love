local Node = require("src.Node")
---Copy/paste this to skip basic boilerplate. You can replace the `require` there
---by just using `NODE:extend()` with globals on.
---
---Note: It's important to write `ClassName.super` instead of `self.super`
---because the former seems to cause some weird "Failed to initialize filesystem:
---already initialized" bug.
---@class NewClass: Node
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
