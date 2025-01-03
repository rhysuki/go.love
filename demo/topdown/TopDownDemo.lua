local help = require("demo.help")
local BasePlayerTopDown = require("src.BasePlayerTopDown")
local Box = require("demo.topdown.Box")
local Button = require("demo.topdown.Button")
local Logo = require("demo.Logo")
---@class TopDownDemo: Node
local TopDownDemo = NODE:extend()

function TopDownDemo:new()
	TopDownDemo.super.new(self)

	DEBUG.draw_hitboxes = false

	self.player = self:add_child(BasePlayerTopDown(40, 40))
	self.button = self:add_child(Button(WINDOW.half_screen_width - 4, WINDOW.half_screen_height - 25))
	self:add_child(Box(WINDOW.half_screen_width - 40, WINDOW.half_screen_height - 60))

	self.button.activated:subscribe(self, function()
		self:add_child(Logo())
	end)
end

function TopDownDemo:update(dt)
	TopDownDemo.super.update(self, dt)

	if self.player.is_active and INPUT:pressed("confirm") then
		self.player.is_active = false
		self.player._animation = self.player._animation_table.victory
		self.player._animation.data:gotoFrame(1)
		self.player._animation.data.onLoop = 'pauseAtEnd'
		help.sounds.jump:play()
	end
end

return TopDownDemo
