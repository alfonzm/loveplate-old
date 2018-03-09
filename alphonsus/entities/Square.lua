local GameObject = require "alphonsus.entities.GameObject"

local Square = GameObject:extend()

function Square:new(x, y, color, w, h)
	Square.super.new(self, x, y, w, h)
	self.name = "Square"
	self.isSquare = true
	self.isSolid = true
	self.isLayerYPos = true
	self.color = color or {100,255,100}

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

function Square:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.pos.x - self.offset.x, self.pos.y - self.offset.y, self.width, self.height)
	love.graphics.setColor(255,255,255)
end

return Square