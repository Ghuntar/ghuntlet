BLACKMAGE_LB.spr_faces = 4
BLACKMAGE_LB.sprite = Sprite.new("./images/BlackMage_LB_Sprite.png", BLACKMAGE_LB.spr_width, BLACKMAGE_LB.spr_height, VRAM)
BLACKMAGE_LB.sprite:addAnimation({2,6}, 200) -- Walk up
BLACKMAGE_LB.sprite:addAnimation({1,5}, 200) -- Walk right
BLACKMAGE_LB.sprite:addAnimation({0,4}, 200) -- Walk down
BLACKMAGE_LB.sprite:addAnimation({3,7}, 200) -- Walk left
