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
    inmove = false,
	status = "OK",
	touch_attack = 0,
    -- d_attack = "Finger",
    -- attack = ATTACK:new (),
    -- current_attack = {},
	-- spell_timer = Timer.new(),
	inventory = {}
	}

-- function MOB:init ()
	-- self.half_width = self.width /2
	-- self.half_height = self.height /2
	-- self.life = self.maxlife
-- end

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

function MOB:destroy()
    self:destroy_display()
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
		-- local move = {}
		-- move = COORD:new {0 , 0}
        if self.dir == 0 then   self.move.x = 0           self.move.y = 0 end
		if self.dir == 1 then  self.move.x = 0            self.move.y = -self.speed end
		if self.dir == 2 then  self.move.x = -self.speed  self.move.y = 0 end
		if self.dir == 3 then  self.move.x = 0            self.move.y = self.speed end
		if self.dir == 4 then  self.move.x = self.speed   self.move.y = 0 end
		if self.dir == 5 then  self.move.x = self.diagspeed   self.move.y = -self.speed* 0.7 end
		if self.dir == 6 then  self.move.x = -self.diagspeed  self.move.y = -self.diagspeed end
		if self.dir == 7 then  self.move.x = -self.diagspeed  self.move.y = self.diagspeed end
		if self.dir == 8 then  self.move.x = self.diagspeed   self.move.y = self.diagspeed end
		-- return move
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

function MOB:collide_square (other)
    if      ((self.realpos.x + self.half_width) > (other.realpos.x - other.half_width))
        and ((self.realpos.x - self.half_width) < (other.realpos.x + other.half_width))
        and ((self.realpos.y + self.half_height) > (other.realpos.y - other.half_height))
        and ((self.realpos.y  - self.half_height) < (other.realpos.y + other.half_height))
    then return true
    else return false
    end
end

function MOB:collide_circle (other)
    if ((self.realpos.x - other.realpos.x)^2 + (self.realpos.y - other.realpos.y)^2) < (self.half_width + other.half_width)^2
    then return true
    else return false
    end
end

function MOB:collide_tile (other)
    if ((self.realpos:toMAPCOORD()) == (other.realpos:toMAPCOORD()))
    then return true
    else return false
    end
end

function MOB:playturn (mobnumber)
    self:upkeep (mobnumber) -- To see if the mob is still alive 
    self:chooseanewdir()-- To choose a new direction and get a "newpos"
    -- Not yet implemented -- To see if the "newpos" trigger an event
    if self.inmove then self:makeamove () end-- To see if the "newpos" is legal (not in a wall or pitt or something else) and execute the move
    if self:chooseifattack() then 
        self:makeanattack() 
    end
    self:collision() -- To see if there is a collison with something dangerous
end

function MOB:upkeep (mobnumber)
    self:changelifestatus ()
    if self.status == "Dead" then
    self = nil
    table.remove (game.moblist, mobnumber)
    end
end
    
function MOB:chooseanewdir ()
end

function MOB:makeamove ()
    if not is_in_table (self.newpos:whichtile(smap.BG_smap) , smap.BG_blocking_tiles)
        then self.realpos = self.newpos
        else self.realpos = self:skirt ()
    end
    self.inmove = false
end

function MOB:collision()
end

function MOB:chooseifattack ()
return false
end

function MOB:makeanattack()
end


--####################################
--#              Heros              #
--##################################

HEROS = MOB:new({name = "Hero", nickname = "Nemo", d_attack = "PENTACLE"})

function HEROS:upkeep ()
    -- self.life = self.maxlife
    self:changelifestatus ()
    if self.status == "Dead" then
    game.status = "gameover"
    end
end

function HEROS:chooseanewdir()
    local newdir = get_dir()
    if newdir ~= 0 and newdir ~= nil then
        self.dir = newdir
        self:compute_move()
        self.inmove = true
    else self.move = {x = 0 , y = 0}
    end
    self.newpos = self.realpos + self.move
