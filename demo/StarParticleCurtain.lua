local StarParticle = require("demo.StarParticle")
local StarParticleCurtain = NODE:extend()

function StarParticleCurtain:new()
	StarParticleCurtain.super.new(self)

	for i = 0, 15 do
		LIB.timer.after(i / 30, function()
			self:add_child(StarParticle(WINDOW.screen_width * (i / 15), -5))
		end)
	end
end

return StarParticleCurtain
