---anim8 objects ready to use, mainly a player character.
---This module bundles atlases and animations together to avoid having to pass
---them around manually. To mess with their internal state, call methods on each
---animation's `data` field, which is just a raw anim8 object.

local anim8 = require("lib.anim8.anim8")
local player_atlas = love.graphics.newImage("assets/images/player.png")
local player_grid = anim8.newGrid(16, 16, player_atlas:getWidth(), player_atlas:getHeight())

---Draw this animation. All extra arguments, like position, size, offset, etc,
---are passed to this animation's `love.graphics.draw()`.
---@param ...any
local function draw_animation(self, ...)
	-- Round positions when drawing, because animations offset by exactly 0.5
	-- pixels look wonky
	local x = math.floor(select(1, ...) + 0.5)
	local y = math.floor(select(2, ...) + 0.5)

	self.data:draw(self.atlas, x, y, select(3, ...))
end

local function create_animation(atlas, frames, durations)
	return {
		_is_animation = true,
		atlas = atlas,
		data = anim8.newAnimation(frames, durations),
		draw = draw_animation,
	}
end

-- Recursively update every animation in `t`.
local function update_animations(t, dt)
	for _, v in pairs(t) do
		if type(v) == "table" then
			if v._is_animation then
				v.data:update(dt)
			else
				update_animations(v, dt)
			end
		end
	end
end

local animations = {
	player = {
		-- General-purpose and topdown-focused animations
		idle_down = create_animation(player_atlas, player_grid("2-2", 1), 0.2),
		idle_right = create_animation(player_atlas, player_grid("2-2", 2), 0.2),
		idle_left = create_animation(player_atlas, player_grid("2-2", 3), 0.2),
		idle_up = create_animation(player_atlas, player_grid("2-2", 4), 0.2),

		walk_down = create_animation(player_atlas, player_grid("1-4", 1), 0.2),
		walk_right = create_animation(player_atlas, player_grid("1-4", 2), 0.2),
		walk_left = create_animation(player_atlas, player_grid("1-4", 3), 0.2),
		walk_up = create_animation(player_atlas, player_grid("1-4", 4), 0.2),

		push_down = create_animation(player_atlas, player_grid("1-4", 5), 0.2),
		push_right = create_animation(player_atlas, player_grid("1-4", 6), 0.2),
		push_left = create_animation(player_atlas, player_grid("1-4", 7), 0.2),
		push_up = create_animation(player_atlas, player_grid("1-4", 8), 0.2),

		victory = create_animation(player_atlas, player_grid("1-14", 14), 0.05),
		victory_pose = create_animation(player_atlas, player_grid("1-1", 15), 0.05),

		-- Sidescrolling-focused animations. To flip them, flip the underlying object.
		-- Example: `animations.player_run.data:flipH()`
		idle = create_animation(player_atlas, player_grid("2-2", 9), 0.1),
		run = create_animation(player_atlas, player_grid("1-4", 9), 0.1),
		jump = create_animation(player_atlas, player_grid("1-1", 10), 0.1),
		fall = create_animation(player_atlas, player_grid("1-1", 11), 0.1),
		crouch = create_animation(player_atlas, player_grid("1-1", 12), 0.1),
		item = create_animation(player_atlas, player_grid("1-1", 13), 0.1),
	}
}

---Update every registered animation. Should be called only once per frame.
---@param dt number
function animations:update(dt)
	update_animations(self, dt)
end

--TODO: put all player animations inside tables and change every place that uses animations

return animations
