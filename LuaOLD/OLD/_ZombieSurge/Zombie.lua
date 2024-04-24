local Sprite = require("Sprite")

local ZSTATES = {}
ZSTATES.NONE = ""
ZSTATES.WALK = "walk"
ZSTATES.ATTACK = "attack"
ZSTATES.BITE = "bite"
ZSTATES.CHANGEDIR = "change"

local Zombie = {}
setmetatable(Zombie, {__index = Sprite})

function Zombie:new(pType)
    local instance = Sprite:new(pType)
    setmetatable(instance, {__index = Zombie})

    instance.energie = 100
    instance.state = ZSTATES.NONE
    instance.range = 0
    instance.target = nil

    return instance
end

function Zombie:SetRange(pRange)
    self.range = pRange
end

function Zombie:IA()
    if self.state == ZSTATES.NONE then
        self.state = ZSTATES.CHANGEDIR
    elseif self.state == ZSTATES.CHANGEDIR then
        local angle = math.angle(self.x, self.y, love.math.random(0, screenWidth),love.math.random(0,screenHeight))
		self.vx =  math.cos(angle)
		self.vy =  math.sin(angle)
		self.state = ZSTATES.WALK 
    end
end



return Zombie
