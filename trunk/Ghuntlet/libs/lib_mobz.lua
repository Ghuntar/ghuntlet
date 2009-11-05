--lib_mobz.lua


--####################################
--#              MOBz               #
--##################################
-- MOBz are all Mobile OBjects, including Heroes, Monsters, Weapons, and more

MOB = {
	name = "Unnamed",
	race = "Unknown",
	speed = 2,
	maxlife = 100,
	width = 16,
	height = 16,
	realpos = COORD:new(),
	lastpos = COORD:new(),
	move = COORD:new(),
	dir = 3,
	status = "OK",
	touch_attack = 0,
	d_attack = "Finger",
	--attack = ATTACK:new (self.d_attack),
	spell_timer = Timer.new(),
	inventory = {}
	}

function MOB:init()
	self.half_width = self.width /2
	self.half_height = self.height /2
	self.life = self.maxlife
end

function MOB:new(obj)
	local newobject = obj or {}
	setmetatable(newobject, self)
	self.__index = self
	return newobject
end

function MOB:copy(copied)
	local newcopy = MOB:new(copied)
	return newcopy
end

function MOB:whichtile(smap)
	local currenttilex = math.floor (self.realpos.x / tile_width)
	local currenttiley = math.floor (self.realpos.y / tile_height)
	return ScrollMap.getTile(smap, currenttilex, currenttiley)
end

function MOB:changelifestatus()
	local status = "OK"
	if self.life < self.maxlife then status = "Wounded" end
	if self.life < self.maxlife*0.2 then status = "Near death" end
	if self.life < 1 then status = "Dead" end
	return status
	end

--####################################
--#              Heros              #
--##################################

HEROS = MOB:new({nickname = "Nemo"})

--####################################
--#              Monster            #
--##################################

MONSTER = MOB:new()

function MONSTER:ia_mov ()
	local newdir = 0
	if self.realpos.x < hero.realpos.x and self.realpos.y < hero.realpos.y then newdir = 8 end
	if self.realpos.x > hero.realpos.x and self.realpos.y < hero.realpos.y then newdir = 7 end
	if self.realpos.x < hero.realpos.x and self.realpos.y > hero.realpos.y then newdir = 5 end
	if self.realpos.x > hero.realpos.x and self.realpos.y > hero.realpos.y then newdir = 6 end
	return newdir
end

--####################################
--#              NPC                #
--##################################

NPC = MOB:new()

--####################################
--#              Attack             #
--##################################

ATTACK = MOB:new({age = 0, timer = Timer.new()})

--####################################
--#              Item               #
--##################################

ITEM = MOB:new()

