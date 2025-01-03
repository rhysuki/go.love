local Hitbox = require("src.Hitbox")
---A barebones player character to extend from or drop into your game for instant
---interactivity.
---
---Moves freely in all directions like in a top-down RPG.
---See also BasePlayer2d.
---@class BasePlayerTopDown: Hitbox
---@overload fun(x: number?, y: number?, use_alt_graphics: boolean): BasePlayerTopDown
local BasePlayerTopDown = Hitbox:extend()

function BasePlayerTopDown:new(x, y, use_alt_graphics)
	if use_alt_graphics == nil then
		use_alt_graphics = false
	end

	BasePlayerTopDown.super.new(self, x, y, 13, 13, {"player"}, {"wall"})

	self.speed = 80
	self.debug_draw_mode = "line"
	self._facing_direction = "down"
	self._animation_table = use_alt_graphics and ANIMATIONS.player_alt or ANIMATIONS.player
	self._animation = self._animation_table.idle_down
end

function BasePlayerTopDown:update(dt)
	-- Move
	local move_x, move_y = INPUT:get("move")

	self.vx = move_x * self.speed * dt
	self.vy = move_y * self.speed * dt

	BasePlayerTopDown.super.update(self, dt)

	-- Update animations
	local state = (move_x == 0 and move_y == 0) and "idle" or "walk"
	local previous_animation = self._animation

	-- Play push animation, but only when colliding and not holding a diagonal direction
	if #self.collisions > 0 and (math.abs(move_x) + math.abs(move_y) <= 1) then
		state = "push"
	end

	if move_x ~= 0 or move_y ~= 0 then
		if move_x > 0 then
			self._facing_direction = "right"
		elseif move_x < 0 then
			self._facing_direction = "left"
		elseif move_y > 0 then
			self._facing_direction = "down"
		else
			self._facing_direction = "up"
		end
	end

	self._animation = self._animation_table[state .. "_" .. self._facing_direction]

	if self._animation ~= previous_animation then
		self._animation.data:gotoFrame(1)
	end
end

function BasePlayerTopDown:draw()
	self._animation:draw(self.x - 2, self.y - 2)
	BasePlayerTopDown.super.draw(self)
end

return BasePlayerTopDown
