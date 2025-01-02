local Ripple = NODE:extend()

function Ripple:new(x, y, color, target_radius, line_width)
	Ripple.super.new(self, x, y)
	self._color = color or COLORS.b16_pink
	self._radius = 0
	self._target_radius = target_radius or 40
	self._line_width = line_width or 8
	self._tween = LIB.timer.tween(
		0.5,
		self,
		{_radius = self._target_radius, _line_width = 0},
		"out-circ",
		function() self:die() end
	)
end

function Ripple:draw()
	Ripple.super.draw(self)

	if self._radius < self._target_radius / 4 then
		love.graphics.setColor(COLORS.b16_white)
	else
		love.graphics.setColor(self._color)
	end

	love.graphics.setLineWidth(self._line_width)
	love.graphics.circle("line", self.x, self.y, self._radius)
	love.graphics.setLineWidth(1)
	love.graphics.setColor(COLORS.white)
end

return Ripple
