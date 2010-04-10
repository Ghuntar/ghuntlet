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
	newpos = COORD:new(),
	move = COORD:new(),
	dir = 3,
	status = "OK",
	touch_attack = 0,
	--d_attack = "Finger",
	--attack = ATTACK:new (self.d_attack),
	--spell_timer = Timer.new(),
	inventory = {}
	}

function MOB:init ()
	self.half_width = self.width /2
	self.half_height = self.height /2
	self.life = self.maxlife
end

function MOB:new (obj)
    local newobject = obj or {}
    self.half_width = self.width /2
    self.half_height = self.height /2
    self.diagspeed = self.speed * 0.7
    self.life = self.maxlife
    setmetatable(newobject, self)
    self.__index = self
    return newobject
end

function MOB:copy (copied)
	local newcopy = MOB:new(copied)
	return newcopy
end

function MOB:whichtile (tsmap)
	local currenttilex = math.floor (self.realpos.x / smap.tile_width)
	local currenttiley = math.floor (self.realpos.y / smap.tile_height)
	return ScrollMap.getTile(tsmap, currenttilex, currenttiley)
end

function MOB:changelifestatus ()
	local status = "OK"
	if self.life < self.maxlife then self.status = "Wounded" end
	if self.life < self.maxlife*0.2 then self.status = "Near death" end
	if self.life < 1 then self.status = "Dead" end
	end

function MOB:compute_move ()
		local move = {}
		move = COORD:new {0 , 0}
		if self.dir == 1 then  move.x = 0            move.y = -self.speed end
		if self.dir == 2 then  move.x = -self.speed  move.y = 0 end
		if self.dir == 3 then  move.x = 0            move.y = self.speed end
		if self.dir == 4 then  move.x = self.speed   move.y = 0 end
		if self.dir == 5 then  move.x = self.diagspeed   move.y = -self.speed* 0.7 end
		if self.dir == 6 then  move.x = -self.diagspeed  move.y = -self.diagspeed end
		if self.dir == 7 then  move.x = -self.diagspeed  move.y = self.diagspeed end
		if self.dir == 8 then  move.x = self.diagspeed   move.y = self.diagspeed end
		return move
		end

function MOB:skirt ()
	local temppos = COORD:new()
	temppos.x , temppos.y = self.realpos.x , self.newpos.y
	if not (is_in_table (temppos:whichtile (smap.BG_smap),smap.BG_blocking_tiles)) then return temppos end
	temppos.x , temppos.y = self.newpos.x , self.realpos.y
	if not (is_in_table (temppos:whichtile (smap.BG_smap),smap.BG_blocking_tiles)) then return temppos end
	temppos = self.realpos
	return temppos
    end
    
function MOB:playturn (mobnumber)
    self:upkeep (mobnumber) -- To see if the mob is still alive 
    self:chooseanewdir()-- To choose a new direction and get a "newpos"
    -- Not yet implemented -- To see if the "newpos" trigger an event
    self:makeamove-- To see if the "newpos" is legal (not in a wall or pitt or something else) and execute the move
    -- To see if there is a collison with something dangerous
end

function MOB:upkeep (mobnumber)
    self:changelifestatus ()
    if self.status == "Dead" then
        self = nil
        table.remove (game.moblist, mobnumber)
    end
end
    
function MOB:chooseanewdir ()
    self.dir = self:ia_mov ()
    self.move = self:compute_move ()
    self.newpos = self.realpos + self.move
end

function MOB:makeamove ()
    if not is_in_table (self.newpos:whichtile(smap.BG_smap) , smap.BG_blocking_tiles) then  self.realpos = self.newpos
    else self.realpos = self:skirt () end

end
    
--####################################
--#              Heros              #
--##################################

HEROS = MOB:new({nickname = "Nemo"})

function HEROS:upkeep ()
    self:changelifestatus ()
    if self.status == "Dead" then
    game.status = "gameover"
    end
end

function HEROS:chooseanewdir()
    local newdir = get_dir()
    if newdir ~= 0 and newdir ~= nil then
        self.dir = newdir
        self.move = self:compute_move()
    else self.move = {x = 0 , y = 0}
    end
    self.newpos = self.realpos + self.move
end

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

