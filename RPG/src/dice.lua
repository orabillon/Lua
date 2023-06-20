local Dice = {}

-- 37.54

function Dice:new(pMax)
    local instance = {}
    setmetatable(instance, {__index = Dice})

    instance.value = 1
    instance.max = pMax

    return instance
end

function Dice:roll()
    self.value = love.math.random(1, self.max)
end

function Dice:update(dt)
end

function Dice:draw()
    love.graphics.print("la valeur du dé est : " .. self.value)
end

return Dice
