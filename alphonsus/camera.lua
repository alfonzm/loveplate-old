local _ = require "lib.lume"
local Object = require "lib.classic"
local gamera = require "lib.gamera"

local Camera = Object:extend()
local assets = require "assets"

function Camera:new(x, y, w, h, followSpeed)
	self.cam = gamera.new(x or 0, y or 0, w or G.width, h or G.height)
	self.pos = {
		x = x or 0,
		y = y or 0
	}

	self.followTarget = nil -- must be GameObject type
	self.followSpeed = followSpeed or 10

	return self
end

-- target must be GameObject
function Camera:startFollowing(target)
	self.followTarget = target
end

function Camera:update(dt)
	local f = self.followTarget
	if f then
		self.pos.x = _.lerp(self.pos.x, f.pos.x, dt * self.followSpeed)
		self.pos.y = _.lerp(self.pos.y, f.pos.y, dt * self.followSpeed)
	end

	self.cam:setPosition(self.pos.x, self.pos.y)
end

function Camera:shake(amount)
	print("SHAKE")
end

-- function Camera:setDrawLayer(newZIndex)
-- 	self["zIndex" .. self.zIndex] = nil
-- 	self.zIndex = newZIndex
-- 	self["zIndex" .. (newZIndex or 1)] = true
-- end

return Camera