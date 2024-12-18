local timer = require("lib.hump.timer")
local Window = require("src.singleton.Window")
local StarParticle = require("sample.StarParticle")
local Node = require("src.Node")
local StarParticleCurtain = Node:extend()

function StarParticleCurtain:new()
	StarParticleCurtain.super.new(self)

	for i = 0, 15 do
		timer.after(i / 30, function()
			self:add_child(StarParticle(Window.screen_width * (i / 15), -5))
		end)
	end
end

return StarParticleCurtain
