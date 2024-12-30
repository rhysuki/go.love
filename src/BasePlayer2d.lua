local Hitbox = require("src.Hitbox")
---@class BasePlayer2d: Hitbox
local BasePlayer2d = Hitbox:extend()

function BasePlayer2d:new(x, y)
	BasePlayer2d.super.new(self, x, y, 8, 13, {"player"}, {"wall"})

	-- If `false`, this player won't respond to inputs and will just stay idle.
	self.is_input_enabled = true
	self.speed = 150
	---@type "right" | "left"
	self.facing_direction = "right"
	self.debug_draw_mode = "line"
	self._gravity = 12
	self._jump_velocity = -5
	self._animation = ANIMATIONS.player_idle_right
end

function BasePlayer2d:update(dt)
	local x = self.is_input_enabled and INPUT:get("move") or 0

	if x > 0 then
		x = 1
	elseif x < 0 then
		x = -1
	end

	self.vx = x * self.speed * dt
	self.vy = self.vy + self._gravity * dt

	if self.is_grounded and INPUT:pressed("confirm") and self.is_input_enabled then
		self.vy = self._jump_velocity
		SOUNDS.select2:play()
	end

	BasePlayer2d.super.update(self, dt)

	if x ~= 0 then
		self.facing_direction = x > 0 and "right" or "left"
	end

	if self.is_grounded then
		self._animation = self.vx ~= 0 and ANIMATIONS.player_run or ANIMATIONS.player_idle_right
	else
		self._animation = self.vy < 0 and ANIMATIONS.player_jump or ANIMATIONS.player_fall
	end
end

function BasePlayer2d:draw()
	local flip = self.facing_direction ~= "right"
	self._animation:draw(self.x - 4 + (flip and 16 or 0), self.y - 3, 0, flip and -1 or 1, 1)
	BasePlayer2d.super.draw(self)
end

return BasePlayer2d
