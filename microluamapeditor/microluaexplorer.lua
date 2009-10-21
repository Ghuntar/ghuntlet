--microexplorer.lua

files = {}
nbFiles = 0
selectedFile = {}

dirnamecolor = nil


function fileExists(fname)
	local statusfile, errfile
	statusfile, errfile = pcall(function() -- check if file exists
		f = io.open(fname)
		io.close(f)
	end)
	return (errfile == nil)
end

function reInit()
	Debug.clear()
	Debug.OFF()
	startList = 0
	selected = 0
	exeFile = ""
	files = System.listDirectory(System.currentDirectory())
end

function drawList(dirname)
	files = System.listDirectory(dirname)
	y = 0
	i = 0
	nbFiles = 0
	for k, file in pairs(files) do
		if i >= startList and i <= startList + 24 then
			y = y + 8
			if file.isDir then
				color = dirnamecolor -- directory
			else
				color = filenamecolor-- file
			end
			if i == selected then
				color = selectcolor -- select
				selectedFile = file
			end
			if file.isDir then
				screen.print(SCREEN_DOWN, 8, y, "["..file.name.."]", color)
			else
				screen.print(SCREEN_DOWN, 8, y, " "..file.name, color)
				if string.lower(string.sub(file.name, -4)) == ".lua" then
					screen.print(SCREEN_DOWN, 0, y, "*", color)
				end
			end
		end
		i = i + 1
		nbFiles = nbFiles + 1
	end

end

startList = 0
selected = 0
exeFile = ""

function goDown()
	if selected < nbFiles-1 then selected = selected + 1 end
	if selected - startList == 23 then startList = startList + 1 end
end

function goUp()
	if selected > 0 then selected = selected - 1 end
	if selected - startList == -1 then startList = startList - 1 end
end



