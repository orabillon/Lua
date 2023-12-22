local Game = {}

local Dice = require("src/dice")
local Etoile = require("src/star")
local Map = require("src/map")

function Game:new()
    local instance = {}
    setmetatable(instance, {__index = Game})

    instance.screenWidth = love.graphics.getWidth()
    instance.screenHeight = love.graphics.getHeight()

    instance.d6 = Dice:new(6)
    instance.lstEtoiles = {}

    instance.map = Map:new("assets/maps/map.json",love.graphics.newImage("assets/images/map/map.png"))
    instance.map:show()
    
    for n=1,100 do 
        table.insert(instance.lstEtoiles, Etoile:new(love.math.random(1, instance.screenWidth), love.math.random(1, instance.screenHeight)))
    end

    return instance
end

function Game:update(dt)
    
    for n=1, #self.lstEtoiles do 
        self.lstEtoiles[n]:update(dt, self.screenWidth)
    end

    self.d6:update(dt)
    self.map:update(dt)
end

function Game:draw()

    love.graphics.setBackgroundColor(1,1,1,1)

    for n=1, #self.lstEtoiles do 
        self.lstEtoiles[n]:draw()
    end

    self.map:draw()

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
