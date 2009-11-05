dofile ("./libs/lib_game_mechanicz.lua")
dofile ("./libs/lib_mobz.lua")
dofile ("./libs/lib_selectionz.lua")
dofile ("./libs/lib_display_DS.lua")

a = COORD:new({x = 10,y = 5})
a = a + a
print (a.x,a.y)

