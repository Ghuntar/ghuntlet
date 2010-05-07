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
	-- local selection = selection_size +1
    local selection = 0
    Controls.read()

	-- while (not ((Keys.newPress.Start or Keys.newPress.A) and selection ~= selection_size +1)) do
	while (not ((Keys.newPress.Start or Keys.newPress.A))) do
		Controls.read()
		if Keys.newPress.Up
        then
            selection = (selection - 1)%selection_size
        end
		if Keys.newPress.Down
        then
            selection = (selection + 1)%selection_size
        end
		-- if selection > selection_size then selection = 1 end
		-- if selection < 1 then selection = selection_size end
		screen.print(SCREEN_DOWN, tab , 10 , title)
		for i = 1, selection_size do
			screen.print(SCREEN_DOWN, 60, 20+i*espacement, select_list[i][1])
		end
		screen.print(SCREEN_DOWN, 30 ,20+(selection + 1)*espacement, "=>")
        if game.hero 
        then
            screen.print(SCREEN_UP, 30, 80, game.hero)
        end
        if game.curentmap 
        then
            screen.print(SCREEN_UP, 30, 88, game.curentmap)
        end
        
		render()
	end
return select_list[selection+1][2],select_list[selection+1][3]
end

--##############################################

function select_game ()
    game.status = select_in_list    (   "Welcome to Ghuntlet",
                                        {
                                            {"New Game","select_hero"},
                                            {"Continue [not implemented]","crash"},
                                            {"Exit","exit"}
                                        }
                                    )
end

--##############################################

function select_hero()
    if game.hero
    then 
        _G[game.hero]:destroy()
    end
    game.hero = select_in_list (    "Choose your Character",
                                    {
                                        {"Black Mage","BLACKMAGE"},
                                        {"Valkyrie","VALKYRIE"},
                                        {"Maiden Guard","MAIDENGUARD"},
                                        -- {"White Mage","WHITEMAGE"}
                                    },
                                    12
                                )
    dofile ("./datas/"..game.hero..".lua")
    dofile ("./datas/"..game.hero..".ds.lua")
    game.status = "select_plan"

end

--##############################################

function select_plan()
    -- game.curentmap = "./plans/Dungeon_01.plan.lua"
    if smap
    then 
        ScrollMap.destroy(smap.BG_smap)
    end
    dofile ("./plans/"..game.curentmap..".plan.lua")
    game.status = "ingame"
end


--##############################################

function pause()
    game.status = select_in_list (  "Pause, Press Start to select",
                                    {
                                        {"Continue","ingame"},
                                        {"Save","save"},
                                        {"Select Game","select_game"},
                                        {"Select Map","select_plan"},
                                        {"Exit","gameover"}
                                    } 
                                 )
    if game.status == "save"
    then
        savegame()
        game.status = "pause"
    end
end

--##############################################
--##############################################
--##############################################
--##############################################
--##############################################
--##############################################

