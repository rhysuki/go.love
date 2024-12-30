local Hitbox = require("src.Hitbox")
---@class BasePlayerTopDown: Hitbox
local BasePlayerTopDown = Hitbox:extend()

function BasePlayerTopDown:new(x, y)
	BasePlayerTopDown.super.new(self, x, y, 13, 13, {"player"}, {"wall"})

	-- If `false`, this player won't respond to inputs and will just stay idle.
	self.is_input_enabled = true
	self.speed = 80
	---@type "up" | "down" | "left" | "right"
	self.facing_direction = "down"
	self.debug_draw_mode = "line"
	self._animation = ANIMATIONS.player_idle_down
end

function BasePlayerTopDown:update(dt)
	local x, y = INPUT:get("move")
	local state = (x == 0 and y == 0) and "idle" or "walk"

	self.vx = x * self.speed * dt
	self.vy = y * self.speed * dt

	if x ~= 0 or y ~= 0 then
		if x > 0 then
			self.facing_direction = "right"
		elseif x < 0 then
			self.facing_direction = "left"
		elseif y > 0 then
			self.facing_direction = "down"
		else
			self.facing_direction = "up"
		end
	end

	BasePlayerTopDown.super.update(self, dt)
	self:set_animation(ANIMATIONS["player_" .. state .. "_" .. self.facing_direction])
end

function BasePlayerTopDown:draw()
	self._animation:draw(self.x - 2, self.y - 2)
	BasePlayerTopDown.super.draw(self)
end

function BasePlayerTopDown:set_animation(anim)
	local prev_anim = self._animation
	self._animation = anim

	if prev_anim ~= anim then
		self._animation.data:gotoFrame(1)
	end
end

return BasePlayerTopDown
