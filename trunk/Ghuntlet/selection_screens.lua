-- selectin_screens.lua


function select_game ()
	local select_game = {80, 100, 120}
	local selection = 1
	while (not Keys.newPress.Start) do
		Controls.read()
		if Keys.newPress.Up then selection = selection - 1 end
		if Keys.newPress.Down then selection = selection + 1 end
		if selection > 3 then selection = 1 end
		if selection < 1 then selection = 3 end
		screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
		screen.print(SCREEN_DOWN, 40, 50,"Welcome to Ghuntlet")
		screen.print(SCREEN_DOWN, 60, 80,"New Game")
		screen.print(SCREEN_DOWN, 60, 100,"Continue ==> [TODO] sorry :(")
		screen.print(SCREEN_DOWN, 60, 120,"Exit")
		screen.print(SCREEN_UP, 48, 148, selection)
		--screen.print(SCREEN_DOWN, 30 ,select_game[selection], "=>")
		spr1:playAnimation(SCREEN_DOWN, 40, select_game[selection] - 6, 4)
		render()
	end
	if selection == 1 then game.status = "select_plan" end
	if selection == 2 then game.status = "select_plan" end -- pas de gestion de sauvegarde pour le moment
	if selection == 3 then game.status = "gameover" end
end


function gameover ()
	while (not Keys.newPress.Start) do
		Controls.read()
		screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
		screen.print(SCREEN_DOWN, 48, 96,"Game Over")
		screen.print(SCREEN_DOWN, 48, 112,"Press Start to reset")
		render()
	end
	hero.scrpos = {120 , 88} -- Coordonnées du sprite du perso sur l'écran (centré)
	hero.realpos = {120 , 120} -- Coordonnées du centre du perso sur la map (initialisé)
	hero.lastpos = {128 , 128} -- Coordonnée précédente
	hero.move = {0 , 0} --coordonées de movement du héro
	hero.dir = 1 --Direction dans laquelle le héro se dirige (initialisé à 1)
	hero.speed = 3 --vitesse du héro
	hero.status = "OK"
	hero.maxlife = 100
	hero.life = 100
	game.status = "select_game"
end

function select_plan ()
	local selection = 1
	while (not Keys.newPress.A) do
		Controls.read()
		if Keys.newPress.Up then selection = selection - 1 end
		if Keys.newPress.Down then selection = selection + 1 end
		if selection > 3 then selection = 1 end
		if selection < 1 then selection = 3 end
		screen.print(SCREEN_UP, 0, 24,"Game status : "..game.status)
		screen.print(SCREEN_DOWN, 40, 20,"Select your map")
		screen.print(SCREEN_DOWN, 60, 40,"Dungeon 1")
		screen.print(SCREEN_DOWN, 60, 60,"Dungeon 2")
		screen.print(SCREEN_DOWN, 60, 80,"Exit")
		screen.print(SCREEN_UP, 48, 148, selection)
		spr1:playAnimation(SCREEN_DOWN, 40, 20 + selection*20 - 6, 4)
		render()
	end
	if selection == 1 then game.curentmap = "./plans/Dungeon_01.plan.lua" game.status = "ingame" end
	if selection == 2 then game.curentmap = "./plans/map_num.plan.lua" game.status = "ingame" end
	if selection == 3 then game.status = "select_game" end
dofile (game.curentmap)
end


