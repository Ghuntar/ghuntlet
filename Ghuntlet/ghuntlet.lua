-- Ghuntlet
-- a Gauntlet pseudo clone by Ghuntar WALDMEISTER.

game = {}
-- Différents game.status : select_game, select_plan, ingame, gameover, pause , exit
game.status = "select_game"

dofile ("selection_screens.lua")
dofile ("ingame.lua")

--game.curentmap = "./plans/map_num.plan.lua"
--dofile (game.curentmap)

-- Taille de l'écran
Scr_width  = 256
Scr_height = 192
-- Avec 16px par tuile, on affiche 16*12 tuiles

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
		--if object.dir == 0 then move = {0 , 0}
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
while (game.status ~= "exit") do

if game.status == "select_game" then select_game () end
if game.status == "select_plan" then select_plan () end
if game.status == "ingame" then ingame() end
if game.status == "gameover" then gameover () end

end

--Vidage mémoire
Scr_width  = nil
Scr_height = nil
tile_width  = nil
tile_height = nil
map_width = nil
map_height = nil
ficmap = nil

sprite_width  = nil
sprite_height = nil
--half_sprite_width = nil
--half_sprite_height = nil

wpn_sprite_width = nil
wpn_sprite_height = nil

mob_sprite_width = nil
mob_sprite_height = nil
spr3_dir = nil

dir_move = nil

hero = nil
wpn = nil
mob = nil

--Clock = nil