end

function HEROS:makeamove ()
    for k,v in ipairs (smap.event_list) do
    if self.newpos:toMAPCOORD() == v.coordm
        then
            screen.print (SCREEN_DOWN, 48, 16, "EVENT !")
            if v.event_type == "door"
                then
                    door(v.coordm,self)
                    table.remove (smap.event_list,k)
                end
            if v.event_type == "stairs" then stairs(v.level) end
        end
    end

    if not is_in_table (self.newpos:whichtile(smap.BG_smap) , smap.BG_blocking_tiles)
        then self.realpos = self.newpos
        else self.realpos = self:skirt ()
    end
    self.inmove = false
end

function HEROS:collision()
    for k, v in ipairs (game.moblist) do
        if v.touch_attack ~= 0 then 
            if game.settings.collide == 0 then if self:collide_square(v) then self.life = self.life - v.touch_attack end 
            elseif game.settings.collide == 1 then if self:collide_circle(v) then self.life = self.life - v.touch_attack end
            elseif game.settings.collide == 2 then if self:collide_tile(v) then self.life = self.life - v.touch_attack end
            end
        end
    end
end

function HEROS:chooseifattack ()
    if  (Keys.newPress.L) then return true
    else return false
    end
end

function HEROS:makeanattack()
    if self.attack.timer:time() == 0 then
        self.attack.realpos = self.realpos
        self.attack.dir = self.dir
        self.attack.timer:start()
    end
end

--####################################
--#              Monster            #
--##################################

MONSTER = MOB:new({name = "Monster"})

function MONSTER:chooseanewdir ()
    self:ia_mov ()
    self:compute_move ()
    self.newpos = self.realpos + self.move
    self.inmove = true

end

function MONSTER:ia_mov ()
	-- local newdir = 0
    self.dir = 0
	if self.realpos.x < hero.realpos.x and self.realpos.y < hero.realpos.y then self.dir = 8 end
	if self.realpos.x > hero.realpos.x and self.realpos.y < hero.realpos.y then self.dir = 7 end
	if self.realpos.x < hero.realpos.x and self.realpos.y > hero.realpos.y then self.dir = 5 end
	if self.realpos.x > hero.realpos.x and self.realpos.y > hero.realpos.y then self.dir = 6 end
    self.inmove = true
	-- return newdir
end

function MONSTER:collision ()
    if  game.settings.collide == 0 then  if self:collide_square(hero.attack) then self.life = self.life - hero.attack.touch_attack end
    elseif game.settings.collide == 1 then if self:collide_circle(hero.attack) then self.life = self.life - hero.attack.touch_attack end
    elseif game.settings.collide == 2 then if self:collide_tile(hero.attack) then self.life = self.life - hero.attack.touch_attack end
    end
end
--####################################
--#              NPC                #
--##################################

NPC = MOB:new()

--####################################
--#              Attack             #
--##################################

ATTACK = MOB:new({name = "Attack", timer = Timer.new()})

function ATTACK:upkeep()
    if self.timer:time() > 500 then do
        self.realpos = {x = -0,y = -0}
        self.dir = 0
        self.timer:stop()
        self.timer:reset()
    end
    end
end

function ATTACK:chooseanewdir ()
    self:compute_move ()
    self.newpos = self.realpos + self.move
    -- if not (self.newpos == self realpos) then 
    self.inmove = true
    -- end
    end

function ATTACK:makeamove ()
    if not is_in_table (self.newpos:whichtile(smap.BG_smap) , smap.BG_blocking_tiles)
    then    self.realpos = self.newpos
    else    self.realpos = {x=0,y=0} 
            self.newpos = {x=0,y=0}
            self.dir = 0
            self.timer:stop()
            self.timer:reset()
    end
end

--####################################
--#              Item               #
--##################################

ITEM = MOB:new({name = "Item"})

