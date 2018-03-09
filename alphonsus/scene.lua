-- 
-- Scene.lua
-- a game scene/room/screen
-- 

local Object = require "lib.classic"
local shack = require "lib.shack"
local push = require "lib.push"
local gamera = require "lib.gamera"
local bump = require "lib.bump"
local flux = require "lib.flux"

local Camera = require "alphonsus.camera"
local Input = require "alphonsus.input"

local removeSystem = require "alphonsus.systems.removeSystem"
local updateSystem = require "alphonsus.systems.updateSystem"
local drawSystem = require "alphonsus.systems.drawSystem"
local collisionSystem = require "alphonsus.systems.collisionSystem"
local platformerMovableSystem = require "alphonsus.systems.platformerMovableSystem"
local topdownMovableSystem = require "alphonsus.systems.topdownMovableSystem"
local moveTowardsAngleSystem = require "alphonsus.systems.moveTowardsAngleSystem"
local moveTowardsPositionSystem = require "alphonsus.systems.moveTowardsPositionSystem"
local shooterSystem = require "alphonsus.systems.shooterSystem"


local Scene = Object:extend()

function Scene:init()
end

function Scene:new()
	self.bgColor = {0,0,0,255}
	
	-- setup collision world
	self.bumpWorld = bump.newWorld()
	return self
end

function Scene:enter()
	self.entities = {}

	-- setup cam
	self.camera = Camera()

	-- setup gamepads
	local joysticks = love.joystick.getJoysticks()
	for i, j in ipairs(joysticks) do
		Input.gamepads[i] = { buttons = {} }
		Input.gamepadPressed[i] = {}
	end
end

-- Add entity to ECS and bump world
function Scene:addEntity(e)
	table.insert(self.entities, e)

	local col = e.collider

	if col and col.x and col.y and col.w and col.h then
		self.bumpWorld:add(e, col.x, col.y, col.w, col.h)
	end
end

function Scene:update(dt)
	for i, e in ipairs(self.entities) do
		updateSystem(e, e, dt)
		moveTowardsAngleSystem(e, e, dt)
		moveTowardsPositionSystem(e, e, dt)
		platformerMovableSystem(e, e, dt)
		topdownMovableSystem(e, e, dt)
		shooterSystem(e, e, dt)
		collisionSystem(e, e, self.bumpWorld)
		removeSystem(e, i, self.entities, self.bumpWorld)
	end

	self.camera:update(dt)
	self:stateUpdate(dt)
	Input.clear()
end

-- basically the update function for states/scenes
function Scene:stateUpdate(dt)
end

function Scene:draw()
	push:start()
	love.graphics.setColor(unpack(self.bgColor))
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setColor(255,255,255,255)
	self.camera.cam:draw(function(l,t,w,h)
		shack:apply()
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

-- ====================================
--              CONTROLS
-- ====================================

function Scene:keypressed(k)
	Input.onKeyPress(k)
end

function Scene:gamepadaxis(j, axis, value)
	local gamepadId, gamepadInstanceId = j:getID()
	Input.gamepads[gamepadId][axis] = value
end

function Scene:gamepadpressed(j, button)
	local gamepadId, gamepadInstanceId = j:getID()
	Input.gamepadPressed[gamepadId][button] = true
end

function Scene:gamepadreleased(j, button)
	local gamepadId, gamepadInstanceId = j:getID()
	Input.gamepads[gamepadId][button] = false
end


-- ====================================
--          HELPER FUNCTIONS
-- ====================================
function Scene:getObject(tag)
	return _.filter(self.entities, function(e)
		return e[tag] == true
	end)
end

function Scene:getNearestEntityFromSource(source, maxDistance, tag)
	-- get visible entities except source
	local filteredEntities = _.reject(self.entities, function(e)
		return source.pos.x == e.pos.x and source.pos.y == e.pos.y
	end)

	if tag then
		filteredEntities = _.filter(filteredEntities, function(e) return e.tag == tag end)
	end

	local visibleEntities = self.camera:getVisibleEntities(filteredEntities)

	if maxDistance then
		-- filter max distance
		visibleEntities = _.filter(visibleEntities, function(e) return e:distanceFrom(source) < maxDistance end)
	end

	-- sort visible entities by distance to source (ascending)
	local sortedEntities = _.sort(visibleEntities, function(a,b)
		return a:distanceFrom(source) < b:distanceFrom(source)
	end)

	return sortedEntities[1]
end

function Scene:getNearbyEntitiesFromSource(source, distance, tag)
	return _.filter(self.entities, function(e)
		return _.distance(source.pos.x, source.pos.y, e.pos.x, e.pos.y) < distance and e.tag == tag
	end)
end

return Scene