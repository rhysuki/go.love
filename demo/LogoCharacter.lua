local LogoCharacter = NODE:extend()

function LogoCharacter:new(x, y, char, delay)
	LogoCharacter.super.new(self, x, y)
	self._progress = 0
	self._char = char

	self.is_visible = false

	LIB.timer.after(delay or 0, function()
		self.is_visible = true
		self.y = self.y + 10

		LIB.timer.tween(0.5, self, {x = x, y = y, _progress = 1}, "out-back")
	end)
end

function LogoCharacter:draw()
	local color = COLORS.b16_pink

	LogoCharacter.super.draw(self)

	if self._progress < 0.2 or self._progress > 1.08 then
		color = COLORS.b16_white
	elseif self._progress < 0.5 or self._progress > 1.03 then
		color = COLORS.b16_light_pink
	end

	love.graphics.setColor(color)
	love.graphics.print(self._char, self.x, self.y)
	love.graphics.setColor(COLORS.white)
end

return LogoCharacter
