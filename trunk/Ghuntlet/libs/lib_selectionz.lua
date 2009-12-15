--lib_selectionz.lua


function justify (string_length)
return ((SCREEN_WIDTH - string_length*6)/2)
end

--##############################################

function select_in_list (...)

	local title = arg[1] or "Missing Title"
	local select_list = arg[2] or {{"Missing Selection","Missed"}}
	local selection_size = #select_list
	local espacement = arg[3] or 20
	local tab = justify (#title)
	local selection = selection_size +1

	while (not ((Keys.newPress.Start or Keys.newPress.A) and selection ~= selection_size +1)) do
		Controls.read()
		if Keys.newPress.Up then selection = selection - 1 end
		if Keys.newPress.Down then selection = selection + 1 end
		if selection > selection_size then selection = 1 end
		if selection < 1 then selection = selection_size end
		screen.print(SCREEN_DOWN, tab , 10 , title)
		for i = 1, selection_size do
			screen.print(SCREEN_DOWN, 60, 20+i*espacement, select_list[i][1])
		end
		screen.print(SCREEN_DOWN, 30 ,20+selection*espacement, "=>")
		render()
	end
return select_list[selection][2],select_list[selection][3]
end

--##############################################

function select_game ()
    game.status = select_in_list ( "Welcome to Ghuntlet",{
                                                          {"New Game","select_hero"},
                                                          {"Continue [not implemented]","crash"},
                                                          {"Exit","exit"}
                                                         })
end

--##############################################

function select_hero()
    game.hero = select_in_list ( "Choose your Character",{
                                                          {"Black Mage","BLACKMAGE"},
                                                          {"Valkyrie","VALKYRIE"},
                                                          {"Maiden Guard","MAIDENGUARD"},
                                                          --[[{"White Mage","WhiteMage"}]]--
                                                         }, 12)
    dofile ("./datas/"..game.hero..".lua")
    dofile ("./datas/"..game.hero..".ds.lua")
    game.status = "select_plan"

end


--##############################################

function select_plan()
    game.curentmap = "./plans/Dungeon_01.plan.lua"
    dofile (game.curentmap)
    game.status = "ingame"
end


--##############################################

function pause()
end

--##############################################
--##############################################
--##############################################
--##############################################
--##############################################
--##############################################

