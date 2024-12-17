local fonts = {
	small = love.graphics.newFont("assets/fonts/m3x6.ttf", 16, "mono"),
	regular = love.graphics.newFont("assets/fonts/m5x7.ttf", 16, "mono"),
	big = love.graphics.newFont("assets/fonts/m6x11.ttf", 16, "mono"),
}

fonts.small:setLineHeight(0.7)

return fonts
