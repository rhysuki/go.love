local push = require("lib.push.push")

---A helper singleton to to mess with window state. `width` and `height` are the
---dimensions of the "real" window on the monitor, while `screen_width` and
---`screen_height` are the dimensions of the "virtual" in-game world viewport.
local Window = {
	scale = 1,
	width = 0,
	height = 0,
	-- Change these two fields to change the base resolution of the game
	screen_width = 256,
	screen_height = 192,

	---The global shaders that're always loaded and get applied at the end of a
	---frame. Since shader creation relies on graphics being loaded, these are only
	---initialized on `Window:setup()`.
	---@type {[string]: love.Shader?}
	shaders = {
		limit_colors = nil,
		palette_swap = nil,
	}
}

Window.half_screen_width = Window.screen_width / 2
Window.half_screen_height = Window.screen_height / 2

---@param scale integer?
function Window:setup(scale)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")

	self.scale = scale or self.scale
	self:_update_window_size()

	push:setupScreen(
		self.screen_width,
		self.screen_height,
		self.width,
		self.height,
		{
			resizable = false,
			pixelperfect = true,
			canvas = true
		}
	)

	-- Require and create fonts AFTER setting up graphics state
	local fonts = require("assets.data.collections.fonts")
	love.graphics.setFont(fonts.default)

	self.shaders.limit_colors = love.graphics.newShader("src/shader/limit_colors.frag")
	self.shaders.palette_swap = love.graphics.newShader("src/shader/palette_swap.frag")

	-- These shaders are loaded by default but won't do anything until you send
	-- them uniforms
	push:setShader({
		self.shaders.limit_colors,
		self.shaders.palette_swap,
		-- Somehow, for some obscure reason, the last shader in this table is
		-- getting applied twice. This works around it by making the last shader
		-- do nothing at all, twice. I feel tested
		love.graphics.newShader("src/shader/nothing.frag"),
	})
end

---Change the window's size to an integer scale multiple of the base resolution.
---@param n integer
function Window:resize(n)
	if n < 1 then n = 1 end
	if n == self.scale then return end

	self.scale = n
	self:_update_window_size()
	push:resize(self.width, self.height)
	love.window.setMode(self.width, self.height)
end

---@return number
---@return number
function Window:get_mouse_position()
	local x, y = love.mouse.getPosition()
	return x / self.scale, y / self.scale
end

function Window:_update_window_size()
	self.width = self.screen_width * self.scale
	self.height = self.screen_height * self.scale
end

return Window
