-- Ghuntlet
-- a Gauntlet pseudo clone by Ghuntar WALDMEISTER.

game = {}
-- Différents game.status : select_game, select_plan, ingame, gameover
game.status = "select_game"

dofile ("selection_screens.lua")
dofile ("ingame.lua")

--game.curentmap = "./plans/map_num.plan.lua"
--dofile (game.curentmap)

-- Taille de l'écran
Scr_width  = 256
Scr_height = 192
-- Avec 16px par tuile, on affiche 16*12 tuiles
smap_coord = {8 ,8}

-- Taille d'un sprite
sprite_width  = 16
sprite_height = 16
-- et taille des "fractions de sprite"
--half_sprite_width = sprite_width / 2
--half_sprite_height = sprite_height / 2
--quart_sprite_width = sprite_width / 4
--quart_sprite_height = sprite_height / 4

--Init Sprite
-- Sprite du héros
spr1 = Sprite.new("./images/BlackMage_Sprite.png", sprite_width, sprite_height, VRAM)
spr1:addAnimation({2,6}, 200) -- Walk up
spr1:addAnimation({1,5}, 200) -- Walk right
spr1:addAnimation({0,4}, 200) -- Walk down
spr1:addAnimation({3,7}, 200) -- Walk left
spr1_dir = 2
--anIddleFrame = {2,1,0,3}

-- Sprite du l'Arme
wpn_sprite_width = 16
wpn_sprite_height = 16
spr2 = Sprite.new("./images/Spell.png", wpn_sprite_width, wpn_sprite_height, VRAM)
spr2:addAnimation({0}, 200) -- Pas d'anim pour l'instant

-- Sprite du mob
mob_sprite_width = 16
mob_sprite_height = 16
spr3 = Sprite.new("./images/Daemon.png", wpn_sprite_width, wpn_sprite_height, VRAM)
spr3:addAnimation({2,6}, 200) -- Walk up
spr3:addAnimation({1,5}, 200) -- Walk right
spr3:addAnimation({0,4}, 200) -- Walk down
spr3:addAnimation({3,7}, 200) -- Walk left
spr3_dir = 2


-- Liste des mobs (PNJs, monstres, armes des monstres etc... )
moblist = {}

-- Définition du héros
hero = {}
hero.scrpos = {120 , 88} -- Coordonnées du sprite du perso sur l'écran (centré)
hero.realpos = {120 , 120} -- Coordonnées du centre du perso sur la map (initialisé)
hero.lastpos = {128 , 128} -- Coordonnée précédente
hero.move = {0 , 0} --coordonées de movement du héro
hero.dir = 1 --Direction dans laquelle le héro se dirige (initialisé à 1)
hero.speed = 3 --vitesse du héro
hero.status = "OK"
hero.maxlife = 100
hero.life = 100

-- Définition de l'arme
wpn = {}
wpn.scrpos = {0 , 0} --coordonées du sprite de l'arme
wpn.realpos = {0 , 0} --coordonnées de l'arme
wpn.lastpos = {0, 0} --Coordonnée précédente
wpn.move = {0 , 0} --coordonnées du movement de l'arme
wpn.dir = 0 --direction de l'arme
wpn.speed = 5 --vitesse de l'arme
wpn.age = 0
wpn.timer = Timer.new()

-- Définition d'un mob
mob = {}
mob.scrpos = { 0 , 0} --coordonées du sprite du mob
mob.realpos = {168 , 168} --coordonnées du mob
mob.lastpos = {160, 160} --Coordonnée précédente
mob.move = {0,0} --coordonnées du movement du mob
mob.dir = 0 --direction du mob
mob.speed = 3 --vitesse du mob
mob.status = "OK"
mob.maxlife = 20
mob.life = 20
table.insert(moblist,mob)

--Clock = Timer.new()
--Clock:start()



-- Déclaration des fonctions START

-- Cette fonction retourne les coordonnées d'affichage d'un objet à partir de ses "vrai" coordonnées
function displaycoords (any_coord)
	local any_scr_x = any_coord[1] + hero.scrpos[1] - hero.realpos[1]
	local any_scr_y = any_coord[2] + hero.scrpos[2] - hero.realpos[2]
	return {any_scr_x , any_scr_y}
	end

-- Cette fonction retourne la coordonnée x de la tuile courante
--function WhichtileX (x)
--	local currenttilex = math.floor ((x + sprite_width / 2) / tile_width)
--	return currenttilex
--	end

-- Cette fonction retourne la coordonnée y de la tuile courante
--function WhichtileY (y)
--	local currenttiley = math.floor ((y + sprite_heigth /2)/ tile_height)
--	return currenttiley
--	end

-- Cette fonction retourne la tuile (son numero) qui se trouve aux coordonnées de la map indiquée
	function Whichtile (any_coord,smap)
	local currenttilex = math.floor (any_coord[1] / tile_width)
	local currenttiley = math.floor (any_coord[2] / tile_height)
	return ScrollMap.getTile(smap, currenttilex, currenttiley)
	end

