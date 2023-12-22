local json = require("src/json")
local Objet = require("src/objet")

local Map = {}
setmetatable(Map, {__index = Objet})

MAP_MUR     = 1
MAP_MONSTRE = 2
MAP_PIECE   = 3
MAP_COFFRE  = 4
MAP_POTION  = 5
MAP_HEROS   = 8
MAP_SORTIE  = 9

function Map:new(pJSON, pImage)
    local instance = Objet:new()
    setmetatable(instance, {__index = Map}) 

    instance.x      = 0
    instance.y      = 0
    
    instance:setImg(pImage)

    instance.ImagesElement = {}
    instance.ImagesElement[MAP_MONSTRE]    = love.graphics.newImage("assets/images/map/icon_skull.png")
    instance.ImagesElement[MAP_PIECE]      = love.graphics.newImage("assets/images/map/icon_coin.png")
    instance.ImagesElement[MAP_HEROS]      = love.graphics.newImage("assets/images/map/icon_heros.png")
    instance.ImagesElement[MAP_COFFRE]     = love.graphics.newImage("assets/images/map/icon_chest.png")
    instance.ImagesElement[MAP_POTION]     = love.graphics.newImage("assets/images/map/icon_potion.png")

    -- lecture JSON
    local mapJSON = love.filesystem.read(pJSON)
    instance._dataMap = json.decode(mapJSON)

    -- variable simplificatrice
    instance.nbLigne        = instance._dataMap.hauteur
    instance.nbColonne      = instance._dataMap.largeur
    instance.tailleCase     = instance._dataMap.tailleCase

    instance.x = instance._dataMap.x
    instance.y = instance._dataMap.y

    -- position de la soutis
    instance.col = 1
    instance.lig = 1


    return instance
end

function Map:update(dt)
    Objet.update(self, dt) -- appel fontion parente

    local mx,my = love.mouse.getPosition()
    local c = math.floor((mx / self.tailleCase) + 1)
    local l = math.floor((my / self.tailleCase) + 1)

    if c >= 1 and c <= self.nbColonne and l >= 1 and l <= self.nbLigne then
        self.col = c
        self.lig = l
    else
        self.col = 1
        self.lig = 1
    end

end

function Map:getTile(pL, pC) 
    return self._dataMap.grid[pL][pC]
end

function Map:draw() 
    Objet.draw(self)

    love.graphics.setColor(1,1,1,self.alpha)

    for l=1, self.nbLigne do
        for c=1, self.nbColonne do
            local id = self:getTile(l,c)

            local x = (c - 1) * self.tailleCase
            local y = (l - 1) * self.tailleCase

            if self.ImagesElement[id] ~= nill then
               love.graphics.draw(self.ImagesElement[id],x,y) 
            end
        end
    end

    local x = (self.col - 1) * self.tailleCase
    local y = (self.lig - 1) * self.tailleCase
    love.graphics.setColor(0,0,0,.5)
    love.graphics.rectangle("fill", x, y, self.tailleCase, self.tailleCase)
    love.graphics.setColor(1,1,1,self.alpha)

    love.graphics.setColor(1,1,1,1)

end

return Map