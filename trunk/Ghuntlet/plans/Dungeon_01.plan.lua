-- Dungeon_01.plan

-- Taille des tuiles
tile_width  = 16
tile_height = 16

-- Nombre de tuiles sur la carte
map_width = 28
map_height = 28

-- Fichier Map
smap = {}
smap.BG_map = "./maps/Dungeon_01_BG.map"
smap.FG_map = "./maps/Dungeon_01_FG.map"

-- Fichier Tileset
smap.BG_Tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM)
-- smap.FG_tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM) -- On utilise le même fichier

-- Init (Scroll)Map
smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_map, map_width, map_height, tile_width, tile_height)
smap.FG_smap = ScrollMap.new(smap.BG_Tileset, smap.FG_map, map_width, map_height, tile_width, tile_height)
smap.BG_blocking_tiles = {129 , 139}

hero_startpos = {120 , 120}
-- mob_startpos = {200 , 200}
maxrealx = map_width * tile_width
maxrealy = map_height * tile_height

