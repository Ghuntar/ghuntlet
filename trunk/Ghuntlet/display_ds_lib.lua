--display_ds.lua

-- Taille de l'écran
--Scr_width  = 256
--Scr_height = 192
-- Avec 16px par tuile, on affiche 16*12 tuiles


--####################################
--#				Heros				#
--##################################

function Heros:init_sprite()
	self.spr_width = 16
	self.spr_height = 16
	self.sprite = Sprite.new("./images/Daemon.png", self.spr_width, self.spr_height, VRAM)
	if self.name == "Valkyrie" then self.sprite = Sprite.new("./images/Valkyrie.png", self.spr_width, self.spr_height, VRAM) end
	if self.name == "BlackMage" then self.sprite = Sprite.new("./images/BlackMage_Sprite.png", self.spr_width, self.spr_height, VRAM) end
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
self.sprite:playAnimation(SCREEN_UP, self.scrpos[1], self.scrpos[2], self.spr_dir)
end


--####################################
--#				Monster				#
--##################################


function Monster:init_sprite()
	self.spr_width = 16
	self.spr_height = 16
	self.spr_dir = 3
	self.sprite = Sprite.new("./images/Daemon.png", self.spr_width, self.spr_height, VRAM)
	if self.name == "Skeleton" then self.sprite = Sprite.new("./images/Skeleton.png", self.spr_width, self.spr_height, VRAM) end
	if self.name == "BlackMage" then self.sprite = Sprite.new("./images/BlackMage_old_Sprite.png", self.spr_width, self.spr_height, VRAM) end
	if self.name == "Scarab" then self.sprite = Sprite.new("./images/Bug_Sprite.png", self.spr_width, self.spr_height, VRAM) end
	self.sprite:addAnimation({2,6}, 200) -- Walk up
	self.sprite:addAnimation({1,5}, 200) -- Walk right
	self.sprite:addAnimation({0,4}, 200) -- Walk down
	self.sprite:addAnimation({3,7}, 200) -- Walk left
	if self.name == "Portal" then
		self.sprite = Sprite.new("./images/Portal_Sprite.png", self.spr_width, self.spr_height, VRAM)
		self.sprite:addAnimation({0,1,2,3}, 200) -- Stand
		self.spr_dir = 1
	end

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
if self.name == "Portal" then self.spr_dir = 1 end
end

function Monster:display()
self:set_spr_dir(self)
self.scrpos = displaycoords (self.realpos)
self.sprite:playAnimation(SCREEN_UP, self.scrpos[1], self.scrpos[2], self.spr_dir)
end


--####################################
--#				Attack				#
--##################################


function Attack:init_sprite()
	self.spr_width = 16
	self.spr_height = 16
	self.sprite = Sprite.new("./images/Pentacle_Sprite.png", self.spr_width, self.spr_height, VRAM)
	if self.name == "axe" then self.sprite = Sprite.new("./images/Axe_Sprite.png", self.spr_width, self.spr_height, VRAM) end
	if self.name == "doubleaxe" then self.sprite = Sprite.new("./images/Doubleaxe_Sprite.png", self.spr_width, self.spr_height, VRAM) end
	self.sprite:addAnimation({0,1,2,3}, 100) -- Rotation
end

function Attack:display()
self.scrpos = displaycoords (self.realpos)
self.sprite:playAnimation(SCREEN_UP, self.scrpos[1], self.scrpos[2], 1)
end


--####################################
--#				Item				#
--##################################


function Item:init_sprite()
	self.spr_width = 16
	self.spr_height = 16
	self.sprite = Sprite.new("./images/Spell.png", self.spr_width, self.spr_height, VRAM)
	if self.name == "deadbody" then self.sprite = Sprite.new("./images/deadbody.png", self.spr_width, self.spr_height, VRAM) end
	if self.name == "doubleaxe" then self.sprite = Sprite.new("./images/Doubleaxe.png", self.spr_width, self.spr_height, VRAM) end
	if self.name == "key" then self.sprite = Sprite.new("./images/Key.png", self.spr_width, self.spr_height, VRAM) end
--	self.sprite:addAnimation({0,1,2,3}, 100) -- Rotation
end

function Item:display()
self.scrpos = displaycoords (self.realpos)
self.sprite:drawFrame(SCREEN_UP, self.scrpos[1], self.scrpos[2], 0)
--self.sprite:playAnimation(SCREEN_UP, self.scrpos[1], self.scrpos[2], 1)
end

function Item:inventory_display()
self.sprite:drawFrame(SCREEN_DOWN, self.scrpos[1], self.scrpos[2], 0)
--self.sprite:playAnimation(SCREEN_UP, self.scrpos[1], self.scrpos[2], 1)
end


--####################################
--#				Background			#
--##################################

--inventory_background = Image.load("./images/Scroll.png", VRAM)

