-- Ghuntlet
-- a Gauntlet pseudo clone by Ghuntar WALDMEISTER.

--Load libraries
--heroz = require "lib_heroz"
--wpnz = require "lib_weaponz"
--monsterz = require "lib_monsterz"
--coordz = require "lib_coordz"
--selectionz = require "lib_selectionz"
--require "lib_game_mechanicz"
dofile ("./libs/lib_game_mechanicz.lua")
dofile ("./libs/lib_mobz.lua")
dofile ("./libs/lib_selectionz.lua")
dofile ("./libs/lib_display_DS.lua")
dofile ("./libs/lib_controls_DS.lua")



game = {}
-- Différents game.status : select_game, select_plan, ingame, pause , gameover, exit
STATUS = {"select_game", "select_hero", "select_plan", "ingame", "pause" , "gameover", "exit"}
game.status = "select_game"
game.level = 0


while (game.status ~= "exit") do
	if game.status == "select_game" then select_game () end
	if game.status == "select_hero" then select_hero () end
	if game.status == "select_plan" then select_plan () end
	if game.status == "ingame" then ingame() end
	if game.status == "gameover" then gameover () end
	if not is_in_table (game.status, STATUS) then game.status = "exit" end
end

print (game.status)

-- Global variable destruction

STATUS = nil
game = nil

