function ingame ()
Controls.read()
-- Decrlaration des variables

---Coordonnées de la map
local smap_coord = {8 ,8}
local max_x = map_width * tile_width
local max_y = map_height * tile_height

--- Taille d'un sprite
sprite_width  = 16
sprite_height = 16
half_sprite_width = sprite_width / 2
half_sprite_height = sprite_height / 2

--Init Sprite
-- Sprite du héros

-- Sprite du l'Arme
local wpn_sprite_width = 16
local wpn_sprite_height = 16
local spr2 = Sprite.new("./images/Spell.png", wpn_sprite_width, wpn_sprite_height, VRAM)
spr2:addAnimation({0}, 200) -- Pas d'anim pour l'instant
wpn_spr = Image.load("./images/Pentacle.png", VRAM)

-- Liste des mobs (PNJs, monstres, armes des monstres etc... )
local moblist = {}

-- Définition du héros
hero = Heros.new (game.hero, hero_startpos)
hero:init ()
hero:init_sprite()

-- Définition de l'arme
wpn = {}
wpn.scrpos = {0 , 0} --coordonées du sprite de l'arme
wpn.realpos = {0 , 0} --coordonnées de l'arme
wpn.lastpos = {0, 0} --Coordonnée précédente
wpn.move = {0 , 0} --coordonnées du movement de l'arme
wpn.dir = 0 --direction de l'arme
wpn.speed = 4 --vitesse de l'arme
wpn.age = 0
wpn.timer = Timer.new()
wpn.width = 16
wpn.height = 16

-- Définition des mobz
mob1 = Monster.new ("Ratmut",{200 , 200})
table.insert(moblist,mob1)
mob2 = Monster.new ("BlackMage",{200 , 300})
table.insert(moblist,mob2)
mob3 = Monster.new ("Skeleton",{230,230})
table.insert(moblist,mob3)

--for k,v in ipairs (moblist) do print (k,v,"\n") end
for k,v in ipairs (moblist) do v:init() end
for k,v in ipairs (moblist) do v:init_sprite() end






-- MAIN while
while (game.status == "ingame" or game.status == "pause") do

--UPKEEP START
----UPKEEP WPN
	if wpn.timer:time() > 500 then
		wpn.realpos = {0 ,0}
		wpn.move = {0 , 0}
		wpn.dir = 0
		wpn.age = wpn.timer:time()
		wpn.timer:stop()
		wpn.timer:reset()
		end

----UPKEEP LIFE
hero.status = changelifestatus (hero)

for k , v in ipairs (moblist)
	do v.status = changelifestatus (v)
	if v.status == "Dead" then v.sprite = nil v = nil table.remove(moblist, k) end
	--for k,v in ipairs (moblist) do print (k,v,"\n") end
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
	if in_table (smap.BG_blocking_tiles , Whichtile (hero.realpos, smap.BG_smap)) then hero.realpos = {unpack(hero.lastpos)} end

--Contrôle de déclanchement de l'arme
	if Keys.newPress.L and wpn.timer:time() == 0 then
		wpn.realpos = {unpack(hero.realpos)}
		wpn.dir = hero.dir
		wpn.move = compute_move (wpn)
		wpn.realpos = compute_new_coords (wpn , wpn.move)
		wpn.timer:start()
	end

-- Calcul du mouvement de l'arme
	--wpn.lastpos = {unpack (wpn.realpos)} --pas vraiment utile ici
	wpn.realpos = compute_new_coords (wpn , wpn.move)
	if in_table (smap.BG_blocking_tiles , Whichtile (wpn.realpos, smap.BG_smap))
	then wpn.realpos = {0 ,0}
		wpn.move = {0 , 0}
		wpn.dir = 0
		wpn.age = wpn.timer:time()
		wpn.timer:stop()
		wpn.timer:reset()
	end

-- Calcul du mouvement du mob
for k , v in ipairs (moblist) do
	v.dir = v:ia_mov()
	v.move = compute_move (v)
	v.lastpos = {unpack (v.realpos)}
	v.realpos = compute_new_coords (v , v.move)
	if in_table (smap.BG_blocking_tiles , Whichtile (v.realpos, smap.BG_smap)) then v.realpos = {unpack(v.lastpos)} end
end


-- Test de collision
for k , v in ipairs (moblist) do
	if collide (hero,v) then hero.status = "HIT" hero.life = hero.life -1 end
	if collide (v,wpn) then v.status = "HIT" v.life = v.life - 1 end
end
--hero.status = "OK"
--if collide2 (hero, mob) then hero.status = "HIT" hero.life = hero.life - 1 end
--mob.status = "OK"
--if collide2 (mob, wpn) then mob.status = "HIT" mob.life = mob.life -1 end


