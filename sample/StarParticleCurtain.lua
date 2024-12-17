local timer = require("lib.hump.timer")
local Window = require("src.singleton.Window")
local StarParticle = require("sample.StarParticle")
local Node = require("src.Node")
local StarParticleCurtain = Node:extend()

function StarParticleCurtain:new()
	StarParticleCurtain.super.new(self)

	for i = 0, 15 do
		local x = Window.screen_width * (i / 15)

		timer.after(i / 30, function()
			self:add_child(StarParticle(x, -5))
		end)
	end
end

return StarParticleCurtain
