--lib_display_DS.lua


--####################################
--#              MOBz               #
--##################################

MOB.scrpos = COORD:new()
MOB.spr_width = 16
MOB.spr_height = 16
MOB.spr_faces = 1
MOB.spr_dir = 1
MOB.sprite = Sprite.new("./images/deadbody.png", MOB.spr_width, MOB.spr_height, VRAM)
MOB.sprite:addAnimation({0}, 200)

function MOB:set_spr_dir()
	if self.spr_faces == 1 then
		self.spr_dir = 1
	end
	if self.spr_faces == 4 then
		if self.dir == 1 then self.spr_dir = 1 end
		if self.dir == 2 then self.spr_dir = 2 end
		if self.dir == 3 then self.spr_dir = 3 end
		if self.dir == 4 then self.spr_dir = 4 end
		if self.dir == 5 then self.spr_dir = 4 end
		if self.dir == 6 then self.spr_dir = 2 end
		if self.dir == 7 then self.spr_dir = 2 end
		if self.dir == 8 then self.spr_dir = 4 end
	end
end

function MOB:displaycoords()
	local dcoord = COORD:new()
	dcoord = self.realpos + hero.scrpos - hero.realpos
	return dcoord
end

function MOB:display()
self:set_spr_dir()
self.scrpos = self:displaycoords()
--print ("\n dataz", SCREEN_UP, self.scrpos.x, self.scrpos.y, self.spr_dir, "\n")
self.sprite:playAnimation(SCREEN_UP, self.scrpos.x, self.scrpos.y, self.spr_dir)
end

function MOB:destroy_display()
self.sprite:destroy()
end
--####################################
--#              Hero               #
--##################################


--####################################
--#              Monster            #
--##################################

--####################################
--#              Attack             #
--##################################

--####################################
--#              Item               #
--##################################

function ITEM:inventory_display()
self.sprite:drawFrame(SCREEN_DOWN, self.scrpos.x, self.scrpos.y, 0)
end

--####################################
--#              Background         #
--##################################

