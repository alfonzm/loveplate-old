GameObject = require "alphonsus.gameobject"

local sti = require "lib.sti"

local TileMap = GameObject:extend()
local assets =  require "assets"

function TileMap:new(x, y)
	TileMap.super.new(self, x or 0, y or 0)
	self.name = "TileMap"
	self.isTileMap = true

	-- self.map = sti("maps/plain.lua")
	-- self.map = sti("maps/plain2.lua")
	self.map = sti("assets/maps/map.lua")

	return self
end

function TileMap:update(dt)
end

function TileMap:draw()
	local camScale = scene.camera.cam:getScale()
	local l,t,w,h = scene.camera.cam:getVisible()
	self.map:draw(-l, -t, camScale, camScale)
end

return TileMap