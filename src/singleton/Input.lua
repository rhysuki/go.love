local baton = require("lib.baton.baton")

---An instance of baton with some common defaults for easy prototyping.
---
---For example: To check whether the left mouse button just got pressed, do
---`if input:pressed("confirm") then ...`.
---
---Actions:
---Left/right/up/down (movement): Arrow keys, WASD, IJKL and left gamepad stick
---Confirm/cancel/menu (actions): Z/X/C, N/M/,, A/B/Start, left/right click
---Control modifier: Shift keys, gamepad shoulder buttons
return baton.new({
	controls = {
		left = {"key:left", "key:a", "key:j", "axis:leftx-"},
		right = {"key:right", "key:d", "key:l", "axis:leftx+"},
		up = {"key:up", "key:w", "key:i", "axis:lefty-"},
		down = {"key:down", "key:s", "key:k", "axis:lefty+"},

		confirm = {"key:z", "key:n", "button:a", "mouse:1"},
		cancel = {"key:x", "key:m", "button:b", "mouse:2"},
		menu = {"key:c", "key:,", "button:start", "mouse:3"},

		modifier = {"key:lshift", "key:rshift", "button:leftshoulder", "button:rightshoulder"},

		debug_restart = {"key:r"},
		debug_quit = {"key:q"},
		debug_decrease_window_size = {"key:1"},
		debug_increase_window_size = {"key:2"},
		debug_enable_debug_mode = {"key:lctrl", "key:rctrl"},
	},

	pairs = {
		move = {"left", "right", "up", "down"},
	},

})
