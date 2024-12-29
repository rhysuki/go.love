local Ripple = NODE:extend()

function Ripple:new(x, y)
	Ripple.super.new(self, x, y)
	self._radius = 0
	self._line_width = 8
	self._tween = LIB.timer.tween(
		0.5,
		self,
		{_radius = 40, _line_width = 0},
		"out-circ",
		function() self:die() end
	)
end

function Ripple:draw()
	Ripple.super.draw(self)

	if self._radius < 10 then
		love.graphics.setColor(COLORS.b16_white)
	else
		love.graphics.setColor(COLORS.b16_pink)
	end

	love.graphics.setLineWidth(self._line_width)
	love.graphics.circle("line", self.x, self.y, self._radius)
	love.graphics.setLineWidth(1)
	love.graphics.setColor(COLORS.white)
end

return Ripple
