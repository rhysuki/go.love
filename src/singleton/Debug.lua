local Signal = require("src.Signal")
local Input = require("src.singleton.Input")
local Window = require("src.singleton.Window")

---Debug-focused manager. By checking `Debug.is_enabled` and adding funcs to the
---`updated` and `drawn` Signals, you can add debug utilities that are easily
---enabled or disabled.
local Debug = {
	-- Semver of this project base
	version = "1.1.0",
	is_enabled = true,
	draw_hitboxes = true,
	are_debug_keys_enabled = true,
	updated = Signal(),
	drawn = Signal(),
}

function Debug:update(dt)
	if not self.is_enabled then return end

	self.updated:emit(dt)

	if self.are_debug_keys_enabled then
		if Input:pressed("debug_quit") then love.event.quit() end
		if Input:pressed("debug_restart") then love.event.quit("restart") end
		if Input:pressed("debug_increase_window_size") then Window:resize(Window.scale + 1) end
		if Input:pressed("debug_decrease_window_size") then Window:resize(Window.scale - 1) end
		if Input:pressed("debug_enable_debug_mode") then debug.debug() end
	end
end

function Debug:draw()
	if self.is_enabled then
		self.drawn:emit()
	end
end

return Debug
