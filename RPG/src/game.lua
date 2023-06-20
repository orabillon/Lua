local Game = {}

function Game:new()
    local instance = {}
    setmetatable(instance, {__index = Game})
    return instance
end

function Game:update(dt)
end

function Game:draw()
end

return Game
