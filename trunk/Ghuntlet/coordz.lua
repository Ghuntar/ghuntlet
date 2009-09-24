--coordz.lua


-- @TODO Cette fonction aura pour but de gérer le contournement de tuile non passable (annulé une seule des coordonnées de mouvement lors d'un mouvement en diagonale)
function skirt (obj)



end

--##############################################

-- Cette fonction retourne les coordonnées d'affichage d'un objet à partir de ses "vrai" coordonnées
function displaycoords (any_coord)
	local any_scr_x = any_coord[1] + hero.scrpos[1] - hero.realpos[1]
	local any_scr_y = any_coord[2] + hero.scrpos[2] - hero.realpos[2]
	return {any_scr_x , any_scr_y}
	end

--##############################################

	-- Cette fonction retourne la tuile (son numero) qui se trouve aux coordonnées de la map indiquée
	function Whichtile (any_coord,smap)
	local currenttilex = math.floor (any_coord[1] / tile_width)
	local currenttiley = math.floor (any_coord[2] / tile_height)
	return ScrollMap.getTile(smap, currenttilex, currenttiley)
	end

--##############################################

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

--##############################################

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

--##############################################

function collide (obj1,obj2)
-- obj1 & obj2 are lists wich contains a .width, .height, .realpos[1](x) and realpos[2](y)
	local width1 = obj1.width /2
	local width2 = obj2.width /2
	local height1 = obj1.height /2
	local height2 = obj2.height /2
	if ((obj1.realpos[1] + width1) > (obj2.realpos[1] - width2))
	and ((obj1.realpos[1] - width1) < (obj2.realpos[1] + width2))
	and ((obj1.realpos[2] + height1) > (obj2.realpos[2] - height2))
	and ((obj1.realpos[2]  - height1) < (obj2.realpos[2] + height2))
	then return true
	else return false
	end
end

--##############################################








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