--- Affichage Map Background
smap_coord[1] = hero.realpos[1] - hero.scrpos[1] -8
smap_coord[2] = hero.realpos[2] - hero.scrpos[2] -8
ScrollMap.draw(SCREEN_DOWN, smap.BG_smap)
ScrollMap.scroll(smap.BG_smap, smap_coord[1], smap_coord[2])

--- Affichage du sprite du héros

	hero:display()

for k , v in ipairs (moblist) do
	v:display()
end


-- Affichage de l'arme
	if wpn.timer:time() > 0 then
	wpn.scrpos = displaycoords (wpn.realpos)
	--spr2:playAnimation(SCREEN_DOWN, wpn.scrpos[1], wpn.scrpos[2], 1)
	 Image.rotate(wpn_spr, wpn.timer:time() / 2, 8 , 8)
	screen.blit(SCREEN_DOWN, wpn.scrpos[1], wpn.scrpos[2], wpn_spr)
	end

-- Affichage Map Foreground
ScrollMap.draw(SCREEN_DOWN, smap.FG_smap)
ScrollMap.scroll(smap.FG_smap, smap_coord[1], smap_coord[2])

-- Affichage HUD
	screen.print (SCREEN_DOWN, hero.scrpos[1], hero.scrpos[2] - sprite_height, hero.status)
	screen.print (SCREEN_DOWN, hero.scrpos[1], hero.scrpos[2] - sprite_height/2, hero.life)

for k, v in ipairs (moblist) do
	screen.print (SCREEN_DOWN, v.scrpos[1], v.scrpos[2] - v.spr_height, v.status)
	screen.print (SCREEN_DOWN, v.scrpos[1], v.scrpos[2] - v.spr_height/2, v.life)
end

if #moblist > 0 then screen.print (SCREEN_DOWN, justify (35) , 8 , "Kill "..#moblist.." more to complete the Level")
else screen.print (SCREEN_DOWN, justify (30) , 8 , "Level completed : PRESS START") end

--- Info SCREEN_UP
	screen.print(SCREEN_UP, 0, 0, "Press START to quit")
	screen.print(SCREEN_UP, 0, 8,"Press L to Cast a Spell")
	screen.print(SCREEN_UP, 0, 16,"Press A to \"control\" the mob")
	screen.print(SCREEN_UP, 150, 24, "FPS: "..NB_FPS)
	screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
	screen.print(SCREEN_UP, 0, 32, "H.MX : "..hero.move[1])
	screen.print(SCREEN_UP, 85, 32, "H.MY : "..hero.move[2])
	screen.print(SCREEN_UP, 170, 32, "H.Dir: "..hero.dir)
	screen.print(SCREEN_UP, 0, 40, "H.RX : "..hero.realpos[1])
	screen.print(SCREEN_UP, 85, 40, "H.RY : "..hero.realpos[2])
	screen.print(SCREEN_UP, 0, 48, "H.CTX : "..math.floor (hero.realpos[1] / tile_width))
	screen.print(SCREEN_UP, 85, 48, "H.CTY : "..math.floor (hero.realpos[2] / tile_width))
	screen.print(SCREEN_UP, 0, 56, "Max.RX : "..maxrealx)
	screen.print(SCREEN_UP, 85, 56, "Max.RY : "..maxrealy)
	--screen.print(SCREEN_UP, 0, 64, "tiletype :"..tiletype.."wpn_tiletype :"..wpn_tiletype.."Tuiles bloquantes :"..blockingtile_dungeon[1])
	screen.print(SCREEN_UP, 0, 72,"W.RX : "..wpn.realpos[1].."    W.DX : "..wpn.scrpos[1].."    wpn.age : "..wpn.age)
	screen.print(SCREEN_UP, 0, 80, "W.RY : "..wpn.realpos[2].."    W.DY : "..wpn.scrpos[2])
	screen.print(SCREEN_UP, 0, 88, "9")
	screen.print(SCREEN_UP, 0, 96, hero.name)
	screen.print(SCREEN_UP, 0, 104,"11")
	screen.print(SCREEN_UP, 0, 112,"12")
	screen.print(SCREEN_UP, 0, 120,"13")
	screen.print(SCREEN_UP, 0, 128,"14")
	screen.print(SCREEN_UP, 0, 136,"15")
	screen.print(SCREEN_UP, 0, 144,"16")
	screen.print(SCREEN_UP, 0, 152,"17")
	screen.print(SCREEN_UP, 0, 160,"18")
	screen.print(SCREEN_UP, 0, 168,"19")
	screen.print(SCREEN_UP, 0, 176,"20")
--	screen.print(SCREEN_UP, 0, 184, "Timer : "..Clock:time())
	render()


end --endof MAIN while
hero = nil
wpn = nil
mob = nil
ScrollMap.destroy(smap.BG_smap)
ScrollMap.destroy(smap.FG_smap)
smap = nil



end --end of function
