local help = require("demo.help")
local Logo = require("demo.Logo")
local Background = require("demo.camera.Background")
local Twinkle = require("demo.camera.Twinkle")
---@class CameraDemo: Node
local CameraDemo = NODE:extend()

function CameraDemo:new()
	CameraDemo.super.new(self)

	self.overlay_color = {1, 1, 1, 1}
	self:add_child(Background())
	self.twinkle = self:add_child(Twinkle(WINDOW.half_screen_width, -32))
	self.twinkle.y = -WINDOW.half_screen_height - 30

	local duration = 9

	LIB.timer.after(2, function()
		LIB.timer.tween(2, self.overlay_color, {1, 1, 1, 0}, "out-circ", function()
			LIB.timer.tween(6, self.twinkle, {y = 0}, "out-sine")

			LIB.timer.after(1, function()
				LIB.timer.tween(duration, CAMERA, {y = WINDOW.half_screen_height + 650}, "in-out-sine")
			end)

			LIB.timer.after(duration + 1, function()
				CAMERA:shake(5, 0.5)
				self.twinkle.cycle_palette = true

				LIB.timer.after(1.5, function()
					CAMERA:shake(5, 0.5)
					self.twinkle:die()
					self:add_child(Logo(CAMERA.x, CAMERA.y))

					LIB.timer.after(4, function()
						self.overlay_color = {0, 0, 0, 0}
						LIB.timer.tween(2, self.overlay_color, {0, 0, 0, 1}, "out-circ")
					end)
				end)
			end)
		end)
	end)

	-- LIB.timer.after(duration + 2.5, function()
	-- 	CAMERA:shake(5, 0.5)
	-- 	self.twinkle:die()
	-- 	self:add_child(Logo(CAMERA.x, CAMERA.y))
	-- end)

	WINDOW.shaders.limit_colors:send("palette", IMAGES.palette_bubblegum_16)
end

function CameraDemo:update(dt)
	CameraDemo.super.update(self, dt)
end

function CameraDemo:draw()
	CameraDemo.super.draw(self)

	love.graphics.setColor(self.overlay_color)
	love.graphics.rectangle(
		"fill",
		CAMERA.x - WINDOW.half_screen_width,
		CAMERA.y - WINDOW.half_screen_height,
		WINDOW.screen_width,
		WINDOW.screen_height
	)
	love.graphics.setColor(COLORS.white)
end

return CameraDemo
