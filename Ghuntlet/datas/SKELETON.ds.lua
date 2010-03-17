SKELETON.spr_faces = 4
SKELETON.sprite = Sprite.new("./images/Skeleton.png", SKELETON.spr_width, SKELETON.spr_height, VRAM)
SKELETON.sprite:addAnimation({2,6}, 200) -- Walk up
SKELETON.sprite:addAnimation({1,5}, 200) -- Walk right
SKELETON.sprite:addAnimation({0,4}, 200) -- Walk down
SKELETON.sprite:addAnimation({3,7}, 200) -- Walk left
