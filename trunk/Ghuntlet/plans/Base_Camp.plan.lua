-- Camp.plan.lua

smap = {}

-- Taille des tuiles
smap.tile_width  = 16
smap.tile_height = 16

-- Nombre de tuiles sur la carte
smap.map_width = 24
smap.map_height = 24

-- Fichier Map
smap.BG_map = "./maps/Base_Camp_BG.map"
smap.FG_map = "./maps/Base_Camp_FG.map"

-- Fichier Tileset
smap.BG_Tileset = Image.load("./images/Ghuntlet_camp.png", VRAM)
-- smap.FG_Tileset = smap.BG_Tileset -- On utilise le même fichier

-- Init (Scroll)Map
smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.FG_smap = ScrollMap.new(smap.BG_Tileset, smap.FG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.BG_blocking_tiles = {129,3,4,5,61,76,77,78,91,92,93,94,95,107,108,109,110,111,123,124,126,127}
smap.default_tile = 132
smap.maxrealx = smap.map_width * smap.tile_width
smap.maxrealy = smap.map_height * smap.tile_height
smap.hero_startpos = COORD:new({x = 120 , y = 120})
smap.scroll = COORD:new()
smap.offset = COORD:new({x=-8,y=-8})

smap.mob_type_list = {}
smap.monster_list = {
					{"BlackMage",{220 , 280}},
					{"Skeleton",{250,250}},
					{"BlackMage",{210 , 310}},
					{"Skeleton",{240,240}},
					{"Scarab",{270,140}},
					}
smap.item_list =	{
					}
smap.event_list =   {
                    }
