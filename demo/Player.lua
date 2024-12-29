local help = require("demo.help")
local Player = NODE:extend()

function Player:new()
	self.super.new(self)
	self._animation = ANIMATIONS.player_run
	self.x = -18
	self.y = WINDOW.screen_height - 16

	self._has_jumped = false
	self._vy = 0
end

function Player:update(dt)
	self.super.update(self, dt)

	self.x = self.x + dt * 60 * 2
	self.y = self.y + self._vy

	if self.x > WINDOW.screen_width * 0.5 and not self._has_jumped then
		self._vy = -3.5
		self._animation = ANIMATIONS.player_jump
		self._has_jumped = true
		help.sounds.jump:play()
	end

	if self._has_jumped then
		self._vy = self._vy + dt * 60 * 0.1
	end
end

function Player:draw()
	self.super.draw(self)
	self._animation:draw(self.x, self.y)
end

return Player
