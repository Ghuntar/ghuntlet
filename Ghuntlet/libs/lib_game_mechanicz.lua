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
game.moblist = {}
ratmut = MONSTER:new({name = "Skeleton",realpos = COORD:new({x=240,y=260})})
game.moblist[1] = ratmut




game.itemlist = {}
game.level = smap.level

--[[ --Vieux test de quand _G[XXX] ne fonctionnait pas sous MLS
if     game.hero == "BLACKMAGE" then hero = BLACKMAGE:new()
elseif game.hero == "VALKYRIE" then hero = VALKYRIE:new()
elseif game.hero == "MAIDENGUARD" then hero = MAIDENGUARD:new()
elseif game.hero == "WHITEMAGE" then hero = WHITEMAGE:new()
else   hero = BLACKMAGE:new()
end
]]--
hero = _G[game.hero]:new()
--[[
print (game.hero)
print (_G[game.hero])
--for k,v in pairs (_G) do print (k,v) end
for k,v in pairs (Mls) do print (k,v) end
hero = _G[game.hero]:new()
]]--

hero:init()
hero.scrpos.x = 120
hero.scrpos.y = 98
hero.realpos = smap.hero_startpos

--testcoord = COORD:new({x=250,y=250})



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


    --UPKEEP : LIFE

    hero.status = hero:changelifestatus()
    if hero.status == "Dead" then game.status = "gameover" end

    for k , v in ipairs (game.moblist) do
        v.status = v:changelifestatus()
            if v.status == "Dead" then
                v = nil
                table.remove(game.moblist, k)
                end
        end

    --Read hero new direction
    local newdir = get_dir()
    if newdir ~= 0 and newdir ~= nil then
        hero.dir = newdir
        hero.move = hero:compute_move()
    else hero.move = {x = 0 , y = 0}
    end
    hero.newpos = hero.realpos + hero.move
    --Look for events (door, stairs, whatever...)

    --Look for a wall
    if not is_in_table (hero.newpos:whichtile(smap.BG_smap) , smap.BG_blocking_tiles) then  hero.realpos = hero.newpos
    else hero.realpos = hero:skirt () end
    --hero.realpos = hero.newpos
    --Compute Monsters new direction

    for k , v in ipairs (game.moblist) do
        v.dir = v:ia_mov()
        v.move = v:compute_move ()
    end

    --

    --DISPLAY : Background MAP
smap.scroll = hero.realpos - hero.scrpos + smap.offset
ScrollMap.draw(SCREEN_UP, smap.BG_smap)
ScrollMap.scroll(smap.BG_smap, smap.scroll.x, smap.scroll.y)

    --DISPLAY : Sprites
	for k , v in ipairs (game.moblist) do
		v:display()
	end
    hero:display()

    --DISPLAY : Foreground MAP
ScrollMap.draw(SCREEN_UP, smap.FG_smap)
ScrollMap.scroll(smap.FG_smap, smap.scroll.x, smap.scroll.y)


    -- DISPLAY SCREEN_DOWN
	screen.print(SCREEN_DOWN,0,0,"Press Start to exit")
	--screen.print(SCREEN_DOWN,0,8,"Press Start to exit")
	screen.print (SCREEN_DOWN, 0 , 8, "HRX: "..hero.realpos.x.." HRY: "..hero.realpos.y.." HSX: "..hero.scrpos.x.." HSY: "..hero.scrpos.y)


	render()
end

--game.status = "exit"
end

