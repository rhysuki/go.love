local BasicDemo = require("demo.basic.BasicDemo")
local TopDownDemo = require("demo.topdown.TopDownDemo")

local demos = {
	basic = require("demo.basic.BasicDemo"),
	topdown = require("demo.topdown.TopDownDemo")
}

return function(root, demo_name)
	require("globals")
	root:add_child(demos[demo_name]())
end
