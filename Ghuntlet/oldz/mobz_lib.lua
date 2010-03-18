--mobz.lua


--####################################
--#              MOBz               #
--##################################
-- MOBz are all Mobile OBjects, including Heroes, Monsters, Weapons, and more

MOB = {}
function MOB:new(...)
	local newobject = {}
	newobject.name = arg[1] or "Unnamed"
	newobject.startpos = {unpack (arg[2])} or {0 , 0}
	setmetatable(newobject, self)
	return newobject
end

function MOB:init(...)

end

function MOB:copy(copied)
local newcopy = {}
return newcopy
end

--####################################
--#				Monster				#
--##################################

Monster = {}
Monster_mt = {}
Monster_mt.__index = Monster

function Monster.new (...)
	return setmetatable ({
					name = arg[1] or "Unnamed",
					startpos = {unpack (arg[2])} or {0 , 0},
					}, Monster_mt)
end

function Monster:init()
	self.race = "Unknown"
	self.speed = 1
	self.maxlife = 5
	self.width = 16
	self.height = 16
	self.touch_attack = 0
	self.spell_timer = Timer.new()
	if self.name == "Skeleton" then
		self.race = "Undead"
		self.speed = 2
		self.maxlife = 20
		self.width = 16
		self.height = 16
		self.touch_attack = 1
	end
	if self.name == "Ratmut" then
		self.race = "Undead"
		self.speed = 1
		self.maxlife = 20
		self.width = 16
		self.height = 16
		self.touch_attack = 1
	end
	if self.name == "BlackMage" then
		self.race = "Human"
		self.speed = 1
		self.maxlife = 10
		self.width = 16
		self.height = 16
		self.touch_attack = 0
	end
	if self.name == "Portal" then
		self.race = "Warp"
		self.speed = 0
		self.maxlife = 10
		self.width = 16
		self.height = 16
		self.touch_attack = 0
	end
	if self.name == "Scarab" then
		self.race = "Bug"
		self.speed = 2
		self.maxlife = 10
		self.width = 16
		self.height = 16
		self.touch_attack = 1
	end
	self.half_width = self.width / 2
	self.half_height = self.height / 2
	self.realpos = {unpack(self.startpos)}
	self.lastpos = {0,0}
	self.scrpos = {0,0}
	self.move = {0,0}
	self.dir = 3
	self.life = self.maxlife
	self.status = "OK"
end

function Monster:ia_mov ()
	local newdir = 0
	if self.realpos[1] < hero.realpos[1] and self.realpos[2] < hero.realpos[2] then newdir = 8 end
	if self.realpos[1] > hero.realpos[1] and self.realpos[2] < hero.realpos[2] then newdir = 7 end
	if self.realpos[1] < hero.realpos[1] and self.realpos[2] > hero.realpos[2] then newdir = 5 end
	if self.realpos[1] > hero.realpos[1] and self.realpos[2] > hero.realpos[2] then newdir = 6 end
	return newdir
end

function Monster:ia_attack()
--print (self.spell_timer:time())
	if self.spell_timer:time() > 1000 then
		self.spell_timer:stop()
		self.spell_timer:reset()
	end
	if self.spell_timer:time() == 0 then
		if self.name == "Portal" then	self.spell = Spell.new("Summon")
										self.spell:init(self)
		end
	self.spell_timer:start()
	end
end
--####################################################

--dir
--6|1|5
--2|0|4
--7|3|8

--####################################
--#				NPC					#
--##################################


NPC = {}
NPC_mt = {}
NPC_mt.__index = NPC

function NPC.new (...)
	return setmetatable ({
					name = arg[1] or "Unnamed",
					startpos = {unpack (arg[2])} or {0 , 0},
					}, NPC_mt)
end
