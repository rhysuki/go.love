local Signal = require("src.Signal")
local Class = require("lib.classic.classic")
---An ingame object. This is the building block for any class that contributes
---to the gameplay itself; things that change with time and player input.
---It can store children nodes that are automatically updated and drawn, forming
---a tree.
---
--There's always 1 main "root" node at the top of the project.
local Node = Class:extend()

---@param x number?
---@param y number?
function Node:new(x, y)
	self._CHILDREN = {}

	self.x = x or 0
	self.y = y or 0
	self.parent = nil
	self.is_active = true
	self.is_visible = true
	self.is_alive = true

	self.died = Signal()
end

---Called by this Node's parent when it becomes a child node. Unlike the constructor,
---code inside `_ready()` is guaranteed to only run when this is inside the scene
---tree (i.e., when everything is initialized and ready to use).
function Node:_ready()
end

function Node:update(dt)
	-- Remove dead children (jesus)
	for i = #self._CHILDREN, 1, -1 do
		if not self._CHILDREN[i].is_alive then
			table.remove(self._CHILDREN, i)
		end
	end

	-- Update children
	for i = 1, #self._CHILDREN do
		local child = self._CHILDREN[i]

		if child.is_alive and child.is_active then
			child:update(dt)
		end
	end
end

function Node:draw()
	for i = 1, #self._CHILDREN do
		local child = self._CHILDREN[i]

		if child.is_alive and child.is_visible then
			child:draw()
		end
	end
end

---@param node table
---@return table
function Node:add_child(node)
	table.insert(self._CHILDREN, node)
	node.parent = self
	node:_ready()
	return node
end

---Generate an iterator for this Node's children. Use inside a for-loop, like:
---```lua
---  for child in node:iter_children() do
---    ...
--- end
---```
---This prevents exposure of how children are kept internally.
---@return function
function Node:iter_children()
	local i = 0

	return function()
		i = i + 1
		if self._CHILDREN[i] then
			return self._CHILDREN[i]
		end
	end
end

---Die and kill all children nodes. They stop updating and drawing until the start
---of the next update cycle, wherein they're removed from the game.
function Node:die()
	self.is_active = false
	self.is_visible = false
	self.is_alive = false

	for _, child in ipairs(self._CHILDREN) do
		child:die()
	end

	self.died:emit()
end

return Node
