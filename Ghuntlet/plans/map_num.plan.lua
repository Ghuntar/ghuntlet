-- map_num.plan.lua

-- taille des tuiles
tile_width  = 16
tile_height = 16

-- nombre de tuiles sur la carte
map_width = 6
map_height = 6

-- fichier map
smap = {}
smap.BG_map = "./maps/map_num_BG.map"
smap.FG_map = "./maps/map_num_FG.map"

-- Fichier Tileset
smap.BG_Tileset = Image.load("./images/map_num.png", VRAM)
smap.FG_tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM)

-- Init (Scroll)Map
smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_map, map_width, map_height, tile_width, tile_height)
smap.FG_smap = ScrollMap.new(smap.BG_Tileset, smap.FG_map, map_width, map_height, tile_width, tile_height)
smap.BG_blocking_tiles = {16, 129 , 139}

hero_startpos = {16 , 16}
mob_startpos = {48 , 48}
maxrealx = map_width * tile_width
maxrealy = map_height * tile_height

