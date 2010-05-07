-- microluamapeditor

dofile ("./libs/lib_game_mechanicz.lua")
dofile ("./libs/lib_mobz.lua")
dofile ("./libs/lib_selectionz.lua")
dofile ("./libs/lib_display_DS.lua")
dofile ("./libs/lib_controls_DS.lua")

game = {}
game.status = "ingame"
local conf = {}
conf.display_mode = 1
conf.display_BG = true
conf.display_FG = true
conf.edited_layer = nil


function savemap (amap, amapfile)
    --print ("\n"..System.currentDirectory().."\n")
    System.rename(amapfile, amapfile..".old")
    local mapfile = assert(io.open (amapfile,"w"))
    io.output(mapfile)
    local towrite = ""
    for ty = 0 , smap.map_height-1
    do
        for tx = 0, smap.map_width-1
        do
            local towrite_tile = ScrollMap.getTile(amap , tx , ty)
            towrite = towrite..tostring(towrite_tile).."|"
        end
        towrite = towrite.."\n"
    end
    io.write (towrite)
    io.close()
end

function selectfile(ext)
local files = {}
local nbFiles = 0
local selectedFile = {}
local startList = 0
local selected = 0
local planFile = ""

local bgupcolor = Color.new(0, 0, 10)
local bgdowncolor = Color.new(0, 0, 10)
local fgupcolor = Color.new(31, 31, 31)
local filenamecolor = Color.new(31, 31, 31)
local dirnamecolor = Color.new(31, 31, 0)
local selectcolor = Color.new(0, 31, 0)
local microluacolor = Color.new(31, 15, 0)


local function fileExists(fname)
	local statusfile, errfile
	statusfile, errfile = pcall(function() -- check if file exists
		f = io.open(fname)
		io.close(f)
	end)
	return (errfile == nil)
end

local function reInit()
	Debug.clear()
	Debug.OFF()
	startList = 0
	selected = 0
	planFile = ""
	files = System.listDirectory(System.currentDirectory())
end

