local GameObject = require "alphonsus.gameobject"
local Input = require "alphonsus.input"
local anim8 = require "lib.anim8"
local _ = require "lib.lume"
local assets = require "assets"

local Bullet = require "entities.bullet"

local Player = GameObject:extend()

function Player:new(x, y)
	Player.super.new(self, x, y)
	self.name = "Player"
	self.tag = "player1"
	self.isPlayer = true
	self.isSolid = true

	self.direction = Direction.right

	-- draw/sprite component
	self.layer = G.layers.player
	self.isLayerYPos = true
	self.sprite = assets.player
	self.flippedH = false
	self.offset = { x = G.tile_size/2, y = G.tile_size/2 }
	local g = anim8.newGrid(G.tile_size, G.tile_size, self.sprite:getWidth(), self.sprite:getHeight())
	self.idleAnimation = anim8.newAnimation(g('1-3',1), 0.1)
	self.animation = self.idleAnimation

	local maxVelocity = 180
	local speed = maxVelocity * 8
	local drag = maxVelocity * 6

	-- movable component
	self.movable = {
		velocity = { x = 0, y = 0 },
		acceleration = { x = 0, y = 0 },
		drag = { x = drag, y = drag },
		maxVelocity = { x = maxVelocity, y = maxVelocity },
		speed = { x = speed, y = speed } -- used to assign to acceleration
	}

	-- self.collider.ox = G.tile_size/2 - G.tile_size/4
	self.collider.oy = G.tile_size/2
	-- self.collider.w = G.tile_size/2
	self.collider.h = G.tile_size/2

	-- platformer component
	-- self.platformer = {
	-- 	isGrounded = false,
	-- 	jumpForce = -maxVelocity,
	-- }

	return self
end

function Player:collide(other)
end

function Player.collisionFilter(item, other)
	-- if other.isEnemy or other.isBullet or not other.isSolid then return "cross" end
	if other.isEnemy then return "cross" end
	return "slide"
end

function Player:update(dt)
	self:moveControls(dt)
	self:shootControls()

	if self.platformer then
		local jump = love.keyboard.isDown('z')

		if jump then
			self.movable.drag.y = G.gravity/2
		else
			self.movable.drag.y = G.gravity
		end
	end

	-- if self.trailPs then
	-- 	self.trailPs.ps:setPosition(self.pos.x + math.random(-2,2), self.pos.y + 10)
	-- 	self.trailPs.ps:emit(1)
	-- end
end

-- function Player:getMidPos()
-- 	return self.pos.x + self.offset.x, self.pos.y + self.offset.y
-- end

function Player:shootControls()
	if Input.wasPressed('shoot') then
		self:shoot()
	end
end

function Player:jump()
	if self.platformer and self.platformer.isGrounded then
		self.platformer.isGrounded = false
		self.movable.velocity.y = self.platformer.jumpForce
	end
end

function Player:shoot()
	local angle = self.direction == Direction.right and 90 or -90
	local speed = 1500 * _.sign(angle)

	-- local x, y = self:getMiddlePosition()
	local x, y = self.pos.x, self.pos.y
	local b = Bullet(x, y, angle, speed, self)
	b.movable.drag.y = -G.gravity
	-- b.movable.drag.x = 5000
	b.movable.velocity.y = G.gravity/1000
	b.movable.velocity.x = speed/10
	
	scene:addEntity(b)
end

-- function Player:setupParticles()
-- 	self.trailPs = ParticleSystem()
-- 	self.trailPs:setDrawLayer("playerParticles")
-- 	self.trailPs.ps:setPosition(push:getWidth()/2, push:getHeight()/2)
-- 	self.trailPs.ps:setParticleLifetime(0.2, 2)
-- 	self.trailPs.ps:setDirection(1.5*3.14)
-- 	self.trailPs.ps:setSpread(3.14/3)
-- 	self.trailPs.ps:setLinearAcceleration(0, 400)
-- 	self.trailPs.ps:setLinearDamping(50)
-- 	self.trailPs.ps:setSpin(0, 30)
-- 	self.trailPs.ps:setColors(82, 127, 57, 255)
-- 	self.trailPs.ps:setRotation(0, 2*3.14)
-- 	self.trailPs.ps:setInsertMode('random')
-- 	self.trailPs.ps:setSizes(0.4, 0)
-- 	world:add(self.trailPs)
-- end

function Player:moveControls(dt)
	local left = Input.isDown('left')
	local right = Input.isDown('right')
	local up = Input.isDown('up')
	local down = Input.isDown('down')
	local rotate = Input.isDown('rotate')

	if rotate then
		self.angle = self.angle + 10/180
	end

	if left and not right then
		self.movable.acceleration.x = -self.movable.speed.x
		self.direction = Direction.left
	elseif right and not left then
		self.movable.acceleration.x = self.movable.speed.x
		self.direction = Direction.right
	else
		self.movable.acceleration.x = 0
	end

	if up and not down then
		self.movable.acceleration.y = -self.movable.speed.y
	elseif down and not up then
		self.movable.acceleration.y = self.movable.speed.y
	else
		self.movable.acceleration.y = 0
	end
end

function Player:draw()
end

return Player