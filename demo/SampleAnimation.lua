local StarParticle = require("demo.StarParticle")
local StarCircle = require("demo.StarCircle")
local Logo = require("demo.Logo")
local Player = require("demo.Player")
local SampleAnimation = NODE:extend()

function SampleAnimation:new()
	SampleAnimation.super.new(self)

	local star_circle = self:add_child(StarCircle())

	star_circle.died:subscribe(self, function()
		self:add_child(Logo(WINDOW.half_screen_width, WINDOW.half_screen_height))
		LIB.timer.after(2.0, function() self:add_child(Player()) end)
	end)
end

return SampleAnimation
