--lib_mobz.lua


--####################################
--#              MOBz               #
--##################################
-- MOBz are all Mobile OBjects, including Heroes, Monsters, Weapons, and more

MOB = {}
function MOB:new(name)
	local newobject = {}
	newobject.name = name or "Unnamed"
	setmetatable(newobject, self)
	self.__index = self
      	return newobject
end

function MOB:init(...)

end

function MOB:copy(copied)
local newcopy = {}
return newcopy
end
