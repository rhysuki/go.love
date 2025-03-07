local gamera = require("lib.gamera.gamera")
local mathx = require("lib.batteries.mathx")
local Window = require("src.singleton.Window")

---camera's position is its middle
local Camera = {
	_smoothed_x = 0,
	_smoothed_y = 0,

	is_snapped_to_pixels = true,
	-- is_smoothing_enabled = true,
	-- is_origin_at_top_left = false,
	x = Window.screen_width * 1.5,
	y = Window.screen_height * 1.5,
	scale = 1,
	rotation = 0,
	---Controls the speed at which  which the Camera smoothly approaches its destination
	---at (`x`, `y`). At `0`, it always stays in place, and at `1`, it always immediately
	---snaps to position.
	smoothing_speed = 0.1,
	limit_left = -math.huge,
	limit_up = -math.huge,
	limit_right = math.huge,
	limit_down = math.huge,
}

Camera.gamera = gamera.new(-math.huge, -math.huge, math.huge, math.huge)

function Camera:update(dt)
	-- self.gamera:setWorld(self.limit_left, self.limit_up, self.limit_right, self.limit_down)
	-- self.gamera:setPosition(self.x, self.y)

	local x, y = self.x, self.y

	x = mathx.clamp(x, self.limit_left, self.limit_right)
	y = mathx.clamp(y, self.limit_up, self.limit_down)

	-- if self.is_origin_at_top_left then
	-- 	x = x + Window.half_screen_width
	-- 	y = y + Window.half_screen_height
	-- end

	self._smoothed_x = mathx.lerp(self._smoothed_x, x, self.smoothing_speed)
	self._smoothed_y = mathx.lerp(self._smoothed_y, y, self.smoothing_speed)

	if self.is_snapped_to_pixels then
		-- x = mathx.round(x)
		-- y = mathx.round(y)
		self.gamera:setPosition(
			mathx.round(self._smoothed_x), mathx.round(self._smoothed_y)
		)
	else
		self.gamera:setPosition(self._smoothed_x, self._smoothed_y)
	end

	-- x, y
	-- mathx.lerp(self.gamera.x, self.x, self.smoothing_speed),
	-- mathx.lerp(self.gamera.y, self.y, self.smoothing_speed)
	self.gamera:setScale(self.scale)
	self.gamera:setAngle(self.rotation)
end

function Camera:draw(fn)
	self.gamera:draw(fn)
end

---Immediately set the Camera's position to the position it was smoothing toward.
---If `smoothing` is disabled (set to `1`), this does nothing.
function Camera:reset_smoothing()
	self._smoothed_x = self.x
	self._smoothed_y = self.y
end

---Convert screen coordinates to ingame coordinates. For example,
---`draw_circle(Camera:to_game_position(Window:get_mouse_position()))` always draws
---a circle in the middle of the screen.
---@param x number
---@param y number
---@return number, number
function Camera:to_game_position(x, y)
	return self.gamera:toWorld(x, y)
end

---Convert ingame coordinates to screen coordinates; check where exactly this position
---appears on the screen. For example, to check whether the player is on the left
---or right half of the screen:
---
---```lua
---local player_x, player_y = Camera:to_screen_position(player.x, player.y)
---if player_x < Window.half_screen_width then ...
---```
---@param x number
---@param y number
---@return number, number
function Camera:to_screen_position(x, y)
	return self.gamera:toScreen(x, y)
end

return Camera
