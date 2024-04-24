local Sprite = require("Sprite")

local hero = {}
setmetatable(hero, {__index = Sprite})

function hero:new(pType)
    local instance = Sprite:new(pType)
    setmetatable(instance, {__index = hero})

    instance.vie = 100

    return instance
end

function hero:Affiche()
    print("Je suis un héros")
end


function hero:Update(dt)
    -- Equivalent du .base
    Sprite.Update(self,dt)

    if love.keyboard.isDown("down") then
        self.y = self.y + self.speed * dt
    end
    if love.keyboard.isDown("up") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
        self.directionAnimation = -1
    end
    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
        self.directionAnimation = 1
    end

    -- Colision bord
    if self.x < 0 then
        self.x = 0
    end
    if self.x > screenWidth then
        self.x = screenWidth
    end
    if self.y < 0 then
        self.y = 0
    end
    if self.y > screenHeight then
        self.y = screenHeight
    end
end


return hero
