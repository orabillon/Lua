local Objet = require("src/objet")
local Dice = {}
setmetatable(Dice, {__index = Objet})


function Dice:new(pMax)
    local instance = Objet:new()
    setmetatable(instance, {__index = Dice})

    instance.value = 1
    instance.max = pMax

    instance.imgage = {}
    instance.imgage[1] = love.graphics.newImage("assets/images/dice_1.png")
    instance.imgage[2] = love.graphics.newImage("assets/images/dice_2.png")
    instance.imgage[3] = love.graphics.newImage("assets/images/dice_3.png")
    instance.imgage[4] = love.graphics.newImage("assets/images/dice_4.png")
    instance.imgage[5] = love.graphics.newImage("assets/images/dice_5.png")
    instance.imgage[6] = love.graphics.newImage("assets/images/dice_6.png")

    return instance
end

function Dice:roll()
    self.value = love.math.random(1, self.max)
end

function Dice:draw()
    if self.value >=1 and self.value <= 6 then
        love.graphics.setColor(1,1,1,self.alpha)
        love.graphics.draw(self.imgage[self.value], self.x, self.y)
    end
    love.graphics.setColor(1,1,1,1)
end

return Dice
