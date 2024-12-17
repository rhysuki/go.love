local SampleAnimation = require("src.sample.SampleAnimation")

return function(root)
	root:add_child(SampleAnimation())
	-- root:add_child(require("src.Ball")())
end
