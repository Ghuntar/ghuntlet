-- microluamapeditor


game = {}
local conf = {}
conf.display_mode = 1
conf.display_BG = true
conf.display_FG = true
conf.edited_layer = nil


function savemap (amap, amapfile)
--print ("\n"..System.currentDirectory().."\n")
local mapfile = assert(io.open (amapfile,"w"))
io.output(mapfile)
local towrite = ""
for ty = 0 , map_height-1 do
	for tx = 0, map_width-1 do
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
System.changeDirectory("/media/DATAZ/LUA/ghuntlet/trunk/microluamapeditor")
dofile ("./plans/Camp.plan.lua")

-- Variables définies par le fichier de conf (.plan.lua)
--[[
tile_width  = 16
tile_height = 16
map_width = 28
map_height = 28
smap = {}
smap.BG_mapfile = "./maps/Dungeon_01_BG.map"
smap.FG_mapfile = "./maps/Dungeon_01_FG.map"
smap.BG_Tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM)
--smap.FG_tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM) -- On utilise le même fichier
smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_mapfile, map_width, map_height, tile_width, tile_height)
smap.FG_smap = ScrollMap.new(smap.BG_Tileset, smap.FG_mapfile, map_width, map_height, tile_width, tile_height)
hero_startpos = {120 , 120}
maxrealx = map_width * tile_width
maxrealy = map_height * tile_height
]]--


--definition du tileset
local tileset = {}
 tileset.image = smap.BG_Tileset
 tileset.width = Image.width(tileset.image)
 tileset.height = Image.height (tileset.image)
 tileset.x = 0
 tileset.y = 0

--definition complémentaire de la map
smap.x = 0
smap.y = 0
smap.current_tile = {x = 0, y = 0, number = 0}

--definition du curseur
local cursor = {}
cursor.sprite = Image.load ("./images/curseur_16.png", VRAM)
cursor.x = 0
cursor.y = 0


--local current_tile = 0
local tile_number = 0
--######################################################################


--######################################################################

while not Keys.newPress.Start do

Controls.read()

if Keys.held.L then
--### MODE TILESET

	screen.print(SCREEN_UP, 56, 48,"Mode Tileset")
	--lecture du stylet et déplacement du tileset
	if Stylus.deltaX then tileset.x = tileset.x + Stylus.deltaX end
	if Stylus.deltaY then tileset.y = tileset.y + Stylus.deltaY end
	if Stylus.released then tileset.x = 16*math.floor((tileset.x+8)/16) tileset.y = 16*math.floor((tileset.y+8)/16) end

	--limite du déplacement du tileset
	if tileset.x < SCREEN_WIDTH - tileset.width then tileset.x = SCREEN_WIDTH - tileset.width end
	if tileset.x > 0 then tileset.x = 0 end
	if tileset.y < SCREEN_HEIGHT - tileset.height then tileset.y = SCREEN_HEIGHT - tileset.height end
	if tileset.y > 0  then tileset.y = 0  end

--Traitement du curseur
	cursor.x , cursor.y = 16*math.floor(Stylus.X / 16) , 16*math.floor(Stylus.Y / 16)
	tile_number = ((cursor.y - tileset.y)/tile_height)*(tileset.height/tile_height) + (cursor.x + tileset.x) / tile_width

	screen.blit (SCREEN_DOWN, tileset.x, tileset.y, tileset.image)
	screen.blit (SCREEN_DOWN, cursor.x, cursor.y, cursor.sprite)


else
-- ###Mode MAP

	if Keys.newPress.Right then conf.display_mode = conf.display_mode + 1 end
	if conf.display_mode > 2 then conf.display_mode = 0 end
	if conf.display_mode == 0 then conf.display_BG = true conf.display_FG = false conf.edited_layer = smap.BG_smap end
	if conf.display_mode == 1 then conf.display_BG = true conf.display_FG = true conf.edited_layer = smap.BG_smap end
	if conf.display_mode == 2 then conf.display_BG = false conf.display_FG = true conf.edited_layer = smap.FG_smap end


	--Traitement du curseur
	cursor.x , cursor.y = 16*math.floor(Stylus.X / 16) , 16*math.floor(Stylus.Y / 16)

	if Keys.held.Up then
	 -- ###Mode Edition
		screen.print(SCREEN_UP, 56, 48,"Mode Edition")
		if Stylus.held then
		ScrollMap.setTile (conf.edited_layer, math.floor((smap.x + cursor.x)/16) , math.floor((smap.y + cursor.y)/16), tile_number)
		end
	else
	-- ### Mode Defilement
		screen.print(SCREEN_UP, 56, 48,"Mode Defilement")
		smap.current_tile.x =  math.floor((smap.x + cursor.x)/16)
		smap.current_tile.y =  math.floor((smap.y + cursor.y)/16)
		smap.current_tile.number = ScrollMap.getTile(conf.edited_layer , smap.current_tile.x , smap.current_tile.y)
	--lecture du stylet et déplacement de la map
		if Stylus.deltaX then smap.x = smap.x - Stylus.deltaX end
		if Stylus.deltaY then smap.y = smap.y - Stylus.deltaY end
		if Stylus.released then smap.x = 16*math.floor((smap.x+8)/16) smap.y = 16*math.floor((smap.y+8)/16) end

		if smap.x < 0 then smap.x = 0 end
		if smap.x > maxrealx - SCREEN_WIDTH then smap.x = maxrealx - SCREEN_WIDTH end
		if smap.y < 0 then smap.y = 0 end
		if smap.y > maxrealy -SCREEN_HEIGHT then smap.y = maxrealy - SCREEN_HEIGHT end
		ScrollMap.scroll (smap.BG_smap, smap.x, smap.y)
		ScrollMap.scroll (smap.FG_smap, smap.x, smap.y)
	end

	if conf.display_BG then ScrollMap.draw(SCREEN_DOWN, smap.BG_smap) end
	if conf.display_FG then ScrollMap.draw(SCREEN_DOWN, smap.FG_smap) end

	screen.blit (SCREEN_DOWN, cursor.x, cursor.y, cursor.sprite)
end

--screen.print(SCREEN_UP, 0, 0,"Stylus.deltaX : "..Stylus.deltaX)
--screen.print(SCREEN_UP, 128, 0,"Stylus.deltaY : "..Stylus.deltaY)
screen.print(SCREEN_UP, 0, 8,"cursor.x : "..cursor.x)
screen.print(SCREEN_UP, 128, 8,"cursor.y : "..cursor.y)
screen.print(SCREEN_UP, 0, 16,"smap.x : "..smap.x)
screen.print(SCREEN_UP, 128, 16,"smap.y : "..smap.y)

screen.print(SCREEN_UP, 0, 32,"tileset.x : "..tileset.x)
screen.print(SCREEN_UP, 128, 32,"tileset.y : "..tileset.y)
screen.print(SCREEN_UP, 56, 40,"tile_number : "..tile_number)

screen.print(SCREEN_UP, 0, 56,"current_tile.x : "..smap.current_tile.x)
screen.print(SCREEN_UP, 128, 56,"current_tile.y : "..smap.current_tile.y)
screen.print(SCREEN_UP, 56, 64, "current_tile : "..smap.current_tile.number)


render()
end

--print (System.currentDirectory().."\n")

while not (Keys.newPress.B) do
	Controls.read()
	local save = false
	screen.print(SCREEN_DOWN, 28, 80, "Do You want to save ?")
	screen.print(SCREEN_DOWN, 38, 100, "Press A to save, B to cancel")
	if Keys.newPress.A then
		savemap (smap.BG_smap,smap.BG_map)
		savemap (smap.FG_smap,smap.FG_map)
		print ("Maps saved")
		break
	end
	render()
end

print ("Vars Destruction")

ScrollMap.destroy(smap.BG_smap)
ScrollMap.destroy(smap.FG_smap)
if smap.BG_Tileset then Image.destroy(smap.BG_Tileset) end
if smap.FG_Tileset then Image.destroy(smap.FG_Tileset) end
Image.destroy(cursor.sprite)
smap = nil
conf = nil
game = nil

