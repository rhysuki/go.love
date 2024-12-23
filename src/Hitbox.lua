local moses = require("lib.moses.moses")
local bump = require("lib.bump.bump")
local colors = require("assets.data.collections.colors")
local Signal = require("src.Signal")
local Node = require("src.Node")
---A Node wrapper around `bump`. A Hitbox's "collision layers" are the layers it
---exists in, and its "collision masks" are the layers it looks for when moving.
---@class Hitbox : Node
---@overload fun(
---x: number, y: number,
---width: number, height: number,
---collision_layers: string[], collision_mask: string[],
---is_area: boolean?): Hitbox
local Hitbox = Node:extend()

---@param item table
---@param other table
---@return string?
local function filter(item, other)
	if not item:can_collide_with(other) then return end
	if item.is_area or other.is_area then return "cross" end
	return "slide"
end

function Hitbox:new(x, y, width, height, collision_layers, collision_mask, is_area)
	Hitbox.super.new(self, x, y)

	-- Fires when this Hitbox first collides with another. Gets passed the collided
	-- Hitbox.
	self.on_hitbox_entered = Signal()
	-- Fires every frame this Hitbox is colliding with another. Gets passed the
	-- collided Hitbox.
	self.on_hitbox_stay = Signal()
	-- Fires when this Hitbox stops colliding with another. Gets passed the collided
	-- Hitbox.
	self.on_hitbox_exited = Signal()

	-- If `true`, this Hitbox will generate collision events (entered, exit) but
	-- won't physically collide with anything.
	self.is_area = is_area or false
	-- The width of this Hitbox. Updating this won't change the collision detection,
	-- use `set_dimensions()` for that.
	self.width = width
	-- The height of this Hitbox. Updating this won't change the collision detection,
	-- use `set_dimensions()` for that.
	self.height = height
	-- A table of strings representing which layers this Hitbox belongs to. This
	-- is purely for when other things check whether they should collide with this.
	self.collision_layers = collision_layers
	-- A table of strings representing which layers this Hitbox checks for when
	-- colliding.
	self.collision_mask = collision_mask
	self.world = _G.TEST_WORLD

	-- Tables to keep track of the objects this Hitbox collided with between frames,
	-- to know when to call `on_hitbox_entered` and `on_hitbox_exited`.

	-- Tables with tables as keys, to keep track of which objects this Hitbox collided
	-- with between frames, for `on_hitbox_entered` and `on_hitbox_exited`.
	self._cols = {}
	self._previous_cols = {}

	self.world:add(self, self.x, self.y, self.width, self.height)
end

function Hitbox:update(dt)
	Hitbox.super.update(self, dt)
end

function Hitbox:draw()
	Hitbox.super.draw(self)

	love.graphics.setColor(colors.b16_green)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	love.graphics.setColor(colors.white)
end

function Hitbox:die()
	Hitbox.super.die(self)
	self.world:remove(self)
end

---Teleport to this position without any collision checking.
---To move WITH collision, set `x`/`y`, then call `move_and_collide()`.
---@param x number
---@param y number
function Hitbox:set_position(x, y)
	self.x = x
	self.y = y
	self:_update_properties()
end

---Change `width` and `height`, but also update the collision detection box's
---dimensions.
---@param width number
---@param height number
function Hitbox:set_dimensions(width, height)
	self.width = width
	self.height = height
	self:_update_properties()
end

---Move this Hitbox to its current position, with collision checking. If it finds
---another Hitbox with at least one collision layer that matches this Hitbox's
---mask, it collides and emits the according Signals.
function Hitbox:move_and_collide()
	if not self.is_alive then return end

	local x, y, cols = self.world:move(self, self.x, self.y, filter)
	self.x, self.y = x, y
	self._previous_cols = self._cols
	self._cols = {}

	for _, col in ipairs(cols) do
		self._cols[col.other] = true

		if not self._previous_cols[col.other] then
			self.on_hitbox_entered:emit(col.other)
		end

		self.on_hitbox_stay:emit(col.other)
	end

	for col in pairs(self._previous_cols) do
		if not self._cols[col] then
			self.on_hitbox_exited:emit(col)
		end
	end
end

---Check if this Hitbox is compatible with `other`; if its layers match with this
---mask and if both are alive.
---This is mostly used internally, in the filter for `self.world:move()`.
---@return boolean
function Hitbox:can_collide_with(other)
	if not self.is_alive or not other.is_alive then return false end

	for i = 1, #self.collision_mask do
		if moses.find(other.collision_layers, self.collision_mask[i]) then
			return true
		end
	end

	return false
end

function Hitbox:_update_properties()
	self.world:update(self, self.x, self.y, self.width, self.height)
end

return Hitbox
