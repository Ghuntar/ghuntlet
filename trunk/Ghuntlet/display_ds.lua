--display_ds.lua

-- Taille de l'écran
Scr_width  = 256
Scr_height = 192
-- Avec 16px par tuile, on affiche 16*12 tuiles

function Monster:init_sprite(self)
	self.spr_width = 16
	self.spr_height = 16
	self.sprite = Sprite.new("./images/Skeleton.png", self.spr_width, self.spr_height, VRAM)
	self.sprite:addAnimation({2,6}, 200) -- Walk up
	self.sprite:addAnimation({1,5}, 200) -- Walk right
	self.sprite:addAnimation({0,4}, 200) -- Walk down
	self.sprite:addAnimation({3,7}, 200) -- Walk left
	self.spr_dir = 3
end

function Monster:set_spr_dir(self)
if self.dir == 1 then self.spr_dir = 1 end
if self.dir == 2 then self.spr_dir = 2 end
if self.dir == 3 then self.spr_dir = 3 end
if self.dir == 4 then self.spr_dir = 4 end
if self.dir == 5 then self.spr_dir = 4 end
if self.dir == 6 then self.spr_dir = 2 end
if self.dir == 7 then self.spr_dir = 2 end
if self.dir == 8 then self.spr_dir = 4 end

end

function Monster:display(self)
Monster:set_spr_dir(self)
self.scrpos = displaycoords (self.realpos)
self.sprite:playAnimation(SCREEN_DOWN, self.scrpos[1], self.scrpos[2], self.spr_dir)
end


--[[
-- Affichage du sprite du mob
if mob.dir == 1 then spr3_dir = 1 end
if mob.dir == 2 then spr3_dir = 2 end
if mob.dir == 3 then spr3_dir = 3 end
if mob.dir == 4 then spr3_dir = 4 end
if mob.dir == 5 then spr3_dir = 4 end
if mob.dir == 6 then spr3_dir = 2 end
if mob.dir == 7 then spr3_dir = 2 end
if mob.dir == 8 then spr3_dir = 4 end
	mob.scrpos = displaycoords (mob.realpos)
	spr3:playAnimation(SCREEN_DOWN, mob.scrpos[1], mob.scrpos[2], spr3_dir)
]]--
