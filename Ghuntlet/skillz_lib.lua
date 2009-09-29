--skillz_lib.lua


-- Attack is the default Spell (and is not particulary a spell ^^)
Attack = {}
Attack_mt = {}
Attack_mt.__index = Attack

function Attack.new (...)
	return setmetatable ({
					name = arg[1] or "Unnamed",
					}, Attack_mt)
end

function Attack:init()
	self.speed = 4
	self.width = 16
	self.height = 16
	self.half_width = self.width / 2
	self.half_height = self.height / 2
	self.realpos = {0,0}
	self.lastpos = {0,0}
	self.scrpos = {0,0}
	self.move = {0,0}
	self.dir = 0
	self.age = 0
	self.timer = Timer.new()
	self:init_sprite()
end




Spell = {}
Spell_mt = {}
Spell_mt.__index = Spell

function Spell.new (...)
	return setmetatable ({
					name = arg[1] or "Unnamed",
					}, Spell_mt)
end





