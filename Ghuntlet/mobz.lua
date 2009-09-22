--mobz.lua



Monster = {}
Monster_mt = {}

function Monster.new (...)
	return setmetatable ({
					name = arg[1] or "Unnamed",
					startpos = {unpack (arg[2])} or {0 , 0},
					}, Monster_mt)
end

function Monster:init(self)
	self.race = "Unknown"
	self.speed = 1
	self.maxlife = 5
	self.width = 16
	self.height = 16
	if self.name == "Skeleton" then
		self.race = "Undead"
		self.speed = 2
		self.maxlife = 20
		self.width = 16
		self.height = 16
	end
	if self.name == "Ratmut" then
		self.race = "Undead"
		self.speed = 1
		self.maxlife = 20
		self.width = 16
		self.height = 16
	end
	self.realpos = {unpack(self.startpos)}
	self.lastpos = {0,0}
	self.scrpos = {0,0}
	self.move = {0,0}
	self.dir = 0
	self.life = self.maxlife
	self.status = "OK"
end

function Monster:ia_mov (self)
	local newdir = 0
	if self.realpos[1] < hero.realpos[1] and self.realpos[2] < hero.realpos[2] then newdir = 8 end
	if self.realpos[1] > hero.realpos[1] and self.realpos[2] < hero.realpos[2] then newdir = 7 end
	if self.realpos[1] < hero.realpos[1] and self.realpos[2] > hero.realpos[2] then newdir = 5 end
	if self.realpos[1] > hero.realpos[1] and self.realpos[2] > hero.realpos[2] then newdir = 6 end
	return newdir
end


--####################################################

--dir
--6|1|5
--2|0|4
--7|3|8

function ia_mov (mob)
local newdir = 0
if mob.realpos[1] < hero.realpos[1] and mob.realpos[2] < hero.realpos[2] then newdir = 8 end
if mob.realpos[1] > hero.realpos[1] and mob.realpos[2] < hero.realpos[2] then newdir = 7 end
if mob.realpos[1] < hero.realpos[1] and mob.realpos[2] > hero.realpos[2] then newdir = 5 end
if mob.realpos[1] > hero.realpos[1] and mob.realpos[2] > hero.realpos[2] then newdir = 6 end
return newdir
end

