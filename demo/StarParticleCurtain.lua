local StarParticle = require("demo.StarParticle")
local StarParticleCurtain = NODE:extend()

function StarParticleCurtain:new(x, y)
	StarParticleCurtain.super.new(self, x, y)

	for i = 0, 15 do
		LIB.timer.after(i / 30, function()
			self:add_child(StarParticle(self.x + WINDOW.screen_width * (i / 15), self.y - 5))
		end)
	end
end

return StarParticleCurtain
