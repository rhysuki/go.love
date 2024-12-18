local colors = require("assets.data.collections.colors")
local push = require("lib.push.push")
local Window = require("src.singleton.Window")
local StarParticle = require("sample.StarParticle")
local StarCircle = require("sample.StarCircle")
local Logo = require("sample.Logo")
local Node = require("src.Node")
local SampleAnimation = Node:extend()

function SampleAnimation:new()
	SampleAnimation.super.new(self)
	push:setBorderColor(colors.b16_black)

	local star_circle = self:add_child(StarCircle())

	star_circle.animation_finished:subscribe(self, function()
		for i = 1, 5 do
			local vx = love.math.random() * 6 - 3
			local vy = love.math.random() * 6 - 3
			self:add_child(StarParticle(Window.half_screen_width, Window.half_screen_height, vx, vy))
		end

		self:add_child(Logo(Window.half_screen_width, Window.half_screen_height))
	end)
end

return SampleAnimation
