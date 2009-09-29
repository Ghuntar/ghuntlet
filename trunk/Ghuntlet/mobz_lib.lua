--mobz.lua



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
	self.half_width = self.width / 2
	self.half_height = self.height / 2
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
	if self.name == "BlackMage" then
		self.race = "Human"
		self.speed = 1
		self.maxlife = 10
		self.width = 16
		self.height = 16
	end
	if self.name == "Scarab" then
		self.race = "Bug"
		self.speed = 2
		self.maxlife = 10
		self.width = 16
		self.height = 16
	end
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


--####################################################

--dir
--6|1|5
--2|0|4
--7|3|8
