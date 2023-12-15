local Game = {}

local Dice = require("src/dice")

function Game:new()
    local instance = {}
    setmetatable(instance, {__index = Game})

    instance.d6 = Dice:new(6)
    instance.d6:show()
    return instance
end

function Game:update(dt)
    self.d6:update(dt)
end

function Game:draw()
    self.d6:draw()
end

function Game:keypressed(key)
    if key == "space" and self.d6.visible == true then
        self.d6:hide()
    elseif key == "space" and self.d6.visible == false then
        self.d6:show()
        self.d6:roll()
    end
end


return Game
