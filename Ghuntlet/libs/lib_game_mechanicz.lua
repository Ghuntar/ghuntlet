--lib_game_mechanicz.lua


--####################################
--#              COORD              #
--##################################

COORD = {
		x = 0,
		y = 0
		}

function COORD:new(obj)
	local newobject = obj or {}
	setmetatable(newobject, self)
	self.__index = self
	return newobject
end

function COORD.add(other)
	local new = COORD:new()
	new.x = self.x + other.x
	new.y = self.y + other.y
	return new
end

function COORD.__add(obj1,obj2)
	local new = COORD:new()
	new.x = obj1.x + obj2.x
	new.y = obj1.y + obj2.y
	return new
end

function COORD.__sub(obj1,obj2)
	local new = COORD:new()
	new.x = obj1.x - obj2.x
	new.y = obj1.y - obj2.y
	return new
end

--####################################
--#              Misc               #
--##################################

-- This function test if value "value" is in a table "array"
function is_in_table (value , array)
	for k, v in pairs (array) do
		if value == v then return true end
	end
	return false
end


--####################################
--#              STATUS             #
--##################################


function gameover()

end

function ingame()

-- Initialisation
game.moblist = {}
game.itemlist = {}

hero = game.hero:new()
hero:init()

Controls.read()
    while (game.status == "ingame" or game.status == "pause") do
        Controls.read()
        if (Keys.newPress.Start and (#game.moblist > 0)) then game.status = "exit" end
        if (Keys.newPress.Start and (#game.moblist < 1)) then game.status = "exit" end
        screen.print(SCREEN_UP,0,0,"Press Start to exit")
        hero:display()
        render()
    end

    game.status = "exit"
end

