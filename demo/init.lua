local SampleAnimation = require("demo.SampleAnimation")

return function(root)
	require("globals")
	root:add_child(SampleAnimation())
end
