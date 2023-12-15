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


local monRpg = Game:new()

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
  
end

function love.mousepressed(x, y, b)
end

function love.keypressed(key)
    monRpg:keypressed(key)
end
