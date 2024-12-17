local colors = require("assets.data.collections.colors")
local push = require("lib.push.push")
local Input = require("src.singleton.Input")
local Window = require("src.singleton.Window")
local Ripple = require("sample.Ripple")
local StarParticle = require("sample.StarParticle")
local StarCircle = require("sample.StarCircle")
local StarTrail = require("sample.StarTrail")
local Logo = require("sample.Logo")
local Node = require("src.Node")
local SampleAnimation = Node:extend()

local w2 = math.floor(Window.screen_width / 2)
local h2 = math.floor(Window.screen_height / 2)

function SampleAnimation:new()
	SampleAnimation.super.new(self)
	push:setBorderColor(colors.b16_black)

	local star_circle = self:add_child(StarCircle())

	star_circle.animation_finished:subscribe(self, function()
		for i = 1, 5 do
			local vx = love.math.random() * 6 - 3
			local vy = love.math.random() * 6 - 3
			self:add_child(StarParticle(w2, h2, vx, vy))
		end

		self:add_child(Ripple(w2, h2))
		self:add_child(Logo(w2, h2))
	end)
end

function SampleAnimation:update(dt)
	SampleAnimation.super.update(self, dt)

	-- if Input:pressed("confirm") then
	-- 	self:add_child(StarParticle(Window:get_mouse_position()))
	-- end
end

function SampleAnimation:draw()
	SampleAnimation.super.draw(self)

	-- love.graphics.line(w2, 0, w2, 1000)
	-- love.graphics.line(0, h2, 1000, h2)
end

return SampleAnimation
