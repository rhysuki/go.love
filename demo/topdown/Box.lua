local Hitbox = require("src.Hitbox")
local BasePlayerTopDown = require("src.BasePlayerTopDown")
---@class Box: Hitbox
---@overload fun(x: number?, y: number?): Box
local Box = Hitbox:extend()

function Box:new(x, y)
	Box.super.new(self, x, y, 8, 8, {"wall", "box"}, {"player", "wall"})

	self.image = IMAGES.box

	self.on_hitbox_stay:subscribe(self, function(_, other, col)
		if other:is(BasePlayerTopDown) then
			self.x = self.x - col.normal.x * 0.5
			self.y = self.y - col.normal.y * 0.5
			self:move_and_collide()
		end
	end)
end

return Box
