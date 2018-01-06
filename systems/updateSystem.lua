--
-- UpdateSystem
-- by Alphonsus
--
-- calls entity's update() function, which is usually required for most objects
--
--

local System = require "lib.knife.system"

local updateSystem = System(
	{ "update" },
	function(update, entity, dt)
		entity:update(dt)
	end
)

return updateSystem