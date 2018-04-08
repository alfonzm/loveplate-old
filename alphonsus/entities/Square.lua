local GameObject = require "alphonsus.entities.GameObject"

local Square = GameObject:extend()

function Square:new(x, y, color, w, h)
	Square.super.new(self, x, y, w, h)
	self.name = "Square"
	self.isSquare = true
	self.isSolid = true
	self.isLayerYPos = true
	self.color = color or {100,255,100}

	-- self.collider = {
	-- 	x = self.pos.x - self.offset.x,
	-- 	y = self.pos.y + self.offset.y,
	-- 	w = self.width,
	-- 	h = self.height,
	-- 	ox = -self.offset.x,
	-- 	oy = -self.offset.y
	-- }

	return self
end

function Square:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.pos.x - self.offset.x, self.pos.y - self.offset.y, self.width, self.height)
	love.graphics.setColor(255,255,255)
end

return Square