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

function GameObject:new(x, y, w, h)
	-- gameobject
	self.name = "GameObject"
	self.isAlive = true
	self.toRemove = false

	self.visible = true
	self.isSolid = false

	-- draw layer
	self.layer = 0

	-- if true, drawSystem will set self.layer to self.pos.y on update loop
	-- used for 2.5D topdown games
	self.isLayerYPos = false

	-- transform
	self.pos = { x = x or 0, y = y or 0 }
	self.width = w or G.tile_size
	self.height = h or G.tile_size
	self.offset = { x = self.width/2, y = self.height/2 }
	self.scale = { x = 1, y = 1 }
	self.angle = 0 -- in radians

	-- collider component
	self.collider = {
		x = x - self.offset.x,
		y = y - self.offset.y,
		w = self.width,
		h = self.height,
		ox = 0,
		oy = 0
	}

	return self
end

function GameObject:getMiddlePosition()
	return self.pos.x - self.offset.x, self.pos.y - self.offset.y
end

function GameObject:selfDestructIn(seconds)
	timer.after(seconds, function() self.toRemove = true end)
end

return GameObject