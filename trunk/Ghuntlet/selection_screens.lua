-- selectin_screens.lua

function select_game ()
	local select_game = {80, 100, 120}
	local selection = 4
	while (not Keys.newPress.Start) do
		Controls.read()
		if Keys.newPress.Up then selection = selection - 1 end
		if Keys.newPress.Down then selection = selection + 1 end
		if selection > 3 then selection = 1 end
		if selection < 1 then selection = 3 end
		screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
		screen.print(SCREEN_UP, 48, 148, selection)
		screen.print(SCREEN_DOWN, 40, 50,"Welcome to Ghuntlet")
		screen.print(SCREEN_DOWN, 60, 80,"New Game")
		screen.print(SCREEN_DOWN, 60, 100,"Continue [not implemented]")
		screen.print(SCREEN_DOWN, 60, 120,"Exit")
		screen.print(SCREEN_DOWN, 30 ,select_game[selection], "=>")
		--spr1:playAnimation(SCREEN_DOWN, 40, select_game[selection] - 6, 4)
		render()
	end
	if selection == 1 then game.status = "select_plan" end
	if selection == 2 then game.status = "select_plan" end -- pas de gestion de sauvegarde pour le moment
	if selection == 3 then game.status = "exit" end
end


function select_plan ()
	--Controls.read()
	local selection = 4
	while (not (Keys.newPress.Start and selection~=4)) do
		Controls.read()
		if Keys.newPress.Up then selection = selection - 1 end
		if Keys.newPress.Down then selection = selection + 1 end
		if selection > 3 then selection = 1 end
		if selection < 1 then selection = 3 end
		screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
		screen.print(SCREEN_UP, 0, 148, "Selection : "..selection)
		screen.print(SCREEN_DOWN, 40, 20,"Select your map")
		screen.print(SCREEN_DOWN, 60, 40,"Dungeon 1")
		screen.print(SCREEN_DOWN, 60, 60,"Dungeon 2")
		screen.print(SCREEN_DOWN, 60, 80,"Exit")
		screen.print(SCREEN_DOWN, 30 , 20 + selection*20, "=>")
		--spr1:playAnimation(SCREEN_DOWN, 40, 20 + selection*20 - 6, 4)
		render()
	end
	if selection == 1 then game.curentmap = "./plans/Dungeon_01.plan.lua" game.status = "ingame" end
	if selection == 2 then game.curentmap = "./plans/map_num.plan.lua" game.status = "ingame" end
	if selection == 3 then game.curentmap = nil game.status = "select_game" end
if game.curentmap ~= nil then dofile (game.curentmap) end
end


function gameover ()
	while (not Keys.newPress.Start) do
		Controls.read()
		screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
		screen.print(SCREEN_DOWN, 60, 96,"Game Over")
		screen.print(SCREEN_DOWN, 40, 112,"Press Start to reset")
		render()
	end
	game.status = "select_game"
end


function pause ()
	--Controls.read()
	local selection = 5
	while (not (Keys.newPress.Start and selection~=5)) do
		Controls.read()
		if Keys.newPress.Up then selection = selection - 1 end
		if Keys.newPress.Down then selection = selection + 1 end
		if selection > 4 then selection = 1 end
		if selection < 1 then selection = 4 end
		screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
		screen.print(SCREEN_UP, 0, 148, "Selection : "..selection)
		screen.print(SCREEN_DOWN, 40, 20,"Pause, Press Start to select")
		screen.print(SCREEN_DOWN, 60, 40,"Continue")
		screen.print(SCREEN_DOWN, 60, 60,"Select Game")
		screen.print(SCREEN_DOWN, 60, 80,"Select Map")
		screen.print(SCREEN_DOWN, 60, 100,"Exit/Game Over")
		screen.print(SCREEN_DOWN, 30 , 20 + selection*20, "=>")
		--spr1:playAnimation(SCREEN_DOWN, 40, 20 + selection*20 - 6, 4)
		render()
	end
	if selection == 1 then game.status = "ingame" end
	if selection == 2 then game.status = "select_game" end
	if selection == 3 then game.status = "select_map" end
	if selection == 4 then game.status = "gameover" end

end
