--lib_game_mechanicz.lua


--####################################
--#              COORD              #
--##################################

COORD = {
		x = 0,
		y = 0
		}

function COORD:new(obj)
	local newobject = obj or {}
	setmetatable(newobject, self)
	self.__index = self
	return newobject
end

function COORD.add(other)
	local new = COORD:new()
	new.x = self.x + other.x
	new.y = self.y + other.y
	return new
end

function COORD.__add(obj1,obj2)
	local new = COORD:new()
	new.x = obj1.x + obj2.x
	new.y = obj1.y + obj2.y
	return new
end

function COORD.__sub(obj1,obj2)
	local new = COORD:new()
	new.x = obj1.x - obj2.x
	new.y = obj1.y - obj2.y
	return new
end

function COORD.__mul(obj1,mul)
    local new = COORD:new()
    new.x = obj1.x * mul
    new.y = obj1.y * mul
    return new
end

function COORD.__eq(obj1,obj2)
    if (obj1.x == obj2.x) and (obj1.y == obj2.y)
        then return true
        else return false
    end
end

function COORD:whichtile(tsmap)
    local currenttilex = math.floor (self.x / smap.tile_width)
    local currenttiley = math.floor (self.y / smap.tile_height)
    return ScrollMap.getTile(tsmap, currenttilex, currenttiley)
end

-- function COORD:wichtile_M(tsmap)
-- return ScrollMap.getTile(tsmap, self.x, self.y)
-- end

-- function COORD:toMAPCOORD()
    -- local currenttilex = math.floor (self.x / smap.tile_width)
    -- local currenttiley = math.floor (self.y / smap.tile_height)
    -- return COORD:new ({x = currenttilex, y =currenttiley})
-- end

function COORD:REALtoMAP()
    local currenttilex = math.floor (self.x / smap.tile_width)
    local currenttiley = math.floor (self.y / smap.tile_height)
    return COORD:new ({x = currenttilex, y =currenttiley})
end

function COORD:MAPtoREAL()
    local currenttilex = self.x * smap.tile_width
    local currenttiley = self.y * smap.tile_height
    return COORD:new ({x = currenttilex, y =currenttiley})
end

function COORD:align()
    local new = COORD:new()
    new = self:REALtoMAP() * smap.tile_width
    return new
end

--####################################
--#              Misc               #
--##################################

-- This function test if value "value" is in a table "array"
function is_in_table (value , array)
	for k, v in pairs (array) do
		if value == v then return true end
	end
	return false
end

--####################################
--#              Events             #
--##################################

function door(coordm,mob)
    screen.print (SCREEN_DOWN, 48, 24, "DOOR !")
    -- for k,v in ipairs (mob.inventory) do
    -- if v.name == "key" then ScrollMap.setTile(smap.BG_smap, current_tile_coord[1], current_tile_coord[2], smap.default_tile) table.remove (hero.inventory, k) end
    -- end
    ScrollMap.setTile(smap.BG_smap, coordm.x, coordm.y, smap.default_tile)
end

function stairs(level)
    screen.print (SCREEN_DOWN, 8, 24, "STAIRS to : "..level)
    game.curentmap = level
    game.status = "select_plan"

end

function savegame()
    save = {}
    save.game = {}
    save.game.hero = game.hero
    save.hero = {}
    save.hero.nickname = hero.nickname
    save.hero.life = tostring (hero.life)
    INI.save("./saves/"..hero.nickname..".sav",save)
    print ("Save completed")
end

function loadgame()
    -- To be implemented
end

--####################################
--#              STATUS             #
--##################################


function gameover ()
	while (not Keys.newPress.Start) do
		Controls.read()
		--screen.print(SCREEN_DOWN, 0, 32,"Game status : "..game.status)
		screen.print(SCREEN_DOWN, 100, 40,"Game Over")
		screen.print(SCREEN_DOWN, 75, 80,"Press Start to reset")
		render()
	end
    game.hero = nil
    game.curentmap = "Dungeon_01"
	game.status = "select_game"
end

function ingame()

-- Initialisation

game.settings = {}
game.settings.floatingtext = true
game.settings.collide = 0

--test pour g�n�ration de MOB --START--

game.mob_type_list = {"SKELETON","BLACKMAGE_LB"}
for k, v in pairs (game.mob_type_list) do
    dofile ("./datas/"..v..".lua")
    dofile ("./datas/"..v..".ds.lua")
    end

game.moblist = {}

-- for i=1,100 do
    -- game.moblist[i] = SKELETON:new({name = "Skeleton",realpos = COORD:new({x=math.random(112,332),y=math.random(120,332)})})
    -- end
-- for i =101,150 do
    -- game.moblist[i] = BLACKMAGE_LB:new({name = "BlackMage",realpos = COORD:new({x=math.random(112,332),y=math.random(120,332)})})
    -- end
--test pour g�n�ration de MOB --STOP--




game.itemlist = {}
-- game.level = smap.level
game.clock = Timer.new()
-- game.skippedframes = 0

