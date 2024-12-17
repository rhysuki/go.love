local async = require("lib.batteries.async")
local Class = require("lib.classic.classic")
---Represents an emittable event objects can subscribe to. This implements the
---Observer pattern.
local Signal = Class:extend()

function Signal:new()
	-- Objects should be garbage-collected even if they're subscribed to a signal.
	self._SUBS = setmetatable({}, {__mode = "k"})
end

---@param node table
---@param fn function
function Signal:subscribe(node, fn)
	table.insert(self._SUBS, {node, fn})
end

---Remove all subscribers associated with the passed object or function. Do nothing
---if there are none.
---@param thing table | function
function Signal:unsubscribe(thing)
	for i = 1, #self._SUBS do
		local node, fn = self._SUBS[1], self._SUBS[2]

		if thing == node or thing == fn then
			table.remove(self._SUBS, i)
		end
	end
end

---Emits this signal, calling every subcribed function.
---The functions always get the associated subscribed object as the first arg.
---@param ... any[] The extra args to be passed to every subscribed function.
function Signal:emit(...)
	for _, t in ipairs(self._SUBS) do
		local node, fn = t[1], t[2]

		if node.is_alive then
			fn(node, ...)
		end
	end
end

---Stall whichever async kernel's currently running until this signal fires.
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
