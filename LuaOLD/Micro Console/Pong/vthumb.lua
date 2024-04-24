--[[

██╗   ██╗████████╗██╗  ██╗██╗   ██╗███╗   ███╗██████╗ 
██║   ██║╚══██╔══╝██║  ██║██║   ██║████╗ ████║██╔══██╗
██║   ██║   ██║   ███████║██║   ██║██╔████╔██║██████╔╝
╚██╗ ██╔╝   ██║   ██╔══██║██║   ██║██║╚██╔╝██║██╔══██╗
 ╚████╔╝    ██║   ██║  ██║╚██████╔╝██║ ╚═╝ ██║██████╔╝
  ╚═══╝     ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═════╝ 
                                         
  Version : 220525-1
  (C) Gamecodeur Mai 2022 - By David Mekersa

]]
vthumb = {}
vthumb.display = {
    width = 72,
    height = 40
}

local sleep = 0.03
local vram = {}
local bCrash = false
local Error = ""

local VIDEOX = 333
local VIDEOY = 139

keystate = {}

OR, XOR, AND = 1, 3, 4

require("game")

function bitand(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
            result = result + bitval -- set the current bit
        end
        bitval = bitval * 2 -- shift left
        a = math.floor(a / 2) -- shift right
        b = math.floor(b / 2)
    end
    return result
end

function Crash(pError)
    bCrash = true
    Error = pError
end

function vthumb.setPixel(px, py)
    if px == nil then
        Crash("setPixel: no x provided")
        return
    end
    if py == nil then
        Crash("setPixel: no y provided")
        return
    end

    if px >= 1 and px <= vthumb.display.width and py >= 1 and py <= vthumb.display.height then
        vram[py][px] = 1
    else
        -- ERROR
        Crash("setPixel out of bounds")
    end
end

function vthumb.getPixel(px, py)
    if px == nil then
        Crash("getPixel: no x provided")
        return
    end
    if py == nil then
        Crash("getPixel: no y provided")
        return
    end

    if px >= 1 and px <= vthumb.display.width and py >= 1 and py <= vthumb.display.height then
        return vram[py][px]
    else
        -- ERROR
        Crash("getPixel out of bounds")
    end
end

function vthumb.Sprite(px, py, map)
    if map == nil then
        Crash("Sprite: no map provided")
        return
    end
    if px == nil then
        Crash("Sprite: no x provided")
        return
    end
    if py == nil then
        Crash("Sprite: no y provided")
        return
    end

    local mask = {128, 64, 32, 16, 8, 4, 2, 1}
    if #map ~= 8 then
        Crash("Sprite: height is not 8 lines")
    end
    local x, y
    for l = 1, 8 do
        local byte = map[l]
        if byte < 0 or byte > 255 then
            Crash("Sprite: line not a byte (should be between 0 and 255)")
        end
        y = py + (l - 1)
        for p = 1, 8 do
            x = px + (p - 1)
            if x >= 1 and x <= vthumb.display.width and y >= 1 and y <= vthumb.display.height then
                if bitand(byte, mask[p], AND) ~= 0 then
                    vthumb.setPixel(x, y)
                end
            end
        end
    end
end

local bg, bgol
local freq
local vthumb_engine = {}

local function clearVram()
    vram = {}
    for l = 1, vthumb.display.height do
        vram[l] = {}
        for c = 1, vthumb.display.width do
            vram[l][c] = 0
        end
    end
end

local function clearKeystate()
    vthumb.buttonA = {pressed = false, justPressed = false}
    vthumb.buttonB = {pressed = false, justPressed = false}
    vthumb.buttonU = {pressed = false, justPressed = false}
    vthumb.buttonD = {pressed = false, justPressed = false}
    vthumb.buttonL = {pressed = false, justPressed = false}
    vthumb.buttonR = {pressed = false, justPressed = false}
end

local function setKeystate()
    vthumb.buttonA.justPressed = love.keyboard.isDown("w") and vthumb.buttonA.pressed == false
    vthumb.buttonB.justPressed = love.keyboard.isDown("x") and vthumb.buttonB.pressed == false
    vthumb.buttonU.justPressed = love.keyboard.isDown("up") and vthumb.buttonU.pressed == false
    vthumb.buttonD.justPressed = love.keyboard.isDown("down") and vthumb.buttonD.pressed == false
    vthumb.buttonL.justPressed = love.keyboard.isDown("left") and vthumb.buttonL.pressed == false
    vthumb.buttonR.justPressed = love.keyboard.isDown("right") and vthumb.buttonR.pressed == false

    vthumb.buttonA.pressed = love.keyboard.isDown("w")
    vthumb.buttonB.pressed = love.keyboard.isDown("x")
    vthumb.buttonU.pressed = love.keyboard.isDown("up")
    vthumb.buttonD.pressed = love.keyboard.isDown("down")
    vthumb.buttonL.pressed = love.keyboard.isDown("left")
    vthumb.buttonR.pressed = love.keyboard.isDown("right")
end

function vthumb_engine.load()
    clearVram()
    clearKeystate()

    pressedButton = {
        up = love.graphics.newImage("images/buttonU.png"),
        down = love.graphics.newImage("images/buttonD.png"),
        left = love.graphics.newImage("images/buttonL.png"),
        right = love.graphics.newImage("images/buttonR.png"),
        ab = love.graphics.newImage("images/buttonAB.png")
    }

    positionButton = {
        cross = {x = 294, y = 302},
        buttonA = {x = 428, y = 341},
        buttonB = {x = 473, y = 310}
    }

    bg = love.graphics.newImage("images/thumbybg.png")
    bgol = love.graphics.newImage("images/overlay.png")
    freq = 0

    love.window.setTitle("Virtual Thumby by Gamecodeur (inspired by https://thumby.us/ from TinyCircuits)")
end

function vthumb_engine.update(dt)
    love.timer.sleep(sleep)

    clearVram()
    setKeystate()

    if love.timer.getFPS() >= 30 then
        sleep = sleep + 0.0001
    else
        sleep = sleep - 0.0001
    end

    freq = freq + 1
    if freq > vthumb.display.height * 2 then
        freq = -15
    end

    if bCrash == false then
        v()
    end
end

local function drawEngine()
    love.graphics.draw(bg)
    love.graphics.draw(bgol)

    -- Display vram
    local x = VIDEOX
    local y = VIDEOY
    for l = 1, vthumb.display.height do
        for c = 1, vthumb.display.width do
            local pixel = vram[l][c]
            if pixel == 1 then
                love.graphics.setColor(1, 1, 1)
            else
                if y - VIDEOY >= freq and y - VIDEOY <= freq + 15 then
                    love.graphics.setColor(0.05, 0.05, 0.05)
                else
                    love.graphics.setColor(0, 0, 0)
                end
            end
            love.graphics.rectangle("fill", x, y, 2, 2)
            x = x + 2
        end
        x = VIDEOX
        y = y + 2
    end
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print("FPS:" .. math.ceil(love.timer.getFPS()), love.graphics.getWidth() - 60, 1)

    if vthumb.buttonA.pressed == true then
        love.graphics.draw(pressedButton.ab, positionButton.buttonA.x, positionButton.buttonA.y)
    end

    if vthumb.buttonB.pressed == true then
        love.graphics.draw(pressedButton.ab, positionButton.buttonB.x, positionButton.buttonB.y)
    end

    if vthumb.buttonU.pressed == true then
        love.graphics.draw(pressedButton.up, positionButton.cross.x, positionButton.cross.y)
    elseif vthumb.buttonD.pressed == true then
        love.graphics.draw(pressedButton.down, positionButton.cross.x, positionButton.cross.y)
    end

    if vthumb.buttonL.pressed == true then
        love.graphics.draw(pressedButton.left, positionButton.cross.x, positionButton.cross.y)
    elseif vthumb.buttonR.pressed == true then
        love.graphics.draw(pressedButton.right, positionButton.cross.x, positionButton.cross.y)
    end
end

function vthumb_engine.draw()
    if bCrash == false then
        drawEngine()
    else
        love.graphics.setBackgroundColor(0.7 + love.math.random(5) / 100, 0, 0)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("> Virtual Thumby | Guru Meditation", 1, 5)
        love.graphics.print("> " .. Error, 1, 20)
    end
end

return vthumb_engine
