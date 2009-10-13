-- Ghuntlet
-- a Gauntlet pseudo clone by Ghuntar WALDMEISTER.
print ("\nLigne 1 :",package.path,"\n")
package.path = package.path.."../SVN/branch/Ghuntlet_POO/?.lua;"
print ("\nLigne 2 : ",package.path,"\n")
print ("\nLigne 3 : ",package.preload,"\n")
for k,v in ipairs (package.loaded) do print ("\nPackage.preload",k," :",v) end
print ("\nLigne 4 : ",System.currentDirectory(),"\n")
print ("\nLigne 5 : ",#package.preload)

--Load libraries
--heroz = require "lib_heroz"
--wpnz = require "lib_weaponz"
--monsterz = require "lib_monsterz"
--coordz = require "lib_coordz"
--selectionz = require "lib_selectionz"

require "lib_game_mechanicz"

for k,v in pairs (package.loaded) do print ("\nPackage.preload",k," :",v) end

printf ("Welcome in Ghuntlet")
