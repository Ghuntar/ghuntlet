-- Dungeon_01.plan

-- Taille des tuiles
tile_width  = 16
tile_height = 16

-- Nombre de tuiles sur la carte
map_width = 50
map_height = 50

-- Fichier Map
smap = {}
smap.BG_map = "./maps/Dungeon_03_BG.map"
smap.FG_map = "./maps/Dungeon_03_FG.map"

-- Fichier Tileset
smap.BG_Tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM)
-- smap.FG_tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM) -- On utilise le même fichier

-- Init (Scroll)Map
smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_map, map_width, map_height, tile_width, tile_height)
smap.FG_smap = ScrollMap.new(smap.BG_Tileset, smap.FG_map, map_width, map_height, tile_width, tile_height)
smap.BG_blocking_tiles = {129,139,54,55,56,57,63,80,81,82,85,0,1,2,5,16,32,21,37}

hero_startpos = {120 , 120}
maxrealx = map_width * tile_width
maxrealy = map_height * tile_height

smap.monster_list = {
--[[					{"Ratmut",{200 , 200}},
					{"BlackMage",{220 , 280}},
					{"Skeleton",{250,250}},
					{"Ratmut",{210 , 280}},
					{"BlackMage",{210 , 310}},
					{"Skeleton",{240,240}},
					{"Scarab",{270,140}},
]]					}
smap.item_list = {}
