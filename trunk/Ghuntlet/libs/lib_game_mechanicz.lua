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

function COORD:whichtile(tsmap)
	local currenttilex = math.floor (self.x / smap.tile_width)
	local currenttiley = math.floor (self.y / smap.tile_height)
	return ScrollMap.getTile(tsmap, currenttilex, currenttiley)
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
--#              STATUS             #
--##################################


function gameover()

end

function ingame()

-- Initialisation



--test pour génération de MOB --START--

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
--test pour génération de MOB --STOP--




game.itemlist = {}
game.level = smap.level
game.clock = Timer.new()
game.skippedframes = 0

hero = _G[game.hero]:new()
hero:init()
hero.scrpos.x = 120
hero.scrpos.y = 98
hero.realpos = smap.hero_startpos



--Controls.read()

---------------
-- Main loop --
---------------

while (game.status == "ingame" or game.status == "pause") do
    Controls.read()
    --UPKEEP : GAME STATUS
    if (Keys.newPress.Start and (#game.moblist > 0)) then game.status = "exit" end
    if (Keys.newPress.Start and (#game.moblist < 1)) then game.status = "exit" end
    if game.status == "pause" then pause () end

game.clock:start()

-- tests de génération de MOB --START--
if (Keys.newPress.A)
then game.moblist[#game.moblist + 1] = SKELETON:new({name = "Skeleton",realpos = COORD:new({x=math.random(112,332),y=math.random(120,332)})})
end
if (Keys.newPress.B)
then table.remove (game.moblist, #game.moblist)
end
-- tests de génération de MOB --STOP--


hero:playturn()
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
    -- -Attacks
    -- Not yet implemented
    
    --DISPLAY : Foreground MAP
ScrollMap.draw(SCREEN_UP, smap.FG_smap)
ScrollMap.scroll(smap.FG_smap, smap.scroll.x, smap.scroll.y)

    --DISPLAY : HUD & Floating text
    -- Hero Status
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

    -- Game information
    if #game.moblist > 0 then screen.print (SCREEN_UP, justify (35) , 8 , "Kill "..#game.moblist.." more to complete the Level")
    else screen.print (SCREEN_UP, justify (30) , 8 , "Level completed : PRESS START") end

    
    -- DISPLAY SCREEN_DOWN
	screen.print(SCREEN_DOWN,0,0,"Press Start to exit")
	--screen.print(SCREEN_DOWN,0,8,"Press Start to exit")
	screen.print (SCREEN_DOWN, 0, 8, "HRX: "..hero.realpos.x.." HRY: "..hero.realpos.y.." HSX: "..hero.scrpos.x.." HSY: "..hero.scrpos.y)
    screen.print (SCREEN_DOWN, 0, 16, "Timer = "..game.clock:time()..".")
    if (game.clock:time () > 30) then
    game.skippedframes = game.skippedframes + 1
	screen.print(SCREEN_DOWN,0,24,"SKIPPED FRAMES")
    end
	screen.print(SCREEN_DOWN,0,32,"SKIPPED FRAMES : "..game.skippedframes)


	render()
game.clock:stop()
game.clock:reset()

end


--game.status = "exit"
end

