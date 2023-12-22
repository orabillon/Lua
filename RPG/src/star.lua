local Objet = require("src/objet")
local Stars = {}
setmetatable(Stars, {__index = Objet})

function Stars:new(pX, pY)
    local instance = Objet:new()
    setmetatable(instance, {__index = Stars}) -- Relie l'instance à la table Stars

    instance.x = pX
    instance.y = pY
    instance.r = love.math.random(1 , 3)
    instance.vx = -8 * instance.r

    return instance
end

function Stars:draw()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.circle("fill", self.x, self.y, self.r)
    love.graphics.setColor(1,1,1,1)
end

function Stars:update(dt, screenWidth)
    self.x = self.x + dt * self.vx
    if self.x < 0 - self.r then
        self.x = self.x + (screenWidth + self.r)
    end
end

return Stars