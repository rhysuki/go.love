local async = require("lib.batteries.async")
local Class = require("lib.classic.classic")
---Represents an emittable event that objects can subscribe to. This implements the
---Observer pattern.
---
---By making Signals for important events, then tying them to functions, objects
---can communicate without being coupled together; they don't have to depend on
---(or even know about!) each other. This frees them to be as general-purpose as
---they want.
---
---Signals are useful when you say "I'd like anything to be able to respond to this
---situation in their own way."
---
---For example: When a `Player` takes damage, it can emit an `on_damage_taken` Signal.
---Then, a `HealthBar`  could connect its `update_progress()` function, and a
---`Counter` could connect its `increment()` function, both to that same Signal.
---
---The end result is that the health bar updates and the counter increments when
---the player takes damage, and neither the health bar, the counter, nor the player,
---had to know about each other to work together.
---
---You could then connect a `ParticleGenerator` to `Player.on_damage_taken` to spawn
---blood effects, or connect a `Counter` to a `FileLoader.on_file_loaded` to keep
---track of file progress, all without having to write special-purpose code to
---explicitly tie those specific classes together.
---
---Nifty!
---@class Signal
---@field extend function
---@overload fun(): Signal
local Signal = Class:extend()

function Signal:new()
	-- Objects should be garbage-collected even if they're subscribed to a signal.
	self._SUBS = setmetatable({}, {__mode = "k"})
end

---Subscribe to this Signal. The function will be called when this Signal fires,
---and will be passed the Node as its first argument.
---
---For example: `ball.exited_screen:subscribe(self, self.increase_score)`
---
---In a pinch, it can also be given a `nil` Node and an anonymous function, but
---it's a bit less readable and reusable.
---
---For example: `ball.exited_screen:subscribe(nil, function() self:increase_score() end)`
---@param node table
---@param fn function
function Signal:subscribe(node, fn)
	table.insert(self._SUBS, {node, fn})
end

---Remove the function from this Signal's subscriptions. If it wasn't already
---subscribed, nothing happens.
---
---For example: `ball.exited_screen:unsubscribe(scoreboard.increase_score)`
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

		-- Explicitly checking for `false` here to catch non-Node tables that simply
		-- don't have an `is_alive`
		if node.is_alive == false then
			self:unsubscribe(fn)
		end
	end

	for _, sub in ipairs(self._SUBS) do
		local node, fn = sub[1], sub[2]

		-- Same here, see above comment
		if node.is_alive ~= false then
			fn(node, ...)
		end
	end
end

---Stall whichever async kernel's currently running until this signal fires.
---This is useful with the `async` module from the `batteries` library.
---
---CAUTION: Do not call this outside an async kernel, it'll hang!
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
