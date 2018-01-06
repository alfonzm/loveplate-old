local Scene = require "alphonsus.scene"
local shack = require "lib.shack"

local Player = require "entities.player"

local PlayState = Scene:extend()

local player = {}

function PlayState:enter()
	PlayState.super.enter(self)

	player = Player(10, 10)
	self:addEntity(player)

	self.camera:startFollowing(player)
	self.camera.followSpeed = 5

	-- setup cam
	self.camera.cam:setWorld(0,0,1000,1000)

	-- shack:setShake(10)
end

function PlayState:keypressed(k)
end

function PlayState:update(dt)
	PlayState.super.update(self, dt)
end

function PlayState:draw()
	PlayState.super.draw(self)
end

return PlayState