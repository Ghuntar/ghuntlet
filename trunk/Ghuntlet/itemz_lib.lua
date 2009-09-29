-- itemz_lib.lua

Item = {}
Item_mt = {}
Item_mt.__index = Item


function Item.new (...)
	return setmetatable ({
					name = arg[1] or "Unnamed",
					startpos = {unpack (arg[2])} or {0 , 0},
					}, Item_mt)
end

function Item:init()
	self.race = "Unknown"
	self.speed = 0
	self.maxlife = 5
	self.width = 16
	self.height = 16
	self.half_width = self.width / 2
	self.half_height = self.height / 2
	self.realpos = {unpack(self.startpos)}
	self.lastpos = {0,0}
	self.scrpos = {0,0}
	self.move = {0,0}
	self.dir = 3
	self.life = self.maxlife
	self.status = "OK"
end
