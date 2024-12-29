local help = require("demo.help")
local StarTrail = require("demo.StarTrail")
local StarCircle = NODE:extend()

function StarCircle:new()
	self.super.new(self)

	self._radius = 170
	self._star_amount = 5
	self._rotation = 0
	self._star_trails = {}
	self._star = love.graphics.newImage("demo/assets/star.png")

	self.x = WINDOW.half_screen_width - 6
	self.y = WINDOW.half_screen_height - 3

	for i = 1, self._star_amount do
		table.insert(self._star_trails, self:add_child(StarTrail()))
	end

	LIB.timer.tween(
		1.5,
		self,
		{_rotation = 300, _radius = 0},
		"in-sine",
		function() LIB.timer.after(0.05, function() self:die() end) end
	)

	help.sounds.twinkle:play()
end

function StarCircle:update(dt)
	self.super.update(self, dt)
end

function StarCircle:draw()
	self.super.draw(self)

	for i = 1, self._star_amount do
		local angle = math.rad(((360 / self._star_amount) * (i - 1)) + self._rotation)
		self._star_trails[i].x = 6 + self.x + math.cos(angle) * self._radius
		self._star_trails[i].y = 2 + self.y + math.sin(angle) * self._radius
	end
end

return StarCircle