-- Cette fonction vérifie si un nombre se trouve dans un tableau
function in_table( t , n )
	local i
	i = 1
	while t[i] do
		if ( t[i] == n ) then
		return true
		end
	i = i + 1
	end
	return false
end

-- Cette fonction contrôle la croix de direction et renvoie la direction
function get_dir ()
--6|1|5
--2|0|4
--7|3|8
	local direction = 0
	Controls.read()
		if Keys.held.Up and Keys.held.Right then direction = 5
		elseif Keys.held.Up and Keys.held.Left then direction = 6
		elseif Keys.held.Down and Keys.held.Left then direction = 7
		elseif Keys.held.Down and Keys.held.Right then direction = 8
		elseif Keys.held.Up then direction = 1
		elseif Keys.held.Left then direction = 2
		elseif Keys.held.Down then direction = 3
		elseif Keys.held.Right then direction = 4
		end
	return direction
	end

-- Cette fonction calcule des coordonnées de mouvement à partir de la direction et la vitesse d'un objet.
function compute_move (object)
		local move = {}
		move = {0 , 0}
		if object.dir == 1 then move = {0 , -object.speed} end
		if object.dir == 2 then move = {-object.speed , 0} end
		if object.dir == 3 then move = {0 , object.speed} end
		if object.dir == 4 then move = {object.speed , 0} end
		if object.dir == 5 then move = {object.speed * 0.8, -object.speed*0.8} end
		if object.dir == 6 then move = {-object.speed * 0.8 , -object.speed * 0.8} end
		if object.dir == 7 then move = {-object.speed * 0.8 , object.speed * 0.8} end
		if object.dir == 8 then move = {object.speed * 0.8 , object.speed * 0.8} end
		return move
		end

-- Cette fonction calcule les nouvelles coordonnés d'un objet
function compute_new_coords (object , incr)
	local tobject = {}
	tobject.realpos = {}
	tobject.realpos[1] = object.realpos[1]
	tobject.realpos[2] = object.realpos[2]
	tobject.realpos[1] = tobject.realpos[1] + incr[1]
	tobject.realpos[2] = tobject.realpos[2] + incr[2]
	return tobject.realpos
	end


function collide (obj1,obj2)
	if (obj1.realpos[1] + (sprite_width /2)) > (obj2.realpos[1] - (sprite_width /2))
	and (obj1.realpos[1] - (sprite_width /2)) < (obj2.realpos[1] + (sprite_width /2))
	and (obj1.realpos[2] + (sprite_height /2)) > (obj2.realpos[2] - (sprite_height /2))
	and (obj1.realpos[2] - (sprite_height /2)) < (obj2.realpos[2] + (sprite_height /2))
	then return true
	else return false
	end
end

function changelifestatus (obj)
	local status = "OK"
	if obj.life < obj.maxlife then status = "Wounded" end
	if obj.life < obj.maxlife*0.2 then status = "Near death" end
	if obj.life < 1 then status = "Dead" end
	return status
	end

-- Déclaration des fonctions END


--##########################################################
--##########################################################
--##########################################################


--Debut de la grande Boucle
while (not Keys.newPress.Start) do

--Upkeep START

--if Clock:time() >= 100 then
--	Clock:stop()
--	Clock:reset()
--	Clock:start()
--end

if game.status == "select_game" then select_game () end
if game.status == "select_plan" then select_plan () end
if game.status == "gameover" then gameover () end



	if wpn.timer:time() > 500 then
		wpn.realpos = {0 ,0}
		wpn.move = {0 , 0}
		wpn.dir = 0
		wpn.age = wpn.timer:time()
		wpn.timer:stop()
		wpn.timer:reset()
		end


hero.status = changelifestatus (hero)
mob.status = changelifestatus (mob)

if hero.status == "Dead" then game.status = "gameover" end

-- Upkeep END

-- Contrôle de la croix de direction calcul du mouvement du héros
newdir = get_dir()
if newdir ~=0 and newdir ~= nil then
	hero.dir = newdir
	hero.move = compute_move (hero)

-- Vérification de la légalité du mouvement
	hero.lastpos = {unpack(hero.realpos)}
	hero.realpos = compute_new_coords (hero , hero.move)
	if in_table (smap.BG_blocking_tiles , Whichtile (hero.realpos, smap.BG_smap)) then hero.realpos = {unpack(hero.lastpos)} end
	end

--Contrôle de déclanchement de l'arme
	if Keys.held.L and wpn.timer:time() == 0 then
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
	--@todo Gérer le mob.mov par une IA ou un chemin scripté
	if Keys.newPress.A then mob.dir = mob.dir + 1 end -- en attendant l'IA, on "controle" le mob avec le bouton A
	if mob.dir > 8 then mob.dir = 0 end
	mob.move = compute_move (mob)
	mob.lastpos = {unpack (mob.realpos)}
	mob.realpos = compute_new_coords (mob , mob.move)
	if in_table (smap.BG_blocking_tiles , Whichtile (mob.realpos, smap.BG_smap)) then mob.realpos = {unpack(mob.lastpos)} end


