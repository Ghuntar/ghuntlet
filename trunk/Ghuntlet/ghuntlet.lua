-- Ghuntlet
-- a Gauntlet pseudo clone by Ghuntar WALDMEISTER.

--Load libraries
dofile ("./libs/lib_game_mechanicz.lua")
dofile ("./libs/lib_mobz.lua")
dofile ("./libs/lib_selectionz.lua")
dofile ("./libs/lib_display_DS.lua")
dofile ("./libs/lib_controls_DS.lua")
dofile ("./datas/ITEMz.lua")
dofile ("./datas/ITEMz.ds.lua")

game = {}
-- Différents game.status : select_game, select_plan, ingame, pause , gameover, exit
STATUS = {"select_game", "select_hero", "select_plan", "ingame", "pause" , "gameover", "exit"}
game.status = "select_game"
game.curentmap = "The_HUB"
-- game.text_color = Color.new (20,20,0)
game.text_color = Color.new (18,17,30)
-- game.text_color = Color.new (12,9,31)

while (game.status ~= "exit") do
	if game.status == "select_game" then select_game () end
	if game.status == "select_hero" then select_hero () end
	if game.status == "select_plan" then select_plan () end
	if game.status == "ingame" then ingame() end
	if game.status == "gameover" then gameover () end
	if not is_in_table (game.status, STATUS) then game.status = "exit" end
end

-- Global variable destruction

-- STATUS = nil
game = nil

