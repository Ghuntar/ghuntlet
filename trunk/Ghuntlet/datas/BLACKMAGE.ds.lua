BLACKMAGE.spr_faces = 4
BLACKMAGE.sprite = Sprite.new("./images/BlackMage_Sprite.png", BLACKMAGE.spr_width, BLACKMAGE.spr_height, VRAM)
BLACKMAGE.sprite:addAnimation({2,6}, 200) -- Walk up
BLACKMAGE.sprite:addAnimation({1,5}, 200) -- Walk right
BLACKMAGE.sprite:addAnimation({0,4}, 200) -- Walk down
BLACKMAGE.sprite:addAnimation({3,7}, 200) -- Walk left
