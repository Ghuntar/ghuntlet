-- map_num.plan.lua

smap = {}

-- Taille des tuiles
smap.tile_width  = 16
smap.tile_height = 16

-- Nombre de tuiles sur la carte
smap.map_width = 16
smap.map_height = 16

-- Fichier Map
smap.BG_map = "./maps/map_num_2_BG.map"
smap.FG_map = "./maps/map_num_2_FG.map"

-- Fichier Tileset
smap.BG_Tileset = Image.load("./images/map_num.png", VRAM)
smap.FG_Tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM)

-- Init (Scroll)Map
smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.FG_smap = ScrollMap.new(smap.FG_Tileset, smap.FG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.BG_blocking_tiles = {16, 129 , 139}
smap.default_tile = 16
smap.maxrealx = smap.map_width * smap.tile_width
smap.maxrealy = smap.map_height * smap.tile_height
smap.hero_startpos = COORD:new({x = 8 , y = 8})
smap.scroll = COORD:new()
smap.offset = COORD:new({x=-8,y=-8})

smap.mob_type_list = {}
smap.monster_list = {
                    }
smap.item_list =	{
					}
smap.event_list =   {
                    }
