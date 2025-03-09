local gamera = require("lib.gamera.gamera")
local mathx = require("lib.batteries.mathx")
local Window = require("src.singleton.Window")

---A simplified wrapper around `gamera`. If you need to mess with internal state,
---access `Camera.gamera`.
---
---Note that the Camera's position is its center.
local Camera = {
	_smoothed_x = Window.half_screen_width,
	_smoothed_y = Window.half_screen_height,

	---If `true`, the Camera's position will be automatically rounded to the nearest
	---pixel when drawing.
	---This prevents misalignments when objects have non-integer positions.
	is_snapped_to_pixels = true,
	---The Camera's target x-position it'll try to look at. Doesn't necessarily
	---correspond to its actual current x-position; see `x` for that.
	-- target_x = 0,
	-- target_y = 0,
	x = Window.half_screen_width,
	y = Window.half_screen_height,
	scale = 1,
	rotation = 0,
	---Controls the speed at which  which the Camera smoothly approaches its destination
	---at (`x`, `y`). At `0`, it always stays in place, and at `1`, it always immediately
	---snaps to position.
	smoothing_speed = 0.1,
	---The Camera's viewing boundaries. It won't be able to view anything outside
	---its limits; if it tries to move past them, it snaps to them and stops.
	limit = {
		---The minimum `x` value the camera can look at. It won't be able to view anything
		---to the left of this x-position.
		left = -math.huge,
		---The minimum `y` value the camera can look at. It won't be able to view anything
		---above this y-position.
		top = -math.huge,
		---The maximum `x` value the camera can look at. It won't be able to view anything
		---to the right of this x-position.
		right = math.huge,
		---The maximum `y` value the camera can look at. It won't be able to view anything
		---below this y-position.
		bottom = math.huge,
	},
}

Camera.gamera = gamera.new(-math.huge, -math.huge, math.huge, math.huge)

function Camera:update(dt)
	-- local x, y = self.x + Window.screen_width, self.y + Window.screen_height
	local x, y = self.x, self.y

	x = mathx.clamp(
		x,
		self.limit.left + Window.half_screen_width,
		self.limit.right - Window.half_screen_width
	)

	y = mathx.clamp(
		y,
		self.limit.top + Window.half_screen_height,
		self.limit.bottom - Window.half_screen_height

	)

	self._smoothed_x = mathx.lerp(self._smoothed_x, x, self.smoothing_speed)
	self._smoothed_y = mathx.lerp(self._smoothed_y, y, self.smoothing_speed)

	local final_x = self._smoothed_x
	local final_y = self._smoothed_y

	if self.is_snapped_to_pixels then
		final_x, final_y = mathx.round(final_x), mathx.round(final_y)
	end

	-- if self.is_snapped_to_pixels then
	-- 	self.gamera:setPosition(mathx.round(camera_x), mathx.round(camera_y))
	-- else
	-- 	self.gamera:setPosition(self._smoothed_x, self._smoothed_y)
	-- end

	-- Not sure why I need these offsets to get what I'm expecting (the camera looks
	-- at 0,0 when its position is 0,0)
	self.gamera:setPosition(final_x + Window.screen_width, final_y + Window.screen_height)
	self.gamera:setScale(self.scale)
	self.gamera:setAngle(self.rotation)
	self.x, self.y = self._smoothed_x, self._smoothed_y
end

function Camera:draw(fn)
	self.gamera:draw(fn)
end

---Change all values of the Camera's boundaries at once. It won't be able to view
---to the left of `left`, above `top`, below `bottom`, or to the right of `right`.
---@param left number
---@param top number
---@param right number
---@param bottom number
function Camera:set_limit(left, top, right, bottom)
	self.limit.left = left
	self.limit.top = top
	self.limit.right = right
	self.limit.bottom = bottom
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
