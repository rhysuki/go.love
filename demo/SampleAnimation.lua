local colors = require("assets.data.collections.colors")
local push = require("lib.push.push")
local timer = require("lib.hump.timer")
local Window = require("src.singleton.Window")
local StarParticle = require("demo.StarParticle")
local StarCircle = require("demo.StarCircle")
local Logo = require("demo.Logo")
local Player = require("demo.Player")
local Node = require("src.Node")
local SampleAnimation = Node:extend()

function SampleAnimation:new()
	SampleAnimation.super.new(self)

	local star_circle = self:add_child(StarCircle())

	star_circle.died:subscribe(self, function()
		for _ = 1, 5 do
			local vx = love.math.random() * 6 - 3
			local vy = love.math.random() * 6 - 3
			self:add_child(StarParticle(Window.half_screen_width, Window.half_screen_height, vx, vy))
		end

		self:add_child(Logo(Window.half_screen_width, Window.half_screen_height))

		timer.after(2.0, function() self:add_child(Player()) end)
	end)
end

return SampleAnimation