hero = _G[game.hero]:new()
-- hero:init()
hero.scrpos.x = 120
hero.scrpos.y = 98
hero.realpos = smap.hero_startpos
dofile ("./datas/".._G[game.hero].d_attack..".lua")
dofile ("./datas/".._G[game.hero].d_attack..".ds.lua")
hero.attack = _G[hero.d_attack]:new()
-- hero.attack = PENTACLE:new()


--Controls.read()

---------------
-- Main loop --
---------------

while (game.status == "ingame" or game.status == "pause") do
    Controls.read()
    --UPKEEP : GAME STATUS
    if (Keys.newPress.Start and (#game.moblist > 0)) then game.status = "pause" end
    if (Keys.newPress.Start and (#game.moblist < 1)) then game.status = "pause" end
    if game.status == "pause" then pause () end

game.clock:start()

-- tests de g�n�ration de MOB --START--
if (Keys.newPress.A)
then game.moblist[#game.moblist + 1] = SKELETON:new({name = "Skeleton",realpos = COORD:new({x=math.random(112,332),y=math.random(120,332)})})
end
if (Keys.newPress.B)
    then table.remove (game.moblist, #game.moblist)
end
if (Keys.newPress.X)
    then
        if game.settings.floatingtext == true then game.settings.floatingtext = false
        else if game.settings.floatingtext == false then game.settings.floatingtext = true end
    end
end
if (Keys.newPress.Y)
    then game.settings.collide = (game.settings.collide+1)%2
end

-- tests de g�n�ration de MOB --STOP--


hero:playturn()
hero.attack:playturn()
for k , v in ipairs (game.moblist) do
    v:playturn(k)
    if (game.clock:time () > 30) then
        game.clock:stop ()
        break
    end
end

    --DISPLAY : Background MAP
smap.scroll = hero.realpos - hero.scrpos + smap.offset
ScrollMap.draw(SCREEN_UP, smap.BG_smap)
ScrollMap.scroll(smap.BG_smap, smap.scroll.x, smap.scroll.y)

    --DISPLAY : Sprites
    -- - Items & Drops
    -- Not yet implemented
    -- -Monsters
	for k , v in ipairs (game.moblist) do
		v:display()
    if (game.clock:time () > 30) then
        game.clock:stop ()
        break
    end
	end
    -- -Hero
    hero:display()
    hero.attack:display()
    -- -Attacks
    -- Not yet implemented
    
    --DISPLAY : Foreground MAP
ScrollMap.draw(SCREEN_UP, smap.FG_smap)
ScrollMap.scroll(smap.FG_smap, smap.scroll.x, smap.scroll.y)

    --DISPLAY : HUD & Floating text
if game.settings.floatingtext then 
    -- Hero status
    screen.print (SCREEN_UP, hero.scrpos.x, hero.scrpos.y - hero.spr_height, hero.status)
    screen.print (SCREEN_UP, hero.scrpos.x, hero.scrpos.y - hero.spr_height/2, hero.life)
    -- Monsters status
    for k, v in ipairs (game.moblist) do
        screen.print (SCREEN_UP, v.scrpos.x, v.scrpos.y - v.spr_height, v.status)
        screen.print (SCREEN_UP, v.scrpos.x, v.scrpos.y - v.spr_height/2, v.life)
    if (game.clock:time () > 30) then
        game.clock:stop ()
        break
    end
    end
end

    -- Game information
    if #game.moblist > 0 then screen.print (SCREEN_UP, justify (35) , 8 , "Kill "..#game.moblist.." more to complete the Level")
    else screen.print (SCREEN_UP, justify (30) , 8 , "Level completed : PRESS START") end

    
    -- DISPLAY SCREEN_DOWN
    screen.print(SCREEN_DOWN,0,0,"Press Start to exit")
    --screen.print(SCREEN_DOWN,0,8,"Press Start to exit")
    -- screen.print (SCREEN_DOWN, 0, 8, "HRX: "..hero.realpos.x.." HRY: "..hero.realpos.y.." HSX: "..hero.scrpos.x.." HSY: "..hero.scrpos.y)
    -- screen.print (SCREEN_DOWN, 0, 16, "Timer = "..game.clock:time()..".")
    screen.print (SCREEN_DOWN, 0, 24, game.settings.collide)
    screen.print(SCREEN_DOWN, 0, 184, "FPS: "..NB_FPS)
    -- if (game.clock:time () > 30) then
    -- game.skippedframes = game.skippedframes + 1
	-- screen.print(SCREEN_DOWN,0,24,"SKIPPED FRAMES")
    -- end
	-- screen.print(SCREEN_DOWN,0,32,"SKIPPED FRAMES : "..game.skippedframes)


	render()
game.clock:stop()
game.clock:reset()

end


--game.status = "exit"

game.clock = nil
game.itemlist = nil
for k, v in pairs (game.mob_type_list) do
    _G[v]:destroy()
    end
game.mob_type_list = nil
if smap.BG_smap then ScrollMap.destroy(smap.BG_smap) end
if smap.FG_smap then ScrollMap.destroy(smap.FG_smap) end
if smap.BG_Tileset then Image.destroy(smap.BG_Tileset) end
if smap.FG_Tileset then Image.destroy(smap.FG_Tileset) end
smap = nil
end