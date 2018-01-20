GameObject = require "alphonsus.gameobject"

local Particles = GameObject:extend()
local assets =  require "assets"

function Particles:new(x, y)
	Particles.super.new(self, x or G.width/2, y or G.width/2)
	self.name = "Particles"
	self.isParticles = true

	self.ps = love.graphics.newParticleSystem(assets.whiteCircle, 100)
	self.ps:setPosition(self.pos.x, self.pos.y)
	self.ps:setColors(82, 127, 57, 255) -- rgba

	self.ps:setParticleLifetime(0.2, 2)
	self.ps:setDirection(1.5*3.14)
	self.ps:setSpread(3.14/1)

	self.ps:setLinearAcceleration(0, 100) -- x, y acceleration
	self.ps:setLinearDamping(5) -- decceleration (for x and y)

	self.ps:setRotation(0, 1) -- initial rotation
	self.ps:setSpin(0, 10) -- angular velocity

	self.ps:setSizes(0.7, 0) -- initial size
	
	self.ps:setInsertMode('random')
	return self
end

function Particles:update(dt)
	self.ps:update(dt)
	self.ps:setPosition(self.pos.x, self.pos.y)
end

function Particles:draw()
	love.graphics.draw(self.ps, 0, 0, 0, 1, 1)
end

return Particles