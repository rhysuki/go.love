local function load(name)
	return love.graphics.newImage("assets/images/" .. name .. ".png")
end

---Preloaded graphics for common purposes, like items, objects, effects, etc.
---
---Also includes things like image shader uniforms.
return {
	-- Symbols
	bubble_exclamation = load("bubble_exclamation"),
	heart = load("heart"),
	heart_half = load("heart_half"),
	heart_empty = load("heart_empty"),
	mark_check = load("mark_check"),
	mark_cross = load("mark_cross"),

	-- Items
	sword = load("sword"),
	shield = load("shield"),
	axe = load("axe"),
	bow = load("bow"),
	arrow = load("arrow"),
	item = load("item"),
	coin = load("coin"),
	food = load("food"),
	potion = load("potion"),
	key = load("key"),

	-- Overworld objects
	box = load("box"),
	chest = load("chest"),
	flag = load("flag"),
	sign = load("sign"),
	button_off = load("button_off"),
	button_on = load("button_on"),
	lever_off = load("lever_off"),
	lever_on = load("lever_on"),
	door = load("door"),
	door_open = load("door_open"),
	door_locked = load("door_locked"),
	grave = load("grave"),
	tree = load("tree"),

	-- Visual effects
	effect_fire = load("effect_fire"),
	effect_moon = load("effect_moon"),
	effect_slash = load("effect_slash"),
	effect_slash2 = load("effect_slash2"),
	effect_spark = load("effect_spark"),
	effect_spark2 = load("effect_spark2"),
	effect_wind = load("effect_wind"),

	-- Shader uniforms
	palette_bubblegum_16 = load("palettes/bubblegum_16"),
	palette_swap_bubblegum_16_dark = load("palettes/bubblegum_16_dark"),
	-- With the included shaders, sending this as an uniform resets them back
	-- to doing nothing
	empty = load("palettes/empty"),
}
