DOUBLEAXE = ATTACK:new (  {touch_attack = 2,
                            speed = 5,
                            angle = 0,
                            TTL = 1500,
                            })

function DOUBLEAXE:compute_move()
end

function DOUBLEAXE:chooseanewdir()
    Debug.print("Angle : "..self.angle)
    if self.timer:time() ~= 0
    then
        self.newpos.x = 16*math.cos(self.angle)--*self.angle--*10
        self.newpos.y = 16*math.sin(self.angle)--*self.angle--*10
        Debug.print("self.newpos.x : "..self.newpos.x)
        Debug.print("self.newpos.y : "..self.newpos.y)
        self.newpos = self.newpos + self.owner.realpos
        Debug.print("self.newpos.x : "..self.newpos.x)
        Debug.print("self.newpos.y : "..self.newpos.y)
        self.angle = (self.angle + 0.2)%(math.pi*2)
        if self.angle > 0.7 then self.owner.dir = 3 end
        if self.angle > 2.2 then self.owner.dir = 2 end
        if self.angle > 3.7 then self.owner.dir = 1 end
        if self.angle > 5.2 then self.owner.dir = 4 end
        self.dir = self.owner.dir
        self.inmove = true
    else
    self.inmove = false    
    end
end