-- Test de collision
--hero.status = "OK"
if collide (hero, mob) then hero.status = "HIT" hero.life = hero.life - 1 end
--mob.status = "OK"
if collide (mob, wpn) then mob.status = "HIT" mob.life = mob.life -1 end



--- Affichage Map Background
smap_coord[1] = hero.realpos[1] - hero.scrpos[1] -8
smap_coord[2] = hero.realpos[2] - hero.scrpos[2] -8
ScrollMap.draw(SCREEN_DOWN, smap.BG_smap)
ScrollMap.scroll(smap.BG_smap, smap_coord[1], smap_coord[2])

--- Affichage du sprite du héros
if hero.dir == 1 then spr1_dir = 1 end
if hero.dir == 2 then spr1_dir = 2 end
if hero.dir == 3 then spr1_dir = 3 end
if hero.dir == 4 then spr1_dir = 4 end
if hero.dir == 5 then spr1_dir = 4 end
if hero.dir == 6 then spr1_dir = 2 end
if hero.dir == 7 then spr1_dir = 2 end
if hero.dir == 8 then spr1_dir = 4 end
	spr1:playAnimation(SCREEN_DOWN, hero.scrpos[1], hero.scrpos[2], spr1_dir)

-- Affichage du sprite du mob
if mob.dir == 1 then spr3_dir = 1 end
if mob.dir == 2 then spr3_dir = 2 end
if mob.dir == 3 then spr3_dir = 3 end
if mob.dir == 4 then spr3_dir = 4 end
if mob.dir == 5 then spr3_dir = 4 end
if mob.dir == 6 then spr3_dir = 2 end
if mob.dir == 7 then spr3_dir = 2 end
if mob.dir == 8 then spr3_dir = 4 end
	mob.scrpos = displaycoords (mob.realpos)
	spr3:playAnimation(SCREEN_DOWN, mob.scrpos[1], mob.scrpos[2], spr3_dir)

-- Affichage de l'arme
	if wpn.timer:time() > 0 then
	wpn.scrpos = displaycoords (wpn.realpos)
	spr2:playAnimation(SCREEN_DOWN, wpn.scrpos[1], wpn.scrpos[2], 1)
	end

-- Affichage Map Foreground
ScrollMap.draw(SCREEN_DOWN, smap.FG_smap)
ScrollMap.scroll(smap.FG_smap, smap_coord[1], smap_coord[2])

-- Affichage HUD

	screen.print (SCREEN_DOWN, hero.scrpos[1], hero.scrpos[2] - sprite_height, hero.status)
	screen.print (SCREEN_DOWN, hero.scrpos[1], hero.scrpos[2] - sprite_height/2, hero.life)
	screen.print (SCREEN_DOWN, mob.scrpos[1], mob.scrpos[2] - sprite_height, mob.status)
	screen.print (SCREEN_DOWN, mob.scrpos[1], mob.scrpos[2] - sprite_height/2, mob.life)


--- Info SCREEN_UP
	--screen.print(SCREEN_UP,0,0,"O.K. !")
	screen.print(SCREEN_UP, 0, 0, "Press START to quit")
	screen.print(SCREEN_UP, 0, 8,"Press L to Cast a Spell")
	screen.print(SCREEN_UP, 0, 16,"Press A to \"control\" the mob")
	screen.print(SCREEN_UP, 48, 24, "FPS: "..NB_FPS)
	screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
	screen.print(SCREEN_UP, 0, 32, "H.MX : "..hero.move[1])
	screen.print(SCREEN_UP, 85, 32, "H.MY : "..hero.move[2])
	screen.print(SCREEN_UP, 170, 32, "H.Dir: "..hero.dir)
--	screen.print(SCREEN_UP, 0, 40, "Dir spr : "..dir_spr.."Weapon Dir : "..wpn.dir)
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
	screen.print(SCREEN_UP, 0, 96,"10")
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



end

--Vidage mémoire
Scr_width  = nil
Scr_height = nil
tile_width  = nil
tile_height = nil
map_width = nil
map_height = nil
ficmap = nil
ScrollMap.destroy(smap.BG_smap)
ScrollMap.destroy(smap.FG_smap)
smap = nil
blockingtile_dungeon = nil

maxrealx = nil
maxrealy = nil
sprite_width  = nil
sprite_height = nil
--half_sprite_width = nil
--half_sprite_height = nil
Sprite.destroy(spr1)
spr1 = nil
spr1_dir = nil

wpn_sprite_width = nil
wpn_sprite_height = nil
Sprite.destroy(spr2)
spr2 = nil

mob_sprite_width = nil
mob_sprite_height = nil
Sprite.destroy(spr3)
spr3 = nil
spr3_dir = nil

dir_move = nil

hero = nil
wpn = nil
mob = nil

--Clock = nil

