-- Ghuntlet
-- a Gauntlet pseudo clone by Ghuntar WALDMEISTER.

--Add more path to run modules
package.path = package.path.."/lua/scripts/Ghuntlet/lib/?.lua;"
package.path = package.path.."/media/DATAZ/LUA/Ghuntlet/lib/?.lua;"

--Load libraries
--heroz = require "libheroz"
--wpnz = require "libweaponz"
--mobz = require "libmobz"
--coordz = require "libcoordz"
--screenz = require "libscreenz"

game = {}
-- Différents game.status : select_game, select_plan, ingame, pause , gameover, exit
STATUS = {"select_game", "select_plan", "ingame", "pause" , "gameover", "exit"}
game.status = "select_game"
game.level = 0

dofile ("selection_screens_lib.lua")
dofile ("ingame_lib.lua")
dofile ("heroz_lib.lua")
dofile ("skillz_lib.lua")
dofile ("mobz_lib.lua")
dofile ("itemz_lib.lua")
dofile ("coordz_lib.lua")
dofile ("display_ds_lib.lua")
dofile ("controls_ds_lib.lua")

--####################################
--# Déclaration des fonctions START #
--##################################

-- Cette fonction vérifie si un nombre (n) se trouve dans une table (t)
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

--##########################################################

-- Cette fonction vérifie si une valeur (value) se trouve dans une table (array)
function is_in_table (array , value)
	for k, v in pairs (array) do
		if value == v then return true end
	end
	return false
end

--##########################################################

function changelifestatus (obj)
	local status = "OK"
	if obj.life < obj.maxlife then status = "Wounded" end
	if obj.life < obj.maxlife*0.2 then status = "Near death" end
	if obj.life < 1 then status = "Dead" end
	return status
	end

--####################################
--# Déclaration des fonctions STOP #
--##################################


--##########################################################
--##########################################################
--##########################################################


--Debut de la grande Boucle
while (game.status ~= "exit") do

--Controls.read()
if game.status == "select_game" then select_game () end
if game.status == "choose_hero" then choose_hero () end
if game.status == "select_plan" then select_plan () end
if game.status == "ingame" then ingame() end
if game.status == "gameover" then gameover () end
if not in_table (STATUS, game.status) then game.status = "exit" end
end

--Vidage mémoire

--Image.destroy(inventory_background)
inventory_background = nil


Scr_width  = nil
Scr_height = nil
tile_width  = nil
tile_height = nil
map_width = nil
map_height = nil
ficmap = nil

hero = nil

game = nil

--[[
print (collectgarbage(count))
collectgarbage(collect)
print (collectgarbage(count))
]]--
--Clock = nil

