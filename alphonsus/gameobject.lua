local Object = require "lib.classic"
local timer = require "lib.hump.timer"

local GameObject = Object:extend()
local assets = require "assets"

Direction = {
	up = 'up',
	down = 'down',
	left = 'left',
	right = 'right'
}

function GameObject:new(x,y)
	-- gameobject
	self.name = "GameObject"
	self.isAlive = true
	self.toRemove = false

	self.visible = true
	self.isSolid = false
	self.layer = G.layers.default

	-- transform
	self.pos = { x = x or 0, y = y or 0 }
	-- self.offset = { x = 0, y = 0}
	self.scale = {}
	self.angle = 0 -- in radians

	-- collider component
	self.collider = {
		x = x,
		y = y,
		w = G.tile_size,
		h = G.tile_size
	}

	return self
end

function GameObject:getMiddleX()
end

function GameObject:selfDestructIn(seconds)
	timer.after(seconds, function() self.toRemove = true end)
end

-- function GameObject:setDrawLayer(newZIndex)
-- 	self["zIndex" .. self.zIndex] = nil
-- 	self.zIndex = newZIndex
-- 	self["zIndex" .. (newZIndex or 1)] = true
-- end

return GameObject