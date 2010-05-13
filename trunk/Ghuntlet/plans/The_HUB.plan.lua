-- The_HUB.plan.lua

smap = {}

-- Taille des tuiles
smap.tile_width  = 16
smap.tile_height = 16

-- Nombre de tuiles sur la carte
smap.map_width = 50
smap.map_height = 50

-- Fichier Map
smap.BG_map = "./maps/The_HUB_BG.map"
smap.FG_map = "./maps/The_HUB_FG.map"

-- Fichier Tileset
smap.BG_Tileset = Image.load("./images/Ghuntlet_Dungeon_02.png", VRAM)
-- smap.FG_Tileset = Image.load("./images/Ghuntlet_dungeon.png", VRAM) -- On utilise le même fichier

-- Init (Scroll)Map
smap.BG_smap = ScrollMap.new(smap.BG_Tileset, smap.BG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.FG_smap = ScrollMap.new(smap.BG_Tileset, smap.FG_map, smap.map_width, smap.map_height, smap.tile_width, smap.tile_height)
smap.BG_blocking_tiles = {150,198,199,200,258,434,435,}
smap.default_tile = 17
smap.maxrealx = smap.map_width * smap.tile_width
smap.maxrealy = smap.map_height * smap.tile_height
smap.hero_startpos = COORD:new({x = 120 , y = 120})
smap.scroll = COORD:new()
smap.offset = COORD:new({x=-8,y=-8})

smap.mob_type_list = {}
smap.monster_list = {
                    -- {"Ratmut",{200 , 200}},
                    -- {"BlackMage",{220 , 280}},
                    -- {"Skeleton",{250,250}},
                    -- {"Ratmut",{210 , 280}},
                    -- {"BlackMage",{210 , 310}},
                    -- {"Skeleton",{240,240}},
                    -- {"Scarab",{270,140}},
                    }
smap.item_list =    {
                    -- ITEM:new({realpos = COORD:new({x=170,y=150})}),
                    -- KEY:new({realpos = COORD:new({x=150,y=170})}),
                    }
smap.event_list =   {
                    {coordm = COORD:new({x=7,y=9}),event_type = "stairs", level = "Base_Camp"},
                    {coordm = COORD:new({x=9,y=9}),event_type = "stairs", level = "Dungeon_01"},
                    {coordm = COORD:new({x=11,y=9}),event_type = "stairs", level = "Dungeon_02"},
                    {coordm = COORD:new({x=13,y=9}),event_type = "stairs", level = "Dungeon_03"},
                    {coordm = COORD:new({x=7,y=11}),event_type = "stairs", level = "Dungeon_04"},
                    {coordm = COORD:new({x=9,y=11}),event_type = "stairs", level = "map_num_2"},
                    {coordm = COORD:new({x=11,y=11}),event_type = "stairs", level = "map_num"},
                    {coordm = COORD:new({x=13,y=11}),event_type = "stairs", level = "Gameover"},
                    }
smap.NPC_list = {
                }