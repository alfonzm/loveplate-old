local Scene = require "alphonsus.scene"
local Input = require "alphonsus.input"
local GameObject = require "alphonsus.gameobject"
local shack = require "lib.shack"
local _ = require "lib.lume"
local Gamestate = require "lib.hump.gamestate"

local Square = require "entities.square"
local Player = require "entities.player"
local Bullet = require "entities.bullet"
local Enemy = require "entities.enemy"

local PlayState = Scene:extend()

-- entities
local player = {}
local player2 = {}
local middlePoint = {}

-- helper function
function getMiddlePoint(pos1, pos2)
	return (pos1.x + pos2.x)/2 + player.width/2, (pos1.y + pos2.y)/2 - player.width/2
end

function PlayState:enter()
	PlayState.super.enter(self)
	scene = self

	player = Player(300, 50, 1)
	player2 = Player(200, 50, 2)

	middlePoint = GameObject(getMiddlePoint(player.pos, player2.pos),0,0)
	middlePoint.collider = nil
	
	-- spawn random squares
	for i=10,30 do
		self:addEntity(Square(i * G.tile_size, 10 * G.tile_size))
	end
	self:addEntity(Square(10 * G.tile_size, 12 * G.tile_size))
	self:addEntity(Square(11 * G.tile_size, 8 * G.tile_size))
	self:addEntity(Square(10 * G.tile_size, 8 * G.tile_size))

	self:addEntity(Enemy(14 * G.tile_size, 7 * G.tile_size))

	-- for i=1,50 do
	-- 	tile = Square(math.random(10, 100) * G.tile_size, math.random(10, 100) * G.tile_size)
	-- 	tile.color = {255,0,0}
	-- 	self:addEntity(tile)
	-- end

	self:addEntity(player)
	self:addEntity(player2)

	self.camera:setPosition(middlePoint.pos.x, middlePoint.pos.y)
	self.camera:startFollowing(middlePoint, 0, 0)
	self.camera.followSpeed = 5
end

function PlayState:stateUpdate(dt)
	PlayState.super.stateUpdate(self, dt)

	local x, y = getMiddlePoint(player.pos, player2.pos)
	middlePoint.pos.x = x
	middlePoint.pos.y = y

	local d = _.distance(player.pos.x, player.pos.y, player2.pos.x, player2.pos.y)

	self.camera.zoom = 1
	if d > G.height then
		self.camera.zoom = 0.8
	end

	if d > G.height * 1.5 then
		self.camera.zoom = 0.6
	end

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