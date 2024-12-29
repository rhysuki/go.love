local LogoText = NODE:extend()

function LogoText:new(x, y)
	self.super.new(self, x, y)

	self._progress = 0
	self._pink = {unpack(COLORS.b16_pink)}
	self._dark_pink = {unpack(COLORS.b16_dark_pink)}
	self._star = love.graphics.newImage("demo/assets/small_star.png")

	LIB.timer.tween(0.5, self, {_progress = 1}, "out-back")
end

function LogoText:update(dt)
	self.super.update(self, dt)

	-- Update alpha
	self._pink[4] = self._progress
	self._dark_pink[4] = self._progress
end

function LogoText:draw()
	self.super.draw(self)

	love.graphics.setColor(self._pink)
	love.graphics.draw(self._star, self.x + 7 - self._progress * 13, self.y + 6)

	love.graphics.setColor(self._dark_pink)
	love.graphics.printf(
		"Love-Godot Template\nv" .. DEBUG.version,
		self.x - 37,
		self.y + self._progress * 10,
		100,
		"center"
	)

	love.graphics.setColor(COLORS.b16_pink)
	love.graphics.print("rhysuki", self.x + self._progress * 4, self.y)
	love.graphics.setColor(COLORS.white)
end

return LogoText
