---A few common colors, plus this particular project's palette of choice,
---Bubblegum 16. https://lospec.com/palette-list/bubblegum-16

local function color(r, g, b, a)
	return {love.math.colorFromBytes(r, g, b, a)}
end

return {
	white = {1, 1, 1, 1},
	black = {0, 0, 0, 1},
	gray = {0.5, 0.5, 0.5, 1},

	red = {1, 0, 0, 1},
	green = {0, 1, 0, 1},
	blue = {0, 0, 1, 1},

	cyan = {0, 1, 1, 1},
	magenta = {1, 0, 1, 1},
	yellow = {1, 1, 0, 1},

	b16_black = color(22, 23, 26, 255),
	b16_dark_red = color(127, 6, 34, 255),
	b16_red = color(214, 36, 17, 255),
	b16_orange = color(255, 132, 38, 255),

	b16_yellow = color(255, 209, 0, 255),
	b16_white = color(250, 253, 255, 255),
	b16_light_pink = color(255, 128, 164, 255),
	b16_pink = color(255, 38, 116, 255),
	b16_dark_pink = color(148, 33, 106, 255),
	b16_purple = color(67, 0, 103, 255),
	b16_dark_blue = color(35, 73, 117, 255),
	b16_light_blue = color(104, 174, 212, 255),
	b16_light_green = color(191, 255, 60, 255),
	b16_green = color(16, 210, 117, 255),
	b16_cyan = color(0, 120, 153, 255),
	b16_dark_cyan = color(0, 40, 89, 255),
}
