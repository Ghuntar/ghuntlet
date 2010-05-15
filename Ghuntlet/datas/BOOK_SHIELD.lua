BOOK_SHIELD = ATTACK:new (  {touch_attack = 3,
                            angle = 0,
                            TTL = 1500,
                            })

function BOOK_SHIELD:compute_move()
end

function BOOK_SHIELD:chooseanewdir()
    Debug.print("Angle : "..self.angle)
    if self.timer:time() ~= 0
    then
        self.newpos.x = 16*math.cos(self.angle)
        self.newpos.y = 16*math.sin(self.angle)
        Debug.print("self.newpos.x : "..self.newpos.x)
        Debug.print("self.newpos.y : "..self.newpos.y)
        self.newpos = self.newpos + self.owner.realpos
        Debug.print("self.newpos.x : "..self.newpos.x)
        Debug.print("self.newpos.y : "..self.newpos.y)
        self.angle = (self.angle + 0.2)%(math.pi*2)
        self.inmove = true
    else
    self.angle = 0
    self.inmove = false    
    end
end