local function drawList(dirname)
	files = System.listDirectory(dirname)
	y = 0
	i = 0
	nbFiles = 0
	for k, file in pairs(files) do
		if i >= startList and i <= startList + 24 then
			y = y + 8
			if file.isDir then
				color = dirnamecolor -- directory
			else
				color = filenamecolor-- file
			end
			if i == selected then
				color = selectcolor -- select
				selectedFile = file
			end
			if file.isDir then
				screen.print(SCREEN_DOWN, 8, y, "["..file.name.."]", color)
			else
				screen.print(SCREEN_DOWN, 8, y, " "..file.name, color)
				if string.lower(string.sub(file.name, -#ext)) == ext then
					screen.print(SCREEN_DOWN, 0, y, "*", color)
				end
			end
		end
		i = i + 1
		nbFiles = nbFiles + 1
	end

end

local function goDown()
	if selected < nbFiles-1 then selected = selected + 1 end
	if selected - startList == 23 then startList = startList + 1 end
end

local function goUp()
	if selected > 0 then selected = selected - 1 end
	if selected - startList == -1 then startList = startList - 1 end
end


--##################


while true do

	Controls.read()
	if Stylus.held then
		if math.floor(Stylus.Y / 8 - 1) <= nbFiles - 1 then
			selected = math.floor(Stylus.Y / 8 - 1)
		end
	end
	if Keys.newPress.Down or Stylus.deltaY > 1 then goDown() end
	if Keys.newPress.Up or Stylus.deltaY < -1 then goUp() end
	if Keys.newPress.R then for i=0, 14 do goDown() end end
	if Keys.newPress.L then for i=0, 14 do goUp() end end
	if Keys.newPress.Left then
		System.changeDirectory("..")
		selected = 0
		startList = 0
	end
	if (Keys.newPress.A or Keys.newPress.Start or Stylus.doubleClick) then
		if string.lower(string.sub(selectedFile.name, -#ext)) == ext then -- load plan file
			planFile = selectedFile.name
		else end
	end
	if (Keys.newPress.Right or Stylus.doubleClick) and selectedFile.isDir then
		System.changeDirectory(selectedFile.name)
		selected = 0
		startList = 0
	end

	screen.drawFillRect(SCREEN_UP, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, bgupcolor)
	screen.drawFillRect(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, bgdowncolor)

	drawList(System.currentDirectory())
	str = "Micro LUA MAP EDITOR"
	screen.print(SCREEN_UP, (SCREEN_WIDTH / 2) - (8 * str:len() / 2), 32, str, microluacolor)
	str = "(c) Risike 2009"
	screen.print(SCREEN_UP, (SCREEN_WIDTH / 2) - (8 * str:len() / 2), 56, "Map Editor By Ghuntar", fgupcolor)
	screen.print(SCREEN_UP, (SCREEN_WIDTH / 2) - (8 * str:len() / 2), 64, "Shell By Risike", fgupcolor)
	screen.print(SCREEN_UP, 8, 90, " dir: "..System.currentDirectory(), fgupcolor)
	screen.print(SCREEN_UP, 8, 106, "file: "..selectedFile.name, fgupcolor)
	screen.print(SCREEN_UP, 8, 144, "Move stylus up and down to navigate", fgupcolor)
	screen.print(SCREEN_UP, 8, 152, "Stylus double click: launch", fgupcolor)
	screen.print(SCREEN_UP, 8, 160, "Up, Down, Left, Right: navigate", fgupcolor)
	screen.print(SCREEN_UP, 8, 168, "A or Start: launch", fgupcolor)
	screen.print(SCREEN_UP, 0, 184, (selected + 1).."/"..nbFiles, fgupcolor)

	render()

	if planFile ~= "" then
		return System.currentDirectory() , planFile
		--reInit()
	end

end
end

--curdir , selectedfile = selectfile(".plan.lua")
--System.changeDirectory("..")
--dofile ("./plans/"..selectedfile)
--System.changeDirectory("/media/DATAZ/LUA/ghuntlet/trunk/microluamapeditor")

-- dofile ("./plans/Base_Camp.plan.lua")
-- dofile ("./plans/Dungeon_01.plan.lua")
-- dofile ("./plans/Dungeon_02.plan.lua")
-- dofile ("./plans/Dungeon_03.plan.lua")
-- dofile ("./plans/Dungeon_04.plan.lua")
-- dofile ("./plans/map_num.plan.lua")
-- dofile ("./plans/map_num_2.plan.lua")
dofile ("./plans/The_HUB.plan.lua")

-- Variables définies par le fichier de conf (.plan.lua)
    -- {
    -- smap = {}
    -- smap.tile_width  = 16
    -- smap.tile_height = 16
    -- smap.map_width = 50
    -- smap.map_height = 50
    -- smap.BG_mapfile = "./maps/Dungeon_01_BG.map"
    -- smap.FG_mapfile = "./maps/Dungeon_01_FG.map"
    -- smap.BG_Tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM)
    -- smap.FG_tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM) -- On utilise le même fichier
    -- smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_mapfile, map_width, map_height, tile_width, tile_height)
    -- smap.FG_smap = ScrollMap.new(smap.BG_Tileset, smap.FG_mapfile, map_width, map_height, tile_width, tile_height)
    -- smap.BG_blocking_tiles = {129}
    -- smap.default_tile = 17
    -- smap.maxrealx = smap.map_width * smap.tile_width
    -- smap.maxrealy = smap.map_height * smap.tile_height
    -- smap.hero_startpos = COORD:new({x = 120 , y = 120})
    -- smap.scroll = COORD:new()
    -- smap.offset = COORD:new({x=-8,y=-8})
    -- }
    
-- Definition complémentaire de la map
smap.offset.x = 0
smap.offset.y = 0
smap.current_tile = {coord = COORD:new({x=0,y=0}), number = 0}

-- Definition du tileset
local tileset = {}
tileset.image = smap.BG_Tileset
tileset.width = Image.width(tileset.image)
tileset.height = Image.height (tileset.image)
tileset.offset = COORD:new({x=0,y=0})
tileset.current_tile = {coord = COORD:new({x=0,y=0}), number = 0}


--definition du curseur
local cursor = {}
cursor.sprite = Image.load ("./images/curseur_16.png", VRAM)
cursor.coord_T = COORD:new({x=0,y=0})
cursor.coord_M = COORD:new({x=0,y=0})

-- Definition d'une COORD pour le stylet
stylet = COORD:new({x=0,y=0})

--   #############
--  # Main loop #
-- #############
while (game.status ~= "exit") do

    Controls.read()
    stylet.x = Stylus.X
    stylet.y  = Stylus.Y

    --  ###############
    -- #  Menu Mode  #
    --###############
    if Keys.newPress.Start 
    then
        game.status = select_in_list (  "Menu, Press A or Start to select",
                                        {
                                            {"Continue","ingame"},
                                            {"Save","save"},
                                            {"Exit","exit"}
                                        } 
                                     )
        if game.status == "save"
        then
            while not (Keys.newPress.B) do
                Controls.read()
                local save = false
                screen.print(SCREEN_DOWN, 28, 80, "Do You want to save ?")
                screen.print(SCREEN_DOWN, 38, 100, "Press A to save, B to cancel")
                if Keys.newPress.A
                then
                    savemap (smap.BG_smap,smap.BG_map)
                    savemap (smap.FG_smap,smap.FG_map)
                    print ("Maps saved")
                    break
                end
                render()
            end 
        end
    end

    --  ################
    -- # Tileset Mode #
    --################    
    if Keys.held.L
    then
        screen.print(SCREEN_UP, 56, 152,"Mode Tileset")
        --lecture du stylet et déplacement du tileset
        if Stylus.deltaX
        then
            tileset.offset.x = tileset.offset.x - Stylus.deltaX
        end
        if Stylus.deltaY 
        then
            tileset.offset.y = tileset.offset.y - Stylus.deltaY 
        end
        if Stylus.released
        then
            -- tileset.offset.x = smap.tile_width*math.floor((tileset.offset.x+8)/smap.tile_width)
            -- tileset.offset.y = smap.tile_height*math.floor((tileset.offset.y+8)/smap.tile_height)
            tileset.offset = tileset.offset:align()
        end

        --limite du déplacement du tileset
        if tileset.offset.x < 0 then tileset.offset.x = 0 end
        if tileset.offset.x > tileset.width - SCREEN_WIDTH then tileset.offset.x = tileset.width - SCREEN_WIDTH end
        if tileset.offset.y < 0  then tileset.offset.y = 0  end
        if tileset.offset.y > tileset.height - SCREEN_HEIGHT then tileset.offset.y = tileset.height - SCREEN_HEIGHT end

        --Traitement du curseur
        -- cursor.coord_T.x = smap.tile_width*math.floor((Stylus.X + tileset.offset.x) / smap.tile_width)
        -- cursor.coord_T.y = smap.tile_height*math.floor((Stylus.Y + tileset.offset.y) / smap.tile_height)
        cursor.coord_T = (stylet + tileset.offset):align()

        -- tileset.current_tile.coord.x =  cursor.coord_T.x / smap.tile_width
        -- tileset.current_tile.coord.y =  cursor.coord_T.y / smap.tile_height
        tileset.current_tile.coord = cursor.coord_T:REALtoMAP()
        tileset.current_tile.number = tileset.current_tile.coord.x + tileset.current_tile.coord.y * (tileset.width / smap.tile_width)
        screen.blit (SCREEN_DOWN, -tileset.offset.x, -tileset.offset.y, tileset.image)
        screen.blit (SCREEN_DOWN, cursor.coord_T.x - tileset.offset.x, cursor.coord_T.y - tileset.offset.y, cursor.sprite)

    else
    --  ##############
    -- #  MAP Mode  #
    --##############
        -- Controls.read()
        if Keys.newPress.Right
        then
            conf.display_mode = (conf.display_mode + 1)%3
        end
        -- screen.print(SCREEN_UP,0,100,conf.display_mode)
        if conf.display_mode == 0
        then 
            conf.display_BG = true
            conf.display_FG = false
            conf.edited_layer = smap.BG_smap
        end
        if conf.display_mode == 1 
        then 
            conf.display_BG = true
            conf.display_FG = true
            conf.edited_layer = smap.BG_smap
        end
        if conf.display_mode == 2
        then
            conf.display_BG = false
            conf.display_FG = true
            conf.edited_layer = smap.FG_smap
        end

        --Traitement du curseur
        -- cursor.coord_M.x = smap.tile_width*math.floor((Stylus.X + smap.offset.x) / smap.tile_width)
        -- cursor.coord_M.y = smap.tile_height*math.floor((Stylus.Y + smap.offset.y) / smap.tile_height)
        cursor.coord_M = (stylet + smap.offset):align()

        -- smap.current_tile.coord.x =  cursor.coord_M.x / smap.tile_width
        -- smap.current_tile.coord.y =  cursor.coord_M.y / smap.tile_height
        smap.current_tile.coord = cursor.coord_M:REALtoMAP()
        smap.current_tile.number = ScrollMap.getTile(conf.edited_layer , smap.current_tile.coord.x , smap.current_tile.coord.y)

        if Keys.held.Up then
    --  ###############
    -- #  Edit Mode  #
    --###############
            screen.print(SCREEN_UP, 56, 152,"Mode Edition")
            if Stylus.held then
            ScrollMap.setTile (conf.edited_layer, smap.current_tile.coord.x, smap.current_tile.coord.y, tileset.current_tile.number)
            end
        else
    --  ###############
    -- # Scroll Mode #
    --###############
        screen.print(SCREEN_UP, 56, 152,"Mode Defilement")
        --lecture du stylet et déplacement de la map
        if Stylus.deltaX
        then
            smap.offset.x = smap.offset.x - Stylus.deltaX
        end
        if Stylus.deltaY
        then
            smap.offset.y = smap.offset.y - Stylus.deltaY
        end
        if Stylus.released
        then
            -- smap.offset.x = smap.tile_width*math.floor((smap.offset.x+8)/smap.tile_width)
            -- smap.offset.y = smap.tile_height*math.floor((smap.offset.y+8)/smap.tile_height)
            smap.offset = smap.offset:align()
        end

        --limite du déplacement due la map
        if smap.offset.x < 0 then smap.offset.x = 0 end
        if smap.offset.x > smap.maxrealx - SCREEN_WIDTH then smap.offset.x = smap.maxrealx - SCREEN_WIDTH end
        if smap.offset.y < 0 then smap.offset.y = 0 end
        if smap.offset.y > smap.maxrealy -SCREEN_HEIGHT then smap.offset.y = smap.maxrealy - SCREEN_HEIGHT end
        ScrollMap.scroll (smap.BG_smap, smap.offset.x, smap.offset.y)
        ScrollMap.scroll (smap.FG_smap, smap.offset.x, smap.offset.y)
    end

        if conf.display_BG then ScrollMap.draw(SCREEN_DOWN, smap.BG_smap) end
        if conf.display_FG then ScrollMap.draw(SCREEN_DOWN, smap.FG_smap) end

        screen.blit (SCREEN_DOWN, cursor.coord_M.x - smap.offset.x, cursor.coord_M.y - smap.offset.y, cursor.sprite)
    end

    screen.print(SCREEN_UP, 0, 0, "Stylus.deltaX : "..Stylus.deltaX)
    screen.print(SCREEN_UP, 128, 0, "Stylus.deltaY : "..Stylus.deltaY)
    screen.print(SCREEN_UP, 0, 8, "Stylus.X : "..Stylus.X)
    screen.print(SCREEN_UP, 128, 8, "Stylus.Y : "..Stylus.Y)
    screen.print(SCREEN_UP, 0, 16, "M.offset.x : "..smap.offset.x)
    screen.print(SCREEN_UP, 128, 16, "M.offset.y : "..smap.offset.y)
    screen.print(SCREEN_UP, 0, 24, "C.c_M.x : "..cursor.coord_M.x)
    screen.print(SCREEN_UP, 128, 24, "C.c_M.y : "..cursor.coord_M.y)
    screen.print(SCREEN_UP, 0, 32, "T.offset.x : "..tileset.offset.x)
    screen.print(SCREEN_UP, 128, 32, "T.offset.y : "..tileset.offset.y)
    screen.print(SCREEN_UP, 0, 40, "C.c_T.x : "..cursor.coord_T.x)
    screen.print(SCREEN_UP, 128, 40, "C.c_T.y : "..cursor.coord_T.y)
    screen.print(SCREEN_UP, 0, 48, "M.c_tile.x : "..smap.current_tile.coord.x)
    screen.print(SCREEN_UP, 128, 48, "M.c_tile.y : "..smap.current_tile.coord.y)
    screen.print(SCREEN_UP, 0, 56, "T.c_tile.x : "..tileset.current_tile.coord.x)
    screen.print(SCREEN_UP, 128, 56, "T.c_tile.y : "..tileset.current_tile.coord.y)
    screen.print(SCREEN_UP, 0, 64, "M.c_tile.num : "..smap.current_tile.number)
    screen.print(SCREEN_UP, 128, 64, "T.c_tile.num : "..tileset.current_tile.number)
    -- screen.blit (SCREEN_UP, 40, 72, smap.BG_Tileset, smap.current_tile.coord.x * smap.tile_width, smap.current_tile.coord.y * smap.tile_height, smap.tile_width, smap.tile_height)

    screen.blit (SCREEN_UP, 40, 72, smap.BG_Tileset, smap.tile_width * math.mod (smap.current_tile.number , tileset.width / smap.tile_width), smap.tile_height * math.floor (smap.current_tile.number / (tileset.width / smap.tile_width)), smap.tile_width, smap.tile_height)
    screen.blit (SCREEN_UP, 168, 72, smap.BG_Tileset, tileset.current_tile.coord.x * smap.tile_width, tileset.current_tile.coord.y * smap.tile_height, smap.tile_width, smap.tile_height)

    -- screen.print(SCREEN_UP, 0, 32,"tileset.x : "..tileset.x)
    -- screen.print(SCREEN_UP, 128, 32,"tileset.y : "..tileset.y)
    -- screen.print(SCREEN_UP, 56, 40,"tile_number : "..tile_number)
        -- tile_type.y = math.floor (tile_number / (tileset.width / smap.tile_width))
        -- tile_type.x = tile_number - (tile_type.y * (tileset.width / smap.tile_width))
        -- screen.blit (SCREEN_UP, 40, 40, smap.BG_Tileset, tile_type.x * smap.tile_width, tile_type.y * smap.tile_height, smap.tile_width, smap.tile_height) -----------------

    -- screen.print(SCREEN_UP, 0, 56,"current_tile.x : "..smap.current_tile.x)
    -- screen.print(SCREEN_UP, 128, 56,"current_tile.y : "..smap.current_tile.y)
    -- screen.print(SCREEN_UP, 56, 64, "current_tile : "..smap.current_tile.number)

    -- screen.print(SCREEN_UP, 0, 72, tile_type.x)
    -- screen.print(SCREEN_UP, 32, 72, tile_type.y)
    screen.print(SCREEN_UP, 0, 144, conf.display_mode)
    -- screen.print(SCREEN_UP, 128, 144,tostring(conf.edited_layer))
    screen.print(SCREEN_UP, 0, 160, "Press L to swap to choose your TILE")
    screen.print(SCREEN_UP, 0, 168, "Press UP and the Stylet to DRAW a TILE")
    screen.print(SCREEN_UP, 0, 176, "Press START to QUIT")
    screen.print(SCREEN_UP, 0, 184, "Press B to do NOTHING ;)")
    screen.print(SCREEN_UP, 0, 192, "OUT OF RANGE")





    render()
end

-- print (System.currentDirectory().."\n")
-- print ("Vars Destruction")
-- screen.print (SCRENN_UP,100,90,"Good Bye")
-- render()

ScrollMap.destroy(smap.BG_smap)
ScrollMap.destroy(smap.FG_smap)
if smap.BG_Tileset then Image.destroy(smap.BG_Tileset) end
if smap.FG_Tileset then Image.destroy(smap.FG_Tileset) end
Image.destroy(cursor.sprite)
smap = nil
conf = nil
game = nil

