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
game.curentmap = "Dungeon_01"
game.text_color = Color.new (18,17,30)
game.c_bone = Color.new (31,31,31)
game.c_snot = Color.new (0,31,0)
game.c_blood = Color.new (31,0,0)
game.c_marine = Color.new (0,0,31)

Debug.ON()

while (game.status ~= "exit") do
	if game.status == "select_game" then select_game () end
	if game.status == "select_hero" then select_hero () end
	if game.status == "select_plan" then select_plan () end
	if game.status == "ingame" then ingame() end
	if game.status == "gameover" then gameover () end
	if not is_in_table (game.status, STATUS) then game.status = "exit" end
    Debug.clear()
end
Debug.OFF()
-- Global variable destruction

STATUS = nil
game = nil

