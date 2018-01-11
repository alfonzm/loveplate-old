local GameObject = require "alphonsus.gameobject"

local Explosion = GameObject:extend()

-- angle in degrees
function Explosion:new(x, y, angle, speed, owner)
	Explosion.super.new(self, x, y)
	self.name = "Explosion"
	self.isExplosion = true
	self.isSolid = false
	self.angle = math.rad(angle or 90)

	self.owner = owner

	self.isMoveTowardsAngle = true

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

	-- collider
	-- self.collider = {
	-- 	x = x,
	-- 	y = y,
	-- 	w = G.tile_size/2,
	-- 	h = G.tile_size/2
	-- }
	-- self.offset = { x = self.collider.w/2, y = self.collider.h/2 }

	self.color = {255,255,255}
	return self
end

function Explosion:collide(other)
	if self.owner.isPlayer and other.name == "Enemy" then
		self.toRemove = true
		scene.camera:shake(2)
	end
end

return Explosion