function ingame ()
Controls.read()
-- Decrlaration des variables

-- Coordonnées de la map
local smap_coord = {tile_width/2 ,tile_height/2}
local max_x = map_width * tile_width
local max_y = map_height * tile_height

-- Liste des mobs (PNJs, monstres, armes des monstres etc... )
moblist = {}
--print (moblist)
-- Liste des objets (Clefs, coffres, boni, ... )
local itemlist = {}

-- Définition du héros
hero = Heros.new (game.hero, hero_startpos)
hero_startpos = nil
hero:init () -- Définition du héros et de son arme
hero:init_sprite()

-- Définition des mobz (la smap.monster_list est générée par le fichier.plan.lua)
for k,v in ipairs (smap.monster_list) do
moblist[k] = Monster.new (v[1],v[2])
end
smap.monster_list = nil
for k,v in ipairs (moblist) do v:init() v:init_sprite()end

-- Définition des objets
for k,v in ipairs (smap.item_list) do
itemlist[k] = Item.new (v[1],v[2])
end
smap.item_list = nil
for k,v in ipairs (itemlist) do v:init() v:init_sprite()end

-- MAIN while
while (game.status == "ingame" or game.status == "pause") do

--UPKEEP START
----UPKEEP WPN

	if hero.attack.timer:time() > 500 then
		hero.attack.realpos = {0 ,0}
		hero.attack.move = {0 , 0}
		hero.attack.dir = 0
		hero.attack.age = hero.attack.timer:time()
		hero.attack.timer:stop()
		hero.attack.timer:reset()
	end

----UPKEEP LIFE
hero.status = changelifestatus (hero)

for k , v in ipairs (moblist)
	do v.status = changelifestatus (v)
	if v.status == "Dead" then	v.sprite = nil
								table.insert (itemlist,Item.new ("deadbody", v.realpos))
								itemlist[#itemlist]:init()
								itemlist[#itemlist]:init_sprite()
								v = nil table.remove(moblist, k)
								end
	end

----UPKEEP STATUS
if hero.status == "Dead" then game.status = "gameover" end
if (Keys.newPress.Start and (#moblist > 0)) then game.status = "pause" end
if (Keys.newPress.Start and (#moblist < 1)) then game.status = "select_plan" end
if game.status == "pause" then pause () end
--UPKEEP STOP

-- Contrôle de la croix de direction calcul du mouvement du héros
local newdir = get_dir()
if newdir ~= 0 and newdir ~= nil then
	hero.dir = newdir
	hero.move = compute_move (hero)
else hero.move = {0 , 0}
end

-- Vérification de la légalité du mouvement du hero
	hero.lastpos = {unpack(hero.realpos)}
	hero.realpos = compute_new_coords (hero , hero.move)
	if hero.realpos[1] < 0 then hero.realpos[1] = 0 end
	if hero.realpos[1] > max_x then hero.realpos[1] = max_x end
	if hero.realpos[2] < 0 then hero.realpos[2] = 0 end
	if hero.realpos[2] > max_y then hero.realpos[2] = max_y end
	if in_table (smap.doors , Whichtile (hero.realpos, smap.BG_smap)) then event_door (hero) end
	if in_table (smap.stairs , Whichtile (hero.realpos, smap.BG_smap)) then event_stairs (hero) end
	--if in_table (smap.BG_blocking_tiles , Whichtile (hero.realpos, smap.BG_smap)) then hero.realpos = {unpack(hero.lastpos)} end
	if in_table (smap.BG_blocking_tiles , Whichtile (hero.realpos, smap.BG_smap)) then hero.realpos = skirt (hero) end

--Contrôle de déclanchement de l'arme

	if Keys.newPress.L and hero.attack.timer:time() == 0 then
		hero.attack.realpos = {unpack(hero.realpos)}
		hero.attack.dir = hero.dir
		hero.attack.move = compute_move (hero.attack)
		hero.attack.realpos = compute_new_coords (hero.attack , hero.attack.move)
		hero.attack.timer:start()
	end

-- Calcul du mouvement de l'arme
	--wpn.lastpos = {unpack (wpn.realpos)} --pas vraiment utile ici
	hero.attack.realpos = compute_new_coords (hero.attack , hero.attack.move)
	if in_table (smap.BG_blocking_tiles , Whichtile (hero.attack.realpos, smap.BG_smap))
	then hero.attack.realpos = {0 ,0}
		hero.attack.move = {0 , 0}
		hero.attack.dir = 0
		hero.attack.age = hero.attack.timer:time()
		hero.attack.timer:stop()
		hero.attack.timer:reset()
	end

-- Attack des mobs

for k , mob in ipairs (moblist) do
mob:ia_attack()
end


-- Calcul du mouvement des mobs
for k , v in ipairs (moblist) do
	v.dir = v:ia_mov()
	v.move = compute_move (v)
	v.lastpos = {unpack (v.realpos)}
	v.realpos = compute_new_coords (v , v.move)
--	screen.print(SCREEN_DOWN, 10, 10 + 10*k, v.realpos[1].."-"..v.realpos[2])
	--if in_table (smap.BG_blocking_tiles , Whichtile (v.realpos, smap.BG_smap)) then v.realpos = {unpack(v.lastpos)} end
	if in_table (smap.BG_blocking_tiles , Whichtile (v.realpos, smap.BG_smap)) then v.realpos = skirt (v) end
--	screen.print(SCREEN_DOWN, 100, 10 + 10*k, v.realpos[1].."-"..v.realpos[2])

end




-- Collision test
for k , v in ipairs (moblist) do
	if collide (hero,v) then hero.status = "HIT" hero.life = hero.life - v.touch_attack end
	if collide (v,hero.attack) then v.status = "HIT" v.life = v.life - 1 end
end

-- Background display
smap_coord[1] = hero.realpos[1] - hero.scrpos[1] -8
smap_coord[2] = hero.realpos[2] - hero.scrpos[2] -8
ScrollMap.draw(SCREEN_UP, smap.BG_smap)
ScrollMap.scroll(smap.BG_smap, smap_coord[1], smap_coord[2])

-- Items/Drops display

for k , v in ipairs (itemlist) do
	v:display()
	if collide (hero,v) then v.realpos = nil v.scrpos = nil table.remove(itemlist, k) table.insert (hero.inventory,v) end
end

-- Hero display
	hero:display()

-- Monsters display
for k , v in ipairs (moblist) do
	v:display()
end

-- Attack display
	if hero.attack.timer:time() > 0 then
	hero.attack.scrpos = displaycoords (hero.attack.realpos)
	hero.attack:display()
	end

-- Foreground display
ScrollMap.draw(SCREEN_UP, smap.FG_smap)
ScrollMap.scroll(smap.FG_smap, smap_coord[1], smap_coord[2])

--- HUD
-- Hero Status
	screen.print (SCREEN_UP, hero.scrpos[1], hero.scrpos[2] - hero.spr_height, hero.status)
	screen.print (SCREEN_UP, hero.scrpos[1], hero.scrpos[2] - hero.spr_height/2, hero.life)
-- Inventory
--screen.blit(SCREEN_DOWN, 0, 0, inventory_background)
for k , v in ipairs (hero.inventory) do v.scrpos = {8,16+k*16} v:inventory_display() end
-- Monsters status
for k, v in ipairs (moblist) do
	screen.print (SCREEN_UP, v.scrpos[1], v.scrpos[2] - v.spr_height, v.status)
	screen.print (SCREEN_UP, v.scrpos[1], v.scrpos[2] - v.spr_height/2, v.life)
end

-- Game information
if #moblist > 0 then screen.print (SCREEN_UP, justify (35) , 8 , "Kill "..#moblist.." more to complete the Level")
else screen.print (SCREEN_UP, justify (30) , 8 , "Level completed : PRESS START") end

--- Info SCREEN_DOWN
--[[	screen.print(SCREEN_DOWN, 0, 0, "Press START to quit")
	screen.print(SCREEN_DOWN, 0, 8,"Press L to Cast a Spell")
	screen.print(SCREEN_DOWN, 150, 24, "FPS: "..NB_FPS)
	screen.print(SCREEN_DOWN, 0, 56, "Max.RX : "..maxrealx)
	screen.print(SCREEN_DOWN, 85, 56, "Max.RY : "..maxrealy)
	screen.print(SCREEN_DOWN, 0, 96, hero.name)
	screen.print(SCREEN_DOWN, 0, 104,"11")
	screen.print(SCREEN_DOWN, 0, 112,"12")
	screen.print(SCREEN_DOWN, 0, 120,"13")
	screen.print(SCREEN_DOWN, 0, 128,"14")
	screen.print(SCREEN_DOWN, 0, 136,"15")
	screen.print(SCREEN_DOWN, 0, 144,"16")
	screen.print(SCREEN_DOWN, 0, 152,"17")
	screen.print(SCREEN_DOWN, 0, 160,"18")
	screen.print(SCREEN_DOWN, 0, 168,"19")
	screen.print(SCREEN_DOWN, 0, 176,"20")
--	screen.print(SCREEN_DOWN, 0, 184, "Timer : "..Clock:time())
]]--
	render()


end --end of MAIN while

-- Destruction du Heros
hero.sprite = nil
hero.attack.sprite = nil
-- Destruction des mobz
for k, v in ipairs (hero.inventory) do v.sprite = nil v=nil end
hero = nil
for k, v in ipairs (moblist) do v.sprite = nil v = nil end
-- Destruction des Objets
for k, v in ipairs (itemlist) do v.sprite = nil v = nil end
-- Destruction des parametres de la map
tile_width  = nil
tile_height = nil
map_width = nil
map_height = nil
maxrealx = nil
maxrealy = nil
ScrollMap.destroy(smap.BG_smap)
ScrollMap.destroy(smap.FG_smap)
if smap.BG_Tileset then Image.destroy(smap.BG_Tileset) end
smap.BG_Tileset = nil
if smap.FG_Tileset then Image.destroy(smap.FG_Tileset) end
smap.FG_Tileset = nil
smap = nil

--Image.destroy(inventory_background)
--inventory_background = nil
end --end of function
