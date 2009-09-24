-- selection_screens.lua

function select_in_list (...)
	local select_list = arg[1] or {{"Missing Selection","Missed"}}
	local selection_size = #select_list
	local title = arg[2] or "Missing Title"
	local tab = justify (#title)
	local selection = selection_size +1

	while (not (Keys.newPress.Start and selection ~= selection_size +1)) do
		Controls.read()
		if Keys.newPress.Up then selection = selection - 1 end
		if Keys.newPress.Down then selection = selection + 1 end
		if selection > selection_size then selection = 1 end
		if selection < 1 then selection = selection_size end
--DEBUG DISPLAY START
		screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
		screen.print(SCREEN_UP, 0, 32, "Selection :"..selection.."/"..selection_size)
		screen.print(SCREEN_UP, 0, 40, "Display : "..select_list[selection][1])
		screen.print(SCREEN_UP, 0, 48, "True value : "..select_list[selection][2])
--DEBUG DISPLAY STOP
		screen.print(SCREEN_DOWN, tab , 20 , title)
		for i = 1, selection_size do
			screen.print(SCREEN_DOWN, 60, 20+i*20, select_list[i][1])
		end
		screen.print(SCREEN_DOWN, 30 ,20+selection*20, "=>")
		render()
	end
return select_list[selection][2]
end

--##############################################

function justify (string_length)
return ((Scr_width - string_length*6)/2)
end

--##############################################

function select_game ()
game.status = select_in_list ({{"New Game","choose_hero"},{"Continue [not implemented]","crash"},{"Exit","exit"}} , "Welcome to Ghuntlet")
end

--##############################################

function select_plan ()
game.curentmap = select_in_list ({{"Dungeon 1","./plans/Dungeon_01.plan.lua"},{"Dungeon 2","./plans/map_num.plan.lua"},{"Exit", "exit"}},"Select Your Dungeon")
if ((game.curentmap) and (game.curentmap ~= "exit")) then dofile (game.curentmap) game.status = "ingame"
else game.status = "select_game" end
end

--##############################################

function gameover ()
	while (not Keys.newPress.Start) do
		Controls.read()
		screen.print(SCREEN_UP, 0, 32,"Game status : "..game.status)
		screen.print(SCREEN_DOWN, 100, 40,"Game Over")
		screen.print(SCREEN_DOWN, 75, 80,"Press Start to reset")
		render()
	end
	game.status = "select_game"
end

--##############################################

function pause ()
game.status = select_in_list ({{"Continue","ingame"},{"Select Game","select_game"},{"Select Map","select_plan"},{"Exit","gameover"}} , "Pause, Press Start to select")
end

--##############################################

function choose_hero ()
game.hero = select_in_list ({{"Black Mage","BlackMage"},{"Valkyrie","Valkyrie"},{"Maiden Guard","MaidenGuard"},{"White Mage","WhiteMage"}} , "Choose your Character")
game.status = "select_plan"
end

--##############################################
