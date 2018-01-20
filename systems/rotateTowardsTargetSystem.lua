--
-- RotateTowardsAngleSystem
-- by Alphonsus
--
-- entity will move towards angle (via velocity)
--
-- Required:
--   - isMoveTowardsAngle = true
--   - angle
--   - movable
--

local System = require "lib.knife.system"

local rotateTowardsAngleSystem = System(
	{ "isRotateTowardsAngle", "target", "angle" },
	function(isRotateTowardsAngle, angle, e, dt)
		if isRotateTowardsAngle then
		end
	end
)

return rotateTowardsAngleSystem