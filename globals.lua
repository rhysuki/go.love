--- Global variables for commonly-used values, functions and libraries.
--- All globals should be IMMUTABLE throughout the game's lifetime.


CLASS = require("lib.classic")

--- Shorthand for pretty-printing an `inspect()`ed version of a table (or any
--- other value).
--- @param value any
--- @param depth number?
function PP(value, depth)
	print(require("lib.inspect").inspect(value, {depth = depth or 2}))
end
