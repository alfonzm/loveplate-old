local GameObject = require "alphonsus.entities.GameObject"

local Circle = GameObject:extend()

function Circle:new(x, y, w, h, color, selfDestructIn)
	Circle.super.new(self, x, y, w, h)
	self.name = "Circle"
	self.isCircle = true
	self.isSolid = false
	self.color = color or {255,255,255}

	self.collider = nil

	if selfDestructIn then
		self:selfDestructIn(selfDestructIn)
	end
	
	return self
end

function Circle:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.pos.x, self.pos.y, self.width, self.height)
	love.graphics.setColor(255,255,255)
end

return Circle