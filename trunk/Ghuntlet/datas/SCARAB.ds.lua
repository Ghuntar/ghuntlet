SCARAB.spr_faces = 4
SCARAB.sprite = Sprite.new("./images/Bug_Sprite.png", SCARAB.spr_width, SCARAB.spr_height, VRAM)
SCARAB.sprite:addAnimation({2,6}, 200) -- Walk up
SCARAB.sprite:addAnimation({1,5}, 200) -- Walk right
SCARAB.sprite:addAnimation({0,4}, 200) -- Walk down
SCARAB.sprite:addAnimation({3,7}, 200) -- Walk left
