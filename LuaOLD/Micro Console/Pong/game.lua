local denver = require("denver")

local PadG = {}
local PadD = {}
local Ball = {}

local sine = denver.get({waveform = "whitenoise", frequency = 1200, length = 0.2})

function LanceBall() 
    while (Ball.vx == 0) do
        Ball.vx = love.math.random(-1,1)
    end
    while (Ball.vy == 0) do
        Ball.vy = love.math.random(-1,1)
    end
    
end

function Init()
    PadG = {}
    PadD = {}
    Ball = {}

    local P = { 254, 198, 198, 254, 254, 192, 192, 192}
    local O = { 255, 195, 195, 195, 195, 195, 195, 255}
    local N = { 255, 255, 195, 195, 195, 195, 195, 195}
    local G = { 0, 126, 64, 78, 66, 66, 126, 0}
    
    PadG.sprite = { 32, 96, 224, 224, 224, 224, 96, 32}
    PadG.x = 1
    PadG.y = 0

    PadD.sprite = { 4, 6, 7, 7, 7, 7, 6, 4}
    PadD.x = vthumb.display.width - 8
    PadD.y = vthumb.display.height - 8

    Ball.sprite = {192, 192, 0, 0, 0, 0, 0, 0}
    Ball.x = (vthumb.display.width / 2) - 2
    Ball.y = (vthumb.display.height / 2) - 2
    Ball.vx = 0
    Ball.vy = 0
    LanceBall()
end

function update()
    if vthumb.buttonU.pressed then
        if PadD.y > 0 then
            PadD.y = PadD.y - 1
        end  
    end
    if vthumb.buttonD.pressed then
        if PadD.y < vthumb.display.height - 8 then
            PadD.y = PadD.y + 1
        end  
    end
    if vthumb.buttonB.pressed then
        if PadG.y > 0 then
            PadG.y = PadG.y - 1
        end  
    end
    if vthumb.buttonA.pressed then
        if PadG.y < vthumb.display.height - 8 then
            PadG.y = PadG.y + 1
        end  
    end

    Ball.y = Ball.y + Ball.vy
    Ball.x = Ball.x + Ball.vx

    if Ball.x <= 0 then 
        Ball.x = 0
        Ball.vx = Ball.vx * - 1
    elseif Ball.x >= vthumb.display.width  then 
        Ball.x = vthumb.display.width
        Ball.vx = Ball.vx * - 1
    end

    if Ball.y <= 0 then 
        Ball.y = 0
        Ball.vy = Ball.vy * - 1
    elseif Ball.y >= vthumb.display.height then 
        Ball.y = vthumb.display.height
        Ball.vy = Ball.vy * - 1
    end
    
end

function draw()
    vthumb.Sprite(PadG.x,PadG.y,PadG.sprite)
    vthumb.Sprite(PadD.x,PadD.y,PadD.sprite)
    vthumb.Sprite(Ball.x,Ball.y,Ball.sprite)
end

Init()

function v()
    update()
    draw()
end
