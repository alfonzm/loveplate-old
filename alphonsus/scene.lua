-- 
-- Scene.lua
-- a game scene (like a Unity scene)
-- 

local _ = require "lib.lume"
local Object = require "lib.classic"
local shack = require "lib.shack"
local push = require "lib.push"
local gamera = require "lib.gamera"
local bump = require "lib.bump"

local assets = require "assets"
local removeSystem = require "systems.removeSystem"
local updateSystem = require "systems.updateSystem"
local drawSystem = require "systems.drawSystem"
local collisionSystem = require "systems.collisionSystem"
local movableSystem = require "systems.movableSystem"
local moveTowardsAngleSystem = require "systems.moveTowardsAngleSystem"

local Camera = require "alphonsus.camera"
local Input = require "alphonsus.input"

local Scene = Object:extend()

function Scene:init()
end

function Scene:new()
	return self
end

function Scene:enter()
	self.entities = {}

	-- setup cam
	self.camera = Camera(0, 0, G.width, G.height)
	self.camera.cam:setWindow(0, 0, G.width, G.height)

	-- setup collision world
	self.bumpWorld = bump.newWorld()
end

-- Add entity to ECS and bump world
function Scene:addEntity(e)
	table.insert(self.entities, e)

	if e.collider then
		self.bumpWorld:add(e, e.collider.x, e.collider.y, e.collider.w, e.collider.h)
	end
end

function Scene:keypressed(k)
	Input.onKeyPress(k)
end

function Scene:update(dt)
	for i, e in ipairs(self.entities) do
		-- print(e.name .. " " .. tostring(self.camera:isPointVisible(e.pos.x, e.pos.y)))
		-- print(e.name .. " " .. e.pos.x)
		updateSystem(e, e, dt)
		moveTowardsAngleSystem(e, e, dt)
		movableSystem(e, e, dt)
		collisionSystem(e, e, self.bumpWorld)
		removeSystem(e, i, self.entities, self.bumpWorld)
	end

	self.camera:update(dt)
	self:stateUpdate(dt)
	Input.clear()
end

function Scene:stateUpdate(dt)
end

function Scene:draw()
	push:start()
	self.camera.cam:draw(function(l,t,w,h)
		shack:apply()
		-- love.graphics.draw(assets.bg, 0, 0)
		for _, e in ipairs(_.sort(self.entities, function(a,b) return a.layer < b.layer end)) do
			drawSystem(e, e)
		end
	end)
	push:finish()

	if G.debug then
		love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
		love.graphics.print("Game Objects: "..tostring(#self.entities), 10, 25)
	end
end

return Scene