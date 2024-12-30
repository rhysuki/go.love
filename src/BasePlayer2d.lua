local Hitbox = require("src.Hitbox")
---@class BasePlayer2d: Hitbox
---@overload fun(x: number?, y:number?): BasePlayer2d
local BasePlayer2d = Hitbox:extend()

function BasePlayer2d:new(x, y)
	BasePlayer2d.super.new(self, x, y, 8, 13, {"player"}, {"wall"})

	self.speed = 150
	self.debug_draw_mode = "line"
	self._is_flipped = false
	self._gravity = 12
	self._jump_velocity = -5
	self._animation = ANIMATIONS.player_idle
end

function BasePlayer2d:update(dt)
	-- Move
	local move_x = INPUT:get("move")

	self.vx = self.speed * move_x * dt
	self.vy = self.vy + self._gravity * dt

	-- Jump
	if self.is_grounded and INPUT:pressed("confirm") then
		self.vy = self._jump_velocity
	end

	self:move_and_collide()

	-- Update animations
	if self.is_grounded then
		self._animation = move_x == 0 and ANIMATIONS.player_idle or ANIMATIONS.player_run
	else
		self._animation = self.vy < 0 and ANIMATIONS.player_jump or ANIMATIONS.player_fall
	end

	if move_x ~= 0 then
		self._is_flipped = move_x < 0
	end
end

function BasePlayer2d:draw()
	local scale = self._is_flipped and -1 or 1
	local x_offset = self._is_flipped and 16 or 0
	self._animation:draw(self.x - 4 + x_offset, self.y - 3, 0, scale, 1)
	BasePlayer2d.super.draw(self)
end

return BasePlayer2d
