--lib_selectionz.lua


function justify (string_length)
return ((SCREEN_WIDTH - string_length*6)/2)
end

--##############################################

function select_in_list (...)
    Title_Screen = Image.load("./images/Ghuntlet_Title.png",RAM)
    local title = arg[1] or "Missing Title"
    local select_list = arg[2] or {{"Missing Selection","Missed"}}
    local selection_size = #select_list
    local espacement = arg[3] or 20
    local couleur = arg[4] or Color.new(0,31,0)
    local tab = justify (#title)
    local selection = 0
    Controls.read()

    while (not (Keys.newPress.Start or Keys.newPress.A)) do
        Controls.read()
        if Keys.newPress.Up
        then
            selection = (selection - 1)%selection_size
        end
        if Keys.newPress.Down
        then
            selection = (selection + 1)%selection_size
        end
        screen.print(SCREEN_DOWN, tab , 10 , title, couleur)
        for i = 1, selection_size do
            screen.print(SCREEN_DOWN, 60, 20+i*espacement, select_list[i][1], couleur)
        end
        screen.print(SCREEN_DOWN, 30 ,20+(selection + 1)*espacement, "=>", couleur)
        -- if game.hero 
        -- then
            -- screen.print(SCREEN_UP, 30, 80, game.hero, couleur)
        -- end
        if game.curentmap 
        then
            screen.print(SCREEN_DOWN, 30, 160, "Map : "..game.curentmap, couleur)
        end
        screen.blit (SCREEN_UP,80,90,Title_Screen)
        render()
    end
    Image.destroy(Title_Screen)
    return select_list[selection+1][2],select_list[selection+1][3]
end

--##############################################

function select_game ()
    game.status = select_in_list    (   "Welcome to Ghuntlet",
                                        {
                                            {"New Game","select_hero"},
                                            {"Continue [not implemented]","crash"},
                                            {"Exit","exit"}
                                        },
                                        20,
                                        game.text_color
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
                                    12,
                                    game.text_color
                                )
    dofile ("./datas/"..game.hero..".lua")
    dofile ("./datas/"..game.hero..".ds.lua")
    game.status = "select_plan"

end

--##############################################

function select_plan()
    -- game.curentmap = "./plans/Dungeon_01.plan.lua"
    -- if smap
    -- then 
        -- if smap.BG_smap
        -- then
            -- ScrollMap.destroy(smap.BG_smap)
        -- end
    -- if smap.FG_smap
    -- then
        -- ScrollMap.destroy(smap.FG_smap)
    -- end
    -- end
    dofile ("./plans/"..game.curentmap..".plan.lua")
    game.status = "ingame"
end

--##############################################

function pause()
    game.status = select_in_list (  "Pause, Press Start to select",
                                    {
                                        {"Continue","ingame"},
                                        {"Save","save"},
                                        {"Load","load"},
                                        {"Select Game","select_game"},
                                        {"Select Map","select_plan"},
                                        {"Exit","gameover"}
                                    },
                                    20,
                                    game.text_color
                                 )
    if game.status == "save"
    then
        savegame()
        game.status = "pause"
    end
    if game.status == "load"
    then
        loadgame()
        game.status = "select_plan"
    end
    if game.status == "select_plan"
    then game.curentmap = "The_HUB"
    end
    if game.status == "select_game"
    then
        game.curentmap = "The_HUB"
    end
end

--##############################################

function newgame()

end

--##############################################

function continuegame()

end

--##############################################
--##############################################
--##############################################
--##############################################

