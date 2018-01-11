local _ = require "lib.lume"
local Input = {}

Input.map = {}
Input.pressed = {}

function Input.register(id, keys)
	if type(id) == "table" then
		for k, v in pairs(id) do
			Input.register(k, v)
		end
		return
	end
	Input.map[id] = _.clone(keys)
end

function Input.onKeyPress(k)
	Input.pressed[k] = true
end

function Input.isKeyDown(k)
	return love.keyboard.isDown(k)
end

-- using mapped Input keys
function Input.isDown(id)
	local keys = Input.map[id]
	assert(keys, "Input ID not mapped: " .. id)
	return love.keyboard.isDown(unpack(keys))
end

-- check if key was pressed once
function Input.wasKeyPressed(k)
	return Input.pressed[k]
end

-- check if Input key was just pressed once
function Input.wasPressed(id)
	local keys = Input.map[id]
	assert(keys, "Input ID not mapped: " .. id)
	return _.any(keys, function(k) return Input.pressed[k] end)
end

function Input.clear()
	_.clear(Input.pressed)
end

return Input