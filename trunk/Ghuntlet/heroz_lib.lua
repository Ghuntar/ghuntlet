--heroz.lua

Heros = {}
Heros_mt = {}
Heros_mt.__index = Heros

function Heros.new (...)
	return setmetatable ({
					name = arg[1] or "Unnamed",
					startpos = {unpack (arg[2])} or {0 , 0},
					}, Heros_mt)
end

function Heros:init()
	self.race = "Unknown"
	self.speed = 2
	self.maxlife = 100
	self.width = 16
	self.height = 16
	self.half_width = self.width / 2
	self.half_height = self.height / 2
	self.d_attack = "pentacle"
	if self.name == "BlackMage" then
		self.race = "Human"
		self.speed = 4
		self.maxlife = 500
		self.width = 16
		self.height = 16
		self.d_attack = "pentacle"
	end
	if self.name == "Valkyrie" then
		self.race = "Human"
		self.speed = 4
		self.maxlife = 150
		self.width = 16
		self.height = 16
		self.d_attack = "doubleaxe"
	end
	if self.name == "MaidenGuard" then
		self.race = "Human"
		self.speed = 3
		self.maxlife = 200
		self.width = 16
		self.height = 16
		self.d_attack = "axe"
	end
	if self.name == "WhiteMage" then
		self.race = "Human"
		self.speed = 3
		self.maxlife = 100
		self.width = 16
		self.height = 16
		self.d_attack = "smite"
	end
	self.realpos = {unpack(self.startpos)}
	self.lastpos = {0,0}
	self.scrpos = {120,88}
	self.move = {0,0}
	self.dir = 3
	self.life = self.maxlife
	self.status = "OK"
	self.attack = Attack.new (self.d_attack)
	self.attack:init()
	self.inventory = {}
end
