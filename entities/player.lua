local Input = require "alphonsus.input"
local GameObject = require "alphonsus.entities.GameObject"
local Particles = require "alphonsus.entities.Particles"

local anim8 = require "lib.anim8"
local _ = require "lib.lume"
local assets = require "assets"

local Bullet = require "entities.bullet"

local Player = GameObject:extend()

function Player:new(x, y, playerNo)
	Player.super.new(self, x, y)
	self.name = "Player"

	-- tags
	self.isPlayer = true
	self.playerNo = playerNo
	self.tag = "player"

	-- draw/sprite component
	self.layer = G.layers.player
	self.isLayerYPos = true
	self.sprite = assets.player
	self.flippedH = false
	self.offset = { x = G.tile_size/2, y = G.tile_size/2 }
	local g = anim8.newGrid(G.tile_size, G.tile_size, self.sprite:getWidth(), self.sprite:getHeight())
	self.idleAnimation = anim8.newAnimation(g('1-3',1), 0.1)
	self.animation = self.idleAnimation

	-- physics
	self.isSolid = true
	self.direction = Direction.right

	if G.platformer then
		-- platformer setup
		local maxVelocity = 275
		local speed = maxVelocity * 10
		local drag = maxVelocity * 4

		self.movable = {
			velocity = { x = 0, y = 0 },
			acceleration = { x = 0, y = 0 },
			drag = { x = 3200, y = G.gravity },
			maxVelocity = { x = 200, y = 350 },
			speed = { x = 2200, y = 0 } -- used to assign to acceleration
		}

		self.platformer = {
			wasGrounded = false,
			isGrounded = false,
			jumpForce = -300,
		}
	else
		-- topdown setup
		local maxVelocity = 180
		local speed = maxVelocity * 10
		local drag = maxVelocity * 20

		-- movable component
		self.movable = {
			velocity = { x = 0, y = 0 },
			acceleration = { x = 0, y = 0 },
			drag = { x = drag, y = drag },
			maxVelocity = { x = maxVelocity, y = maxVelocity },
			speed = { x = speed, y = speed } -- used to assign to acceleration
		}
	end

	-- particles
	self.trailPs = Particles()
	local playerTrail = require "entities.particles.playerTrail"
	if self.playerNo == 2 then playerTrail.colors = {82, 127, 157, 255} end
	self.trailPs:load(playerTrail)
	-- scene:addEntity(self.trailPs)

	-- collider
	self.collider = {
		x = self.pos.x - self.offset.x,
		y = self.pos.y + self.offset.y,
		w = self.width,
		h = self.height,
		ox = -self.offset.x,
		oy = -self.offset.y
	}
	
	self.collidableTags = {"isEnemy"}

	return self
end

function Player:collide(other, col)
	if other.isSlope then
		local x = 11*16
		local y = 9*16

		local y1 = y - (self.pos.x - x) * (32/(4*16))
		self.pos.y = y1 - 8
		self.collider.y = y1 - 8
	end
end

function Player:update(dt)
	self:moveControls(dt)
	self:shootControls()

	if self.trailPs then
		local x, y = self:getMiddlePosition()
		self.trailPs.pos.x = x + _.random(-5,5)
		self.trailPs.pos.y = y + 10
		self.trailPs.ps:emit(1)
	end

	if self.platformer then
		local jump = Input.isKeyDown('space')

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
	-- if Input.wasPressed(self.playerNo .. '_shoot') or Input.wasGamepadButtonPressed('a', self.playerNo) then
	-- 	self:shoot()
	-- end
end

function Player:jump()
	if self.platformer and self.platformer.isGrounded then
		self.platformer.isGrounded = false
		self.movable.velocity.y = self.platformer.jumpForce
	end
end

function Player:onLand()
	tlog.print("LANDED")
end

function Player:shoot()
	local angle = (self.direction == Direction.right and 0 or 180)
	local speed = 150
	local x, y = self.pos.x, self.pos.y
	local b = Bullet(x, y, angle, speed, self)
	b.target = self:getNearestEntity(nil, "enemy")
	-- if b.target then print(b.target.name) end
	
	scene:addEntity(b)
end

function Player:moveControls(dt)
	local jump = Input.wasKeyPressed('space')
	if jump then self:jump() end

	local left = Input.isDown(self.playerNo .. '_left') or Input.isAxisDown(self.playerNo, 'leftx', '<')
	local right = Input.isDown(self.playerNo .. '_right') or Input.isAxisDown(self.playerNo, 'leftx', '>')
	local up = Input.isDown(self.playerNo .. '_up') or Input.isAxisDown(self.playerNo, 'lefty', '<')
	local down = Input.isDown(self.playerNo .. '_down') or Input.isAxisDown(self.playerNo, 'lefty', '>')
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