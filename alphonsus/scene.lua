-- 
-- Scene.lua
-- a game scene (like a Unity scene)
-- 

local Object = require "lib.classic"
local shack = require "lib.shack"
local push = require "lib.push"
local gamera = require "lib.gamera"

local assets = require "assets"
local updateSystem = require "systems.updateSystem"
local drawSystem = require "systems.drawSystem"

local Camera = require "alphonsus.camera"

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
	-- self:addEntity(self.camera)
end

-- Add entity to ECS world
function Scene:addEntity(e)
	table.insert(self.entities, e)
end

function Scene:keypressed(k)
end

function Scene:update(dt)
	for _, e in ipairs(self.entities) do
		updateSystem(e, e, dt)
	end
	
	self.camera:update(dt)
end

function Scene:draw()
	push:start()
	self.camera.cam:draw(function(l,t,w,h)
		love.graphics.draw(assets.bg, 0, 0)
		shack:apply()
		for _, e in ipairs(self.entities) do
			drawSystem(e, e)
		end
	end)
	push:finish()
end

local function compareZindex(a, b)
  return a.zindex < b.zindex
end

return Scene