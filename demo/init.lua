local Demo = {
	basic = "demo.basic.BasicDemo",
	topdown = "demo.topdown.TopDownDemo",
	camera = "demo.camera.CameraDemo",
}

function Demo:run(root, name)
	require("globals")
	root:add_child(require(name)())
end

return Demo
