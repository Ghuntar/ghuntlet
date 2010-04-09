-- Dungeon_01.plan

smap = {}

-- Taille des tuiles
smap.tile_width  = 16
smap.tile_height = 16

-- Nombre de tuiles sur la carte
smap.map_width = 28
smap.map_height = 28

-- Fichier Map
smap.BG_map = "./maps/Dungeon_01_BG.map"
smap.FG_map = "./maps/Dungeon_01_FG.map"

-- Fichier Tileset
smap.BG_Tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM)
--smap.FG_tileset = smap.BG_Tileset -- On utilise le même fichier

-- Init (Scroll)Map
smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.FG_smap = ScrollMap.new(smap.BG_Tileset, smap.FG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.BG_blocking_tiles = {129,139,54,55,56,57,63,80,81,82,85,0,1,2,5,16,32,21,37,143,78,94,95,110,126}
smap.doors = {143}
smap.stairs = {174}
smap.default_tile = 132
smap.maxrealx = smap.map_width * smap.tile_width
smap.maxrealy = smap.map_height * smap.tile_height
smap.level = 1
smap.hero_startpos = COORD:new({x = 120 , y = 120})
smap.scroll = COORD:new()
smap.offset = COORD:new({x=-8,y=-8})

smap.monster_list = {
					{"BLACKMAGE_LB",{220 , 280}},
					{"SKELETON",{250,250}},
					{"BLACKMAGE_LB",{210 , 310}},
					{"SKELETON",{240,240}},
					{"Scarab",{270,140}},
					}
smap.item_list =	{
					{"deadbody",{170,150}},
					{"key",{150,170}},
					{"doubleaxe",{250,200}},
					{"doubleaxe",{200,250}},
					}
