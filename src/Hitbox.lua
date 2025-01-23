local moses = require("lib.moses.moses")
local bump = require("lib.bump.bump")
local colors = require("assets.data.collections.colors")
local Debug = require("src.singleton.Debug")
local Signal = require("src.Signal")
local Node = require("src.Node")
---A Node wrapper around `bump`. A Hitbox's "collision layers" are the layers it
---exists in, and its "collision masks" are the layers it looks for when checking
---for collisions.
---
---Hitboxes WON'T collide with anything or update their internal state until you
---call `move_and_collide()`. However, they'll always emit their Signals.
---@class Hitbox : Node
---@overload fun(x: number, y: number, width: number, height: number, collision_layers: string[], collision_mask: string[], is_area: boolean?): Hitbox
local Hitbox = Node:extend()

-- The physics world shared by all Hitboxes.
local world = bump.newWorld()

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
	-- Hitbox and a table with information about the collision.
	self.on_hitbox_entered = Signal()
	-- Fires every frame this Hitbox is colliding with another. Gets passed the
	-- collided Hitbox and a table with information about the collision.
	self.on_hitbox_stay = Signal()
	-- Fires when this Hitbox stops colliding with another. Gets passed the collided
	-- Hitbox and a table with information about the collision.
	self.on_hitbox_exited = Signal()

	-- If `true`, this Hitbox will generate collision events (entered, exit) but
	-- won't physically stop anything. Other Hitboxes will phase through it.
	self.is_area = is_area or false
	---If `true`, this Hitbox will call `move_and_collide()` automatically every
	---frame.  Useful to disable if you want finer grained control over when exactly
	---to move and collide.
	self.is_auto_update_enabled = true
	---This is `true` if this Hitbox collided with a floor the last time
	---`move_and_collide()` was called, `false` otherwise.
	self.is_grounded = false
	---This Hitbox's X velocity. On `move_and_collide()`, this is added to `x`.
	self.vx = 0
	---This Hitbox's Y velocity. On `move_and_collide()`, this is added to `y`.
	self.vy = 0
	-- The width of this Hitbox. Updating this won't change the collision detection,
	-- use `set_dimensions()` for that.
	self.width = width
	-- The height of this Hitbox. Updating this won't change the collision detection,
	-- use `set_dimensions()` for that.
	self.height = height
	-- A sequence of all collisions that happened the last time `move_and_collide()`
	-- was called.
	-- Unlike the `on_hitbox` Signals, these are full information tables, with things
	-- like collision normals, touch points, etc.
	--
	-- See: https://github.com/kikito/bump.lua?tab=readme-ov-file#collision-info
	self.collisions = {}
	-- A table of strings representing which layers this Hitbox belongs to. This
	-- is purely for when other things check whether they should collide with this.
	self.collision_layers = collision_layers
	-- A table of strings representing which layers this Hitbox checks for when
	-- colliding.
	self.collision_mask = collision_mask
	-- The color used for drawing this hitbox, when `Debug.is_enabled` and
	-- `Debug.draw_hiboxes` are both `true`.
	-- Defaults to cyan for regular Hitboxes and yellow for area Hitboxes.
	self.debug_color = self.is_area and {unpack(colors.yellow)} or {unpack(colors.cyan)}
	self.debug_draw_mode = "line"

	-- Tables to keep track of the objects this Hitbox collided with between frames,
	-- to know when to call `on_hitbox_entered` and `on_hitbox_exited`.

	-- Tables with tables as keys, to keep track of which objects this Hitbox collided
	-- with between frames, for `on_hitbox_entered` and `on_hitbox_exited`.
	self._cols = {}
	self._previous_cols = {}
	self._world = world

	self._world:add(self, self.x, self.y, self.width, self.height)
	self.debug_color[4] = 0.75
end

function Hitbox:update(dt)
	Hitbox.super.update(self, dt)

	if self.is_auto_update_enabled then
		self:move_and_collide()
	end
end

function Hitbox:draw()
	Hitbox.super.draw(self)

	if Debug.is_enabled and Debug.draw_hitboxes then
		love.graphics.setColor(self.debug_color)
		love.graphics.rectangle(self.debug_draw_mode, self._world:getRect(self))
		love.graphics.setColor(colors.white)
	end
end

function Hitbox:die()
	Hitbox.super.die(self)
	self._world:remove(self)
end

---Teleport to this position without any collision checking.
---To move WITH collision, use `move_and_collide()`.
---@param x number
---@param y number
function Hitbox:set_position(x, y)
	self.x = x
	self.y = y
	self:_update_properties()
end

---Change `width` and `height`. This also updates the collision detection box's
---dimensions.
---@param width number
---@param height number
function Hitbox:set_dimensions(width, height)
	self.width = width
	self.height = height
	self:_update_properties()
end

---Move this Hitbox according to its position and velocity. If it finds another
---Hitbox with at least one collision layer that matches this Hitbox's mask, it
---collides, updates internal state like `self.collisions`, and fires relevant Signals.
function Hitbox:move_and_collide()
	if not self.is_alive then return end

	local x, y, cols = self._world:move(self, self.x + self.vx, self.y + self.vy, filter)
	self.x, self.y = x, y
	self.collisions = cols
	self.is_grounded = false
	self._previous_cols = self._cols
	self._cols = {}


	-- Update col tables, fire signals
	for _, col in ipairs(self.collisions) do
		self._cols[col.other] = col

		if not self._previous_cols[col.other] then
			self.on_hitbox_entered:emit(col.other, col)

			if col.other:can_collide_with(self) then
				col.other.on_hitbox_entered:emit(self, col)
			end
		end

		self.on_hitbox_stay:emit(col.other, col)

		if col.other:can_collide_with(self) then
			col.other.on_hitbox_stay:emit(self, col)
		end

		if col.normal.x ~= 0 then
			self.vx = 0
		end

		if col.normal.y ~= 0 then
			self.vy = 0
		end

		if col.normal.y == -1 then
			self.is_grounded = true
		end
	end

	for col in pairs(self._previous_cols) do
		if not self._cols[col] then
			local other = self._previous_cols[col].other
			self.on_hitbox_exited:emit(other, col)

			if other:can_collide_with(self) then
				other.on_hitbox_exited:emit(self, col)
			end
		end
	end
end

---Check if this Hitbox is compatible with `other`; if its layers match with this
---mask and if both are alive.
---This is mostly used internally, in the filter for `self.world:move()`.
---@param other table
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
	self._world:update(self, self.x, self.y, self.width, self.height)
end

return Hitbox
