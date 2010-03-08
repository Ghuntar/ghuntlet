MAIDENGUARD.spr_faces = 4
MAIDENGUARD.sprite = Sprite.new("./images/MaidenGuard_Sprite.png", MAIDENGUARD.spr_width, MAIDENGUARD.spr_height, VRAM)
MAIDENGUARD.sprite:addAnimation({2,6}, 200) -- Walk up
MAIDENGUARD.sprite:addAnimation({1,5}, 200) -- Walk right
MAIDENGUARD.sprite:addAnimation({0,4}, 200) -- Walk down
MAIDENGUARD.sprite:addAnimation({3,7}, 200) -- Walk left
