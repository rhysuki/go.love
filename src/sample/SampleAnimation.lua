local colors = require("assets.data.collections.colors")
local push = require("lib.push.push")
local Input = require("src.singleton.Input")
local Window = require("src.singleton.Window")
local Ripple = require("src.sample.Ripple")
local StarParticle = require("src.sample.StarParticle")
local Node = require("src.Node")
local SampleAnimation = Node:extend()

function SampleAnimation:new()
	SampleAnimation.super.new(self)
	push:setBorderColor(colors.b16_black)

	for i = 1, 5 do
		local vx = love.math.random() * 6 - 3
		local vy = love.math.random() * 6 - 3
		self:add_child(StarParticle(100, 100, vx, vy))
	end

	self:add_child(Ripple(100, 100))
end

function SampleAnimation:update(dt)
	SampleAnimation.super.update(self, dt)

	if Input:pressed("confirm") then
		self:add_child(StarParticle(Window:get_mouse_position()))
	end
end

function SampleAnimation:draw()
	SampleAnimation.super.draw(self)
end

return SampleAnimation
