--controls_ds.lua

-- Cette fonction contrôle la croix de direction et renvoie la direction
function get_dir ()
--6|1|5
--2|0|4
--7|3|8
	local direction = 0
	Controls.read()
		if Keys.held.Up and Keys.held.Right then direction = 5
		elseif Keys.held.Up and Keys.held.Left then direction = 6
		elseif Keys.held.Down and Keys.held.Left then direction = 7
		elseif Keys.held.Down and Keys.held.Right then direction = 8
		elseif Keys.held.Up then direction = 1
		elseif Keys.held.Left then direction = 2
		elseif Keys.held.Down then direction = 3
		elseif Keys.held.Right then direction = 4
		end
	return direction
	end

--##########################################################

--@TODO Contôles du touchscreen à étudier pour bonus/changement d'arme-sort/inventaire ?/etc...
