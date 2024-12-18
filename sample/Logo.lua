local timer = require("lib.hump.timer")
local LogoCharacter = require("sample.LogoCharacter")
local LogoText = require("sample.LogoText")
local StarParticleCurtain = require("sample.StarParticleCurtain")
local Node = require("src.Node")
local Logo = Node:extend()

function Logo:new(x, y)
	Logo.super.new(self, x, y)

	local logo_characters = self:add_child(Node())
	local letters = {"r", "h", "y", "s", "u", "k", "i"}

	for i = 0, 3 do
		local char_x = x - 2
		local char_y = y - 10
		local delay = i / 20
		logo_characters:add_child(LogoCharacter(char_x + i * 4, char_y, letters[i + 4], delay))
		logo_characters:add_child(LogoCharacter(char_x - i * 4, char_y, letters[4 - i], delay))
	end

	timer.after(1, function()
		logo_characters:die()
		self:add_child(StarParticleCurtain())
		self:add_child(LogoText(self.x - 14, self.y - 10))
		love.audio.newSource("sample/assets/jingle.ogg", "static"):play()
	end)

	love.audio.newSource("sample/assets/explosion.ogg", "static"):play()
end

function Logo:update(dt)
	Logo.super.update(self, dt)
end

function Logo:draw()
	Logo.super.draw(self)
end

return Logo
