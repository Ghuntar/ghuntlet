PORTAL = MONSTER:new    (
                            {
                                name = "Portal",
                                race = "Warp",
                                speed = 0,
                                maxlife = 20,
                                --d_attack = "Pentacle",
                                touch_attack = 1,
                                summon_timer = Timer.new(),
                            }
                        )

function PORTAL:chooseifattack()
    if self.summon_timer:time() > 5000
    then
        self.summon_timer:stop()
        self.summon_timer:reset()
    end
    if #smap.mob_list < 20 and self.summon_timer:time() == 0
    then
        self.summon_timer:start()
        return true
    end
end

function PORTAL:makeanattack()
    local monster_type = math.random(#smap.mob_type_list)
    table.insert (smap.mob_list, SKELETON:new({realpos = self.realpos + {x=math.random(-1,1)*16,y=math.random(-1,1)*16}}))
    -- table.insert (smap.mob_list, _G[smap.mob_type_list[monster_type]]:new({realpos = self.realpos + {x=math.random(-1,1)*16,y=math.random(-1,1)*16}}))
end
