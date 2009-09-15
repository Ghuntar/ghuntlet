module(..., package.seeall)

function collide (obj1,obj2)
	if obj1.realpos[1] > (obj2.realpos[1] - (sprite_width /2))
	and obj1.realpos[1] < (obj2.realpos[1] + (sprite_width /2))
	and obj1.realpos[2] > (obj2.realpos[2] - (sprite_height /2))
	and obj1.realpos[2] < (obj2.realpos[2] + (sprite_height /2))
	then return true
	else return false
	end
end
