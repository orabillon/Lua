local Sprite = {}

    Sprite.vx = 0
    Sprite.vy = 0
    Sprite.frame = 0
    Sprite.standing = false
    Sprite.x = 0
    Sprite.y = 0
    Sprite.type = nill

    function Sprite.CreateSprite (pEntite, pType, pX, pY)
        Sprite.x = pX
        Sprite.y = pY
        Sprite.type = pType

        table.insert(pEntite,Sprite)
        return Sprite
    end

    function Sprite.Update(dt)
            
    end

return Sprite