local bump = require "lib.bump"
local _ = require "lib.lume"
local Gamestate = require "lib.hump.gamestate"

local Scene = require "alphonsus.scene"
local Input = require "alphonsus.input"
local GameObject = require "alphonsus.entities.GameObject"
local Square = require "alphonsus.entities.Square"

local Player = require "entities.player"
local Bullet = require "entities.bullet"
local Enemy = require "entities.enemy"

local PlaygroundState = Scene:extend()

-- helper function
function getMiddlePoint(pos1, pos2)
	return (pos1.x + pos2.x)/2 + player.width/2, (pos1.y + pos2.y)/2 - player.width/2
end

function PlaygroundState:enter()
	PlaygroundState.super.enter(self)
	scene = self
	self.bumpWorld = bump.newWorld()

	self.bgColor = {25,25,25}

	-- setup players
	self.player = Player(100, 50, 1)
	self:addEntity(self.player)

	for i=1,800 do
		local size = _.random(1,3)
		local s = Square(_.random(0, G.width * 3),_.random(0, G.height * 3), Colors.white, size, size)
		s.parallax = _.randomchoice({0.3,0.6,0.8})
		if s.parallax == 0.3 then
			s.color = {255,255,255,100}
		elseif s.parallax == 0.6 then
			s.color = {255,255,255,180}
		elseif s.parallax == 0.8 then
			s.color = {255,255,255,255}
		end

		self:addEntity(s)
	end
	
	-- setup camera
	self.camera:startFollowing(self.player)
	self.camera.followSpeed = 5
end

function PlaygroundState:stateUpdate(dt)
	PlaygroundState.super.stateUpdate(self, dt)

 	if Input.wasKeyPressed('r') then
		Gamestate.switch(self)
	end

	-- if Input.wasKeyPressed('z') then
	-- 	player:jump()
	-- end

	if Input.wasPressed('zoomIn') then
		self.camera.zoom = self.camera.zoom + 1
	end

	if Input.wasPressed('zoomOut') then
		-- self.camera.zoom = self.camera.zoom-1
	end
end

function PlaygroundState:draw()
	-- moonshine shader
	-- effect(function()
		-- PlaygroundState.super.draw(self)
	-- end)

	-- palette switcher
	-- PaletteSwitcher.set();
	-- love.graphics.setShader(bloomShader)

	PlaygroundState.super.draw(self)

	-- PaletteSwitcher.unset()
	-- love.graphics.setShader()
end

return PlaygroundState