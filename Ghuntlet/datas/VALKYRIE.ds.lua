VALKYRIE.spr_faces = 4
VALKYRIE.sprite = Sprite.new("./images/Valkyrie_Sprite.png", VALKYRIE.spr_width, VALKYRIE.spr_height, VRAM)
VALKYRIE.sprite:addAnimation({2,6}, 200) -- Walk up
VALKYRIE.sprite:addAnimation({1,5}, 200) -- Walk right
VALKYRIE.sprite:addAnimation({0,4}, 200) -- Walk down
VALKYRIE.sprite:addAnimation({3,7}, 200) -- Walk left
