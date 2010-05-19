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

function COORD:REALtoMAP()
    local currenttilex = math.floor (self.x / smap.tile_width)
    local currenttiley = math.floor (self.y / smap.tile_height)
    return COORD:new ({x = currenttilex, y = currenttiley})
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
        if value == v
        then
            return true
        end
    end
    return false
end

--####################################
--#              Events             #
--##################################

function door(coordm,mob)
    -- screen.print (SCREEN_DOWN, 48, 24, "DOOR !")
    local doorstate = false
    Debug.print ("DOOR !")
    for k,v in ipairs (mob.inventory) do
        if v.name == "Key"
        then
            ScrollMap.setTile(smap.BG_smap, coordm.x, coordm.y, smap.default_tile)
            table.remove (hero.inventory, k)
            doorstate = true
            break
        end
    end
    return doorstate
end

function stairs(level)
    -- screen.print (SCREEN_DOWN, 8, 24, "STAIRS to : "..level)
    Debug.print ("STAIRS to : "..level)
    game.curentmap = level
    game.status = "select_plan"

end

function savegame()
    local save = {}
    save.game = {}
    save.game.hero = game.hero
    save.game.curentmap = game.curentmap
    save.hero = {}
    save.hero.nickname = hero.nickname
    save.hero.life = tostring (hero.life)
    INI.save ("./saves/"..hero.nickname..".sav",save)
    print ("Save completed")
end

function loadgame()
    local load = {}
    load = INI.load ("./saves/"..hero.nickname..".sav")
    game.hero = load.game.hero
    game.curentmap = load.game.curentmap
    hero.nickname = load.hero.nickname
    hero.life = tonumber (load.hero.life)
    game.status = "select_plan"
    print "Load completed"
end

--####################################
--#              STATUS             #
--##################################


function gameover ()
	while (not Keys.newPress.Start) do
		Controls.read()
		--screen.print(SCREEN_DOWN, 0, 32,"Game status : "..game.status)
		screen.print(SCREEN_DOWN, 100, 40,"Game Over",game.text_color)
		screen.print(SCREEN_DOWN, 75, 80,"Press Start to reset",game.text_color)
		render()
	end
	game.status = "select_game"
end

function ingame()

-- Initialisation

game.settings = {}
game.settings.floatingtext = true
game.settings.displaymobz = true
game.settings.collide = 0
game.clock = Timer.new()

if not smap.mob_list
then
    smap.mob_list = {}
end

if not smap.item_list
then
    smap.item_list = {}
end

if not smap.event_list
then
    smap.event_list = {}
end


hero = _G[game.hero]:new()
hero.scrpos = COORD:new({x=120,y=98})
hero.realpos = smap.hero_startpos
dofile ("./datas/".._G[game.hero].d_attack..".lua")
dofile ("./datas/".._G[game.hero].d_attack..".ds.lua")
hero.attack = _G[hero.d_attack]:new({owner = hero})


--Controls.read()

---------------
-- Main loop --
---------------

while (game.status == "ingame" or game.status == "pause") do
-- Read control state
Controls.read()
-- Start the timer for this turn
game.clock:start()

-- Controls definition :
if (Keys.newPress.Start)
then
    game.status = "pause"
    pause ()
end

if (Keys.newPress.A and smap.mob_type_list[1])
then
    smap.mob_list[#smap.mob_list + 1] = _G[smap.mob_type_list[1]]:new({realpos = COORD:new({x=math.random(112,332),y=math.random(120,332)})})
end

if (Keys.newPress.B)
then
    table.remove (smap.mob_list, #smap.mob_list)
end

if (Keys.newPress.X)
then
    game.settings.displaymobz = not game.settings.displaymobz
    game.settings.floatingtext = not game.settings.floatingtext
end

if (Keys.newPress.Y)
then
    game.settings.collide = (game.settings.collide+1)%4
end

if Stylus.newPress
then
    if hero.inventory[1]
    then
        hero.inventory[#hero.inventory]:drop(hero)
        table.remove(hero.inventory, #hero.inventory)
    end
end

-- Play the Hero turn
hero:playturn()
hero.attack:playturn()

-- Play the Monsters turn
for k , v in ipairs (smap.mob_list) do
    v:playturn(k)
    if (game.clock:time () > 30)
    then
        break
    end
end

-- Check for Item takeover
for k , v in ipairs (smap.item_list) do
    if v:collision()
    then
        table.remove (smap.item_list, k)
        v:get(hero)
    end
    if (game.clock:time () > 30)
    then
        break
    end
end

-- :: Display ::

    --DISPLAY : Background MAP
smap.scroll = hero.realpos - hero.scrpos + smap.offset
ScrollMap.draw(SCREEN_UP, smap.BG_smap)
ScrollMap.scroll(smap.BG_smap, smap.scroll.x, smap.scroll.y)

    --DISPLAY : Sprites
    -- -Items & Drops
    for k , v in ipairs (smap.item_list) do
        v:display()
    end
    -- -Monsters
    if game.settings.displaymobz
    then
        for k , v in ipairs (smap.mob_list) do
            v:display()
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
    screen.print (SCREEN_UP, hero.scrpos.x, hero.scrpos.y - hero.spr_height, hero.status, game.c_bone)
    screen.print (SCREEN_UP, hero.scrpos.x, hero.scrpos.y - hero.spr_height/2, hero.life, game.c_bone)
    -- Monsters status
    for k, v in ipairs (smap.mob_list) do
        screen.print (SCREEN_UP, v.scrpos.x, v.scrpos.y - v.spr_height, v.status, game.c_snot)
        screen.print (SCREEN_UP, v.scrpos.x, v.scrpos.y - v.spr_height/2, v.life, game.c_snot)
    end
end

    -- Game information
    if #smap.mob_list > 0 then screen.print (SCREEN_UP, justify (35) , 8 , "Kill "..#smap.mob_list.." more to clean the Level", game.c_blood)
    else screen.print (SCREEN_UP, justify (35) , 8 , "Level cleaned : Go to the stairs !" ,game.c_snot) end

    
    -- DISPLAY SCREEN_DOWN
    screen.print(SCREEN_UP,0,184,"Press Start to PAUSE",game.c_marine)
    Debug.print("Collision mode : "..game.settings.collide)
    Debug.print("Hero X : "..hero.realpos.x)
    Debug.print("Hero Y : "..hero.realpos.y)
    screen.print(SCREEN_DOWN, 0, 184, "FPS: "..NB_FPS,game.c_blood)

    for k,v in ipairs (hero.inventory) do
        v.scrpos.x = 48 + 16*math.mod(k-1, 4)
        v.scrpos.y = 48 + 16*math.floor((k-1)/4)
        v:inventory_display()
    end

	render()
    Debug.clear()
game.clock:stop()
game.clock:reset()

end


--game.status = "exit"

game.clock = nil
for k, v in pairs (smap.mob_type_list) do
    _G[v]:destroy()
    end
smap.mob_type_list = nil
smap.mob_list = nil
smap.item_list = nil
smap.event_list = nil
if smap.BG_smap then ScrollMap.destroy(smap.BG_smap) smap.BG_smap = nil end
if smap.FG_smap then ScrollMap.destroy(smap.FG_smap) smap.FG_smap = nil end
if smap.BG_Tileset then Image.destroy(smap.BG_Tileset) smap.BG_Tileset = nil end
if smap.FG_Tileset then Image.destroy(smap.FG_Tileset) smap.FG_Tileset = nil end
smap = {}
end
