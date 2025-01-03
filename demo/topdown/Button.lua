local Hitbox = require("src.Hitbox")
local Ripple = require("demo.Ripple")
---@class Button: Hitbox
---@overload fun(x: number?, y: number?): Button
local Button = Hitbox:extend()

function Button:new(x, y)
	Button.super.new(self, x, y, 8, 8, {}, {"box"})

	self.activated = SIGNAL()
	self.image = IMAGES.button_off
	self._has_activated = false

	self.on_hitbox_stay:subscribe(self, function(_, other)
		if LIB.batteries.mathx.distance(self.x, self.y, other.x, other.y) < 3 then
			other.x = x
			other.y = y
			other.collision_mask = {}

			if not self._has_activated then
				self._has_activated = true
				self.activated:emit()
			end
		end
	end)
end

return Button
