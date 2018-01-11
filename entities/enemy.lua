local GameObject = require "alphonsus.gameobject"
local Square = require "entities.square"

local Enemy = Square:extend()

function Enemy:new(x, y, color)
	Enemy.super.new(self, x, y)
	self.name = "Enemy"
	self.isEnemy = true
	self.isSolid = false

	self.collider.oy = 10
	self.collider.h = self.collider.h - 10

	self.layer = G.layers.enemy

	self.color = color or {155,100,0}
	return self
end

function Enemy:collisionFilter(other)
	return "cross"
end

return Enemy