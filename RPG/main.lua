-- // DEBUGUER LUA // --------------
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
if pcall(require, "mobdebug") then
    require("mobdebug").start()
end
------------------------------------

io.stdout:setvbuf("no")

local Game = require("src/game")
local Dice = require("src/dice")

local monRpg = Game:new()
local d6 = Dice:new(6)
d6:roll()

function love.load()
    love.window.setTitle("Paper RPG by Gamecodeur")

    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
end

function love.update(dt)
    monRpg:update(dt)
end

function love.draw()
    monRpg:draw()
    d6:draw()
end

function love.mousepressed(x, y, b)
end

function love.keypressed(key)
    if key == "space" then
        d6:roll()
    end
end
