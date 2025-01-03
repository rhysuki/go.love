local Hitbox = require("src.Hitbox")
local BasePlayerTopDown = require("src.BasePlayerTopDown")
---Example of using collision masks/layers to control collisions
---@class Box: Hitbox
---@overload fun(x: number?, y: number?): Box
local Box = Hitbox:extend()

function Box:new(x, y)
	-- This is a "wall" and a "box" and it collides with "player"s and "wall"s
	Box.super.new(self, x, y, 8, 8, {"wall", "box"}, {"player", "wall"})

	self.image = IMAGES.box

	self.on_hitbox_stay:subscribe(self, function(_, other, col)
		-- On collision, if it's colliding with a player, get pushed in the
		-- direction opposite to the collision
		-- (e.g., if the collision is on the left, move to the right)
		if other:is(BasePlayerTopDown) then
			self.x = self.x - col.normal.x * 0.5
			self.y = self.y - col.normal.y * 0.5
			self:move_and_collide()
		end
	end)
end

return Box
