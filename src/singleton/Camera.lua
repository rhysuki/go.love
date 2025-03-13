local gamera = require("lib.gamera.gamera")
local mathx = require("lib.batteries.mathx")
local Window = require("src.singleton.Window")

---A simplified wrapper around `gamera`. By setting `x`, `y`, `scale` and `rotation`,
---you can make the screen "look" at things. You can finetune it with `smoothing`,
---`limit`, and `offset_x`/`offset_y`. Shake it with `shake()`.
---
---Note that the Camera is centered; setting the Camera's position to (`0`, `0`)
---will show the game's origin point in the middle of the screen.
local Camera = {
	_smoothed_x = Window.half_screen_width,
	_smoothed_y = Window.half_screen_height,
	_shake_intensity = 0,
	_shake_duration = 0,
	_max_shake_duration = 0,

	---If `true`, the Camera's position will be automatically rounded to the nearest
	---pixel when drawing.
	---This prevents misalignments when objects have non-integer positions.
	is_snapped_to_pixels = true,
	x = Window.half_screen_width,
	y = Window.half_screen_height,
	---The Camera's relative x offset, useful for looking slightly around its current
	---position without having to modify it. Note that offsets can make the Camera
	---look past the limit defined in `limit`.
	offset_x = 0,
	---The Camera's relative y offset, useful for looking slightly around its current
	---position without having to modify it. Note that offsets can make the Camera
	---look past the limit defined in `limit`.
	offset_y = 0,
	scale = 1,
	rotation = 0,
	---Controls how smoothly the Camera approaches its destination at (`x`, `y`).
	---At `0`, smoothing is disabled, and it always immediately snaps into place.
	---At `1`, it takes so long to speed up that it never moves.
	smoothing = 0,
	---The Camera's viewing boundaries. It won't be able to view anything outside
	---its limits; if it tries to move past them, it snaps to them and stops.
	limit = {
		---The minimum `x` value the camera can look at. It won't be able to view anything
		---to the left of this x-position (unless you use offsets).
		left = -math.huge,
		---The minimum `y` value the camera can look at. It won't be able to view anything
		---above this y-position (unless you use offsets).
		top = -math.huge,
		---The maximum `x` value the camera can look at. It won't be able to view anything
		---to the right of this x-position (unless you use offsets).
		right = math.huge,
		---The maximum `y` value the camera can look at. It won't be able to view anything
		---below this y-position (unless you use offsets).
		bottom = math.huge,
	},
}

Camera.gamera = gamera.new(-math.huge, -math.huge, math.huge, math.huge)

---Clamp the Camera's position to its limits, smooth and snap it to pixels if applicable,
---and update `x` and `y` to its new position.
---@param dt number
function Camera:update(dt)
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

	self._smoothed_x = mathx.lerp_eps(self._smoothed_x, x, 1 - self.smoothing, 0.01)
	self._smoothed_y = mathx.lerp_eps(self._smoothed_y, y, 1 - self.smoothing, 0.01)

	local final_x = self._smoothed_x
	local final_y = self._smoothed_y

	if self.is_snapped_to_pixels then
		final_x, final_y = mathx.round(final_x), mathx.round(final_y)
	end

	if self._shake_duration > 0 then
		self._shake_duration = self._shake_duration - dt

		local angle = math.rad(love.math.random() * 360)
		local progress = self._shake_duration / self._max_shake_duration
		-- `progress * progress` makes a slightly smoother curve than just `progress`
		local intensity = self._shake_intensity * progress * progress

		final_x = final_x + math.cos(angle) * intensity
		final_y = final_y + math.sin(angle) * intensity
	end

	-- Not sure why I need these screen offsets to get the camera to look at (0, 0)
	-- when its position is (0, 0)
	self.gamera:setPosition(
		final_x + Window.screen_width + self.offset_x,
		final_y + Window.screen_height + self.offset_y
	)
	self.gamera:setScale(self.scale)
	self.gamera:setAngle(self.rotation)
	self.x, self.y = self._smoothed_x, self._smoothed_y
end

function Camera:draw(fn)
	self.gamera:draw(fn)
end

---Change all values of the Camera's boundaries at once. It won't be able to view
---to the left of `left`, above `top`, below `bottom`, or to the right of `right`,
---unless it's offset with `offset_x`/`offset_y` or shaken with `shake()`.
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
---If `smoothing` is disabled (set to `0`), this does nothing.
function Camera:reset_smoothing()
	self._smoothed_x = self.x
	self._smoothed_y = self.y
end

---Convert screen coordinates to ingame coordinates. For example, to draw a circle
---that's always in the middle of the screen:
---
---```lua
---local cx, cy = Camera:to_game_position(Window.half_screen_width, Window.half_screen_height)
---love.graphics.circle("fill", cx, cy, 100)
---```
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

---Shake the camera around at `intensity` pixels off-center for `duration` seconds.
---The intensity of the shake decreases smoothly until it stops.
---
---Note that shaking can make the Camera look outside its limit defined in `limit`.
---@param intensity number
---@param duration number
function Camera:shake(intensity, duration)
	self._shake_intensity = intensity
	self._max_shake_duration = duration
	self._shake_duration = duration
end

return Camera
