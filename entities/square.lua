local GameObject = require "alphonsus.gameobject"

local Square = GameObject:extend()

function Square:new(x, y, color)
	Square.super.new(self, x, y)
	self.name = "Square"
	self.isSquare = true
	self.isSolid = true
	self.isLayerYPos = true
	self.color = color or {0,255,0}
	return self
end

function Square:collisionFilter(other)
	if other.isSquare then return "cross" end
	return "slide"
end

function Square:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
	love.graphics.setColor(255,255,255)
end

return Square