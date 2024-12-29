---Preloaded sounds for common purposes, like jumps, attacks, interface blips, etc.
---Get creative! The names are just suggestions and you're encouraged to use them
---in a different way. For example, `confirm` could also be a powerup sound.
---
---Note that each sound is tied to a single source; to play multiple instances of
---the same sound, use `Source:clone()` and some sort of pooling logic.

local function load(name)
	return love.audio.newSource("assets/audio/" .. name .. ".ogg", "static")
end

return {
	-- Abstract/"beepy" sounds
	blip = load("blip"),
	confirm = load("confirm"),
	back = load("back"),
	blocked = load("blocked"),
	error = load("error"),
	select = load("select"),
	select2 = load("select2"),
	ding = load("ding"),

	button = load("button"),
	click = load("click"),
	grow = load("grow"),
	jump = load("jump"),
	money = load("money"),
	damage = load("damage"),
	slash = load("slash"),

	-- Foley/"realistic" sounds
	button_metal = load("button_metal"),
	cloth = load("cloth"),
	coins = load("coins"),
	door_open = load("door_open"),
	door_close = load("door_close"),
	footstep = load("footstep"),
	hit = load("hit"),
	hit_big = load("hit_big"),
	hit_shot = load("hit_shot"),
	hit_metal = load("hit_metal"),
	latch = load("latch"),
	paper = load("paper"),
	sharpen = load("sharpen"),
}
