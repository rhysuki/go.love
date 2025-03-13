local help = require("demo.help")
local Ripple = require("demo.Ripple")
local LogoCharacter = require("demo.LogoCharacter")
local LogoText = require("demo.LogoText")
local StarParticle = require("demo.StarParticle")
local StarParticleCurtain = require("demo.StarParticleCurtain")
local Logo = NODE:extend()

function Logo:new(x, y)
	x = x or WINDOW.half_screen_width
	y = y or WINDOW.half_screen_height
	Logo.super.new(self, x, y)

	local logo_characters = self:add_child(NODE())
	local letters = {"r", "h", "y", "s", "u", "k", "i"}

	for i = 0, 3 do
		local char_x = x - 2
		local char_y = y - 10
		local delay = i / 20
		logo_characters:add_child(LogoCharacter(char_x + i * 4, char_y, letters[i + 4], delay))
		logo_characters:add_child(LogoCharacter(char_x - i * 4, char_y, letters[4 - i], delay))
	end

	for _ = 1, 5 do
		local vx = love.math.random() * 6 - 3
		local vy = love.math.random() * 6 - 3
		self:add_child(StarParticle(x, y, vx, vy))
	end

	self:add_child(Ripple(self.x, self.y))
	help.sounds.explosion:play()

	LIB.timer.after(1, function()
		logo_characters:die()
		self:add_child(StarParticleCurtain(self.x - WINDOW.half_screen_width, self.y - WINDOW.half_screen_height))
		self:add_child(LogoText(self.x - 14, self.y - 10))
		help.sounds.jingle:play()
	end)
end

return Logo
