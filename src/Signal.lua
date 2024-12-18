local async = require("lib.batteries.async")
local Class = require("lib.classic.classic")
---Represents an emittable event that objects can subscribe to. This implements the
---Observer pattern.
local Signal = Class:extend()

function Signal:new()
	-- Objects should be garbage-collected even if they're subscribed to a signal.
	self._SUBS = setmetatable({}, {__mode = "k"})
end

---Subscribe to this Signal. The function will be called when this Signal fires,
---and will be passed the Node as its first argument.
---
---For example: `ball.exited_screen:subscribe(self, self.add_point)`
---
---In a pinch, it can also be given a `nil` Node and an anonymous function, but
---it's a bit less readable and reusable.
---
---For example: `ball.exited_screen:subcscribe(nil, function() self:add_point() end)`
---@param node table
---@param fn function
function Signal:subscribe(node, fn)
	table.insert(self._SUBS, {node, fn})
end

---Remove the function from this Signal's subscriptions. If it wasn't already
---subscribed, nothing happens.
---
---For example: `ball.exited_screen:unsubscribe(scoreboard.add_point)`
---@param fn function
function Signal:unsubscribe(fn)
	for i = #self._SUBS, 1, -1 do
		if fn == self._SUBS[i][2] then
			table.remove(self._SUBS, i)
		end
	end
end

---Remove all functions associated with this Node from this Signal's subscriptions.
---If none are found, nothing happens.
---
---For example: `ball.exited_screen:unsubscribe_all(scoreboard)`
---@param node table
function Signal:unsubscribe_all(node)
	for i = #self._SUBS, 1, -1 do
		if self._SUBS[i] == node then
			table.remove(self._SUBS, i)
		end
	end
end

---Fire this signal, calling every subcribed function and passing in their associated
---Node as the first argument. Extra arguments are passed to every function.
---@param ... any[]
function Signal:emit(...)
	-- Clear out dead node functions before emitting
	-- We have to do it backwards and one at a time to make sure the loop doesn't
	-- break from removing too many table elements while it's still going
	for _ = #self._SUBS, 1, -1 do
		local node, fn = self._SUBS[1], self._SUBS[2]

		if not node.is_alive then
			self:unsubscribe(fn)
		end
	end

	for _, sub in ipairs(self._SUBS) do
		local node, fn = sub[1], sub[2]

		if node.is_alive then
			fn(node, ...)
		end
	end
end

---Stall whichever async kernel's currently running until this signal fires.
---This is useful with the `async` module from the `batteries` library.
function Signal:await()
	local has_fired = false
	local function fn()
		has_fired = true
	end

	self:subscribe(self, fn)

	while not has_fired do
		async.stall()
	end

	self:unsubscribe(fn)
end

return Signal
