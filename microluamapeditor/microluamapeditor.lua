-- microluamapeditor

--definition du tileset
local tileset = {}
tileset.image = Image.load("./Ghuntlet_dungeon.png", VRAM)
tileset.width = Image.width(tileset.image)
tileset.height = Image.height (tileset.image)
tileset.x = 0
tileset.y = 0

--définition de la map
local tile_width  = 16
local tile_height = 16
local map_width = 28
local map_height = 28
local xmax = tile_width * map_width
local ymax = tile_height * map_height
local smap = {}
smap.map = "./Dungeon_01_BG.map"
smap.tileset = tileset.image
smap.x = 0
smap.y = 0

local cursor = {}
cursor.sprite = Image.load ("curseur_16.png", VRAM)
cursor.x = 0
cursor.y = 0


local MAP = ScrollMap.new(smap.tileset, smap.map, map_width, map_height, tile_width, tile_height)
local current_tile = 0
local tile_number = 0




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
	ScrollMap.scroll (MAP, smap.x, smap.y)

	--Traitement du curseur
	cursor.x , cursor.y = 16*math.floor(Stylus.X / 16) , 16*math.floor(Stylus.Y / 16)
	if Keys.held.Up and Stylus.held then
		screen.print(SCREEN_UP, 56, 48,"UP Pressed")
		ScrollMap.setTile (MAP, math.floor((smap.x + cursor.x)/16) , math.floor((smap.y + cursor.y)/16), tile_number)
	else
		current_tile = ScrollMap.getTile(MAP , math.floor((smap.x + cursor.x)/16) , math.floor((smap.y + cursor.y)/16))
	end
	ScrollMap.draw(SCREEN_DOWN, MAP)
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
