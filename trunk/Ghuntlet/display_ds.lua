--display_ds.lua

-- Taille de l'écran
Scr_width  = 256
Scr_height = 192
-- Avec 16px par tuile, on affiche 16*12 tuiles


function Heros:init_sprite()
	self.spr_width = 16
	self.spr_height = 16
	self.sprite = Sprite.new("./images/Daemon.png", self.spr_width, self.spr_height, VRAM)
	if self.name == "Valkyrie" then self.sprite = Sprite.new("./images/Valkyrie.png", self.spr_width, self.spr_height, VRAM) end
	if self.name == "BlackMage" then self.sprite = Sprite.new("./images/BlackMage.png", self.spr_width, self.spr_height, VRAM) end
	if self.name == "MaidenGuard" then self.sprite = Sprite.new("./images/MaidenGuard.png", self.spr_width, self.spr_height, VRAM) end
	self.sprite:addAnimation({2,6}, 200) -- Walk up
	self.sprite:addAnimation({1,5}, 200) -- Walk right
	self.sprite:addAnimation({0,4}, 200) -- Walk down
	self.sprite:addAnimation({3,7}, 200) -- Walk left
	self.spr_dir = 3
end

function Heros:set_spr_dir()
if self.dir == 1 then self.spr_dir = 1 end
if self.dir == 2 then self.spr_dir = 2 end
if self.dir == 3 then self.spr_dir = 3 end
if self.dir == 4 then self.spr_dir = 4 end
if self.dir == 5 then self.spr_dir = 4 end
if self.dir == 6 then self.spr_dir = 2 end
if self.dir == 7 then self.spr_dir = 2 end
if self.dir == 8 then self.spr_dir = 4 end
end

function Heros:display()
self:set_spr_dir()
self.scrpos = displaycoords (self.realpos)
self.sprite:playAnimation(SCREEN_DOWN, self.scrpos[1], self.scrpos[2], self.spr_dir)
end



function Monster:init_sprite()
	self.spr_width = 16
	self.spr_height = 16
	self.sprite = Sprite.new("./images/Daemon.png", self.spr_width, self.spr_height, VRAM)
	if self.name == "Skeleton" then self.sprite = Sprite.new("./images/Skeleton.png", self.spr_width, self.spr_height, VRAM) end
	if self.name == "BlackMage" then self.sprite = Sprite.new("./images/BlackMage_Sprite.png", self.spr_width, self.spr_height, VRAM) end
	self.sprite:addAnimation({2,6}, 200) -- Walk up
	self.sprite:addAnimation({1,5}, 200) -- Walk right
	self.sprite:addAnimation({0,4}, 200) -- Walk down
	self.sprite:addAnimation({3,7}, 200) -- Walk left
	self.spr_dir = 3
end

function Monster:set_spr_dir()
if self.dir == 1 then self.spr_dir = 1 end
if self.dir == 2 then self.spr_dir = 2 end
if self.dir == 3 then self.spr_dir = 3 end
if self.dir == 4 then self.spr_dir = 4 end
if self.dir == 5 then self.spr_dir = 4 end
if self.dir == 6 then self.spr_dir = 2 end
if self.dir == 7 then self.spr_dir = 2 end
if self.dir == 8 then self.spr_dir = 4 end
end

function Monster:display()
self:set_spr_dir(self)
self.scrpos = displaycoords (self.realpos)
self.sprite:playAnimation(SCREEN_DOWN, self.scrpos[1], self.scrpos[2], self.spr_dir)
end


