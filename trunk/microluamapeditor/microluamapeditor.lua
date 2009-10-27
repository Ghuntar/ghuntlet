-- microluamapeditor




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
		if string.lower(string.sub(selectedFile.name, -#ext)) == ext then -- load map file
			planFile = selectedFile.name
		else
			--[[if selectedFile.isDir and fileExists(selectedFile.name.."/index.lua") then -- launch directory/index.lua script
				System.changeDirectory(selectedFile.name)
				exeFile = "index.lua"
			end]]--
		end
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



game = {}
curdir , selectedfile = selectfile(".plan.lua")
System.changeDirectory("..")
dofile ("./plans/"..selectedfile)


--definition du tileset
local tileset = {}
tileset.image = smap.BG_Tileset
tileset.width = Image.width(tileset.image)
tileset.height = Image.height (tileset.image)
tileset.x = 0
tileset.y = 0
--[[
--définition de la map
local tile_width  = 16
local tile_height = 16
local map_width = 28
local map_height = 28
local smap = {}
curdir , selectedfile = selectfile()
smap.map = curdir.."/"..selectedfile
smap.tileset = tileset.image
]]--
local xmax = tile_width * map_width
local ymax = tile_height * map_height
smap.x = 0
smap.y = 0

local cursor = {}
cursor.sprite = Image.load ("curseur_16.png", VRAM)
cursor.x = 0
cursor.y = 0


--local MAP = ScrollMap.new(smap.tileset, smap.map, map_width, map_height, tile_width, tile_height)
local current_tile = 0
local tile_number = 0
--######################################################################


--######################################################################

while not Keys.newPress.Start do

Controls.read()

if Keys.held.L then --### MODE TILESET

	--lecture du stylet et déplacement du tileset
	if Stylus.deltaX then tileset.x = tileset.x + Stylus.deltaX end
	if Stylus.deltaY then tileset.y = tileset.y + Stylus.deltaY end
	if Stylus.released then tileset.x = 16*math.floor((tileset.x+8)/16) tileset.y = 16*math.floor((tileset.y+8)/16) end

	if tileset.x < SCREEN_WIDTH - tileset.width then tileset.x = SCREEN_WIDTH - tileset.width end
	if tileset.x > 0 then tileset.x = 0 end
	if tileset.y < SCREEN_HEIGHT - tileset.height then tileset.y = SCREEN_HEIGHT - tileset.height end
	if tileset.y > 0  then tileset.y = 0  end

--Traitement du curseur
	cursor.x , cursor.y = 16*math.floor(Stylus.X / 16) , 16*math.floor(Stylus.Y / 16)
	tile_number = ((cursor.y - tileset.y)/tile_height)*(tileset.height/tile_height) + (cursor.x + tileset.x) / tile_width

	screen.blit (SCREEN_DOWN, tileset.x, tileset.y, tileset.image)
	screen.blit (SCREEN_DOWN, cursor.x, cursor.y, cursor.sprite)
--end


else -- ###Mode MAP

--lecture du stylet et déplacement de la map
	if Stylus.deltaX then smap.x = smap.x - Stylus.deltaX end
	if Stylus.deltaY then smap.y = smap.y - Stylus.deltaY end
	if Stylus.released then smap.x = 16*math.floor((smap.x+8)/16) smap.y = 16*math.floor((smap.y+8)/16) end

	if smap.x < 0 then smap.x = 0 end
	if smap.x > xmax - SCREEN_WIDTH then smap.x = xmax - SCREEN_WIDTH end
	if smap.y < 0 then smap.y = 0 end
	if smap.y > ymax -SCREEN_HEIGHT then smap.y = ymax - SCREEN_HEIGHT end
	ScrollMap.scroll (smap.BG_smap, smap.x, smap.y)

	--Traitement du curseur
	cursor.x , cursor.y = 16*math.floor(Stylus.X / 16) , 16*math.floor(Stylus.Y / 16)
	if Keys.held.Up and Stylus.held then
		screen.print(SCREEN_UP, 56, 48,"UP Pressed")
		ScrollMap.setTile (smap.BG_smap, math.floor((smap.x + cursor.x)/16) , math.floor((smap.y + cursor.y)/16), tile_number)
	else
		current_tile = ScrollMap.getTile(smap.BG_smap , math.floor((smap.x + cursor.x)/16) , math.floor((smap.y + cursor.y)/16))
	end
	ScrollMap.draw(SCREEN_DOWN, smap.BG_smap)
	screen.blit (SCREEN_DOWN, cursor.x, cursor.y, cursor.sprite)
end

screen.print(SCREEN_UP, 0, 0,"Stylus.deltaX : "..Stylus.deltaX)
screen.print(SCREEN_UP, 128, 0,"Stylus.deltaY : "..Stylus.deltaY)
screen.print(SCREEN_UP, 0, 8,"cursor.x : "..cursor.x)
screen.print(SCREEN_UP, 128, 8,"cursor.y : "..cursor.y)
screen.print(SCREEN_UP, 0, 16,"smap.x : "..smap.x)
screen.print(SCREEN_UP, 128, 16,"smap.y : "..smap.y)
screen.print(SCREEN_UP, 56, 24, "current_tile : "..current_tile)
screen.print(SCREEN_UP, 0, 32,"tileset.x : "..tileset.x)
screen.print(SCREEN_UP, 128, 32,"tileset.y : "..tileset.y)
screen.print(SCREEN_UP, 56, 40,"tile_number : "..tile_number)

render()
end

print (System.currentDirectory().."\n")

local mapfile = io.open (System.currentDirectory().."/maps/"..selectedfile..".new","w")
io.output(mapfile)
local towrite = ""
for ty = 0 , map_height-1 do
	for tx = 0, map_width-1 do
		local towrite_tile = ScrollMap.getTile(smap.BG_smap , tx , ty)
		towrite = towrite..tostring(towrite_tile).."|"
	end
	towrite = towrite.."\n"
end
io.write (towrite)
io.close()


