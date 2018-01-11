local GameObject = require "alphonsus.gameobject"

local Square = require "entities.square"

local Bullet = Square:extend()

-- angle in degrees
function Bullet:new(x, y, angle, speed, owner)
	Bullet.super.new(self, x, y)
	self.name = "Bullet"
	self.isBullet = true
	self.isSolid = false
	self.angle = math.rad(angle or 90)
	self.layer = G.layers.bullet
	self.isLayerYPos = false

	self.owner = owner

	-- self.isMoveTowardsAngle = true

	local maxVelocity = speed or 50
	local speed = maxVelocity / 10

	-- movable component
	self.movable = {
		velocity = { x = 0, y = 0 },
		drag = { x = 0, y = 0 },
		maxVelocity = { x = maxVelocity, y = maxVelocity },
		speed = { x = speed, y = speed },
		acceleration = { x = 0, y = 0 }
	}

	self.width = G.tile_size/2
	self.height = G.tile_size/2

	-- collider
	self.collider = {
		x = x,
		y = y,
		w = self.width,
		h = self.height
	}

	self.offset = { x = self.collider.w/2, y = self.collider.h/2 }

	self.color = {255,255,255}
	return self
end

function Bullet:collide(other)
	if self.owner.isPlayer and other.name == "Enemy" then
		self.toRemove = true
		local x, y = self:getMiddlePosition()
		s = Square(x, y, {255,255,255})
		s.isSolid = false
		s:selfDestructIn(0.1)
		s.isLayerYPos = false
		s.layer = self.layer

		scene:addEntity(s)
		-- scene.camera:shake(2)
		-- love.graphics.setColor(255,255,255,255)
		-- love.graphics.setLineStyle('rough')
		-- love.graphics.circle("fill", self.pos.x, self.pos.y, 15, 100)
	end
end

return Bullet