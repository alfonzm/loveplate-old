local Scene = require "alphonsus.scene"
local Input = require "alphonsus.input"
local shack = require "lib.shack"
local Gamestate = require "lib.hump.gamestate"

local Square = require "entities.square"
local Player = require "entities.player"
local Bullet = require "entities.bullet"
local Enemy = require "entities.enemy"

local PlayState = Scene:extend()

local player = {}

function PlayState:enter()
	PlayState.super.enter(self)

	player = Player(300, 10)

	scene = self

	-- self:addEntity(Bullet(100, 100, 45, 50))
	
	-- spawn random squares
	for i=10,30 do
		self:addEntity(Square(i * G.tile_size, 10 * G.tile_size))
	end
	self:addEntity(Square(10 * G.tile_size, 9 * G.tile_size))
	self:addEntity(Enemy(14 * G.tile_size, 7 * G.tile_size))

	-- for i=1,50 do
	-- 	tile = Square(math.random(10, 100) * G.tile_size, math.random(10, 100) * G.tile_size)
	-- 	tile.color = {255,0,0}
	-- 	self:addEntity(tile)
	-- end

	self:addEntity(player)

	self.camera:setPosition(player.pos.x, player.pos.y)
	self.camera:startFollowing(player, player.collider.w / 2, player.collider.h / 2)
	self.camera.followSpeed = 5
end

function PlayState:stateUpdate(dt)
	PlayState.super.stateUpdate(self, dt)

	if Input.wasKeyPressed('`') then
		G.debug = not G.debug
 	end

 	if Input.wasKeyPressed('r') then
		Gamestate.switch(self)
	end

	if Input.wasKeyPressed('z') then
		player:jump()
	end

	if Input.wasPressed('zoomIn') then
		self.camera.zoom = self.camera.zoom+0.2
	end

	if Input.wasPressed('zoomOut') then
		self.camera.zoom = self.camera.zoom-0.2
	end
end

function PlayState:draw()
	PlayState.super.draw(self)
end

return PlayState