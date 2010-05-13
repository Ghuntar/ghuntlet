-- Dungeon_03.plan

smap = {}

-- Taille des tuiles
smap.tile_width  = 16
smap.tile_height = 16

-- Nombre de tuiles sur la carte
smap.map_width = 50
smap.map_height = 50

-- Fichier Map
smap.BG_map = "./maps/Dungeon_03_BG.map"
smap.FG_map = "./maps/Dungeon_03_FG.map"

-- Fichier Tileset
smap.BG_Tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM)
-- smap.FG_Tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM) -- On utilise le même fichier

-- Init (Scroll)Map
smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.FG_smap = ScrollMap.new(smap.BG_Tileset, smap.FG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.BG_blocking_tiles = {129,138,139,54,55,56,57,63,80,81,82,85,0,1,2,5,16,32,21,37,143,78,94,95,110,126}
smap.default_tile = 17
smap.maxrealx = smap.map_width * smap.tile_width
smap.maxrealy = smap.map_height * smap.tile_height
smap.hero_startpos = COORD:new({x = 120 , y = 120})
smap.scroll = COORD:new()
smap.offset = COORD:new({x=-8,y=-8})

smap.mob_type_list = {}
smap.monster_list = {
--[[					{"Ratmut",{200 , 200}},
					{"BlackMage",{220 , 280}},
					{"Skeleton",{250,250}},
					{"Ratmut",{210 , 280}},
					{"BlackMage",{210 , 310}},
					{"Skeleton",{240,240}},
					{"Scarab",{270,140}},
]]					}
smap.item_list =	{
					}
smap.event_list =   {
                    }
