-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")


local sceneJeu = require("src/SceneJeu")
local sceneMenu = require("src/SceneMenu")
local sceneGameOver = require("src/SceneGameOver")
local scm = require("src/SceneManager")

local Scene = sceneMenu
local scoreFont = love.graphics.newFont("assets/font/pixelmix.ttf", 35)


function love.load()
    love.window.setTitle("Space Attack !!!")
    love.graphics.setFont(scoreFont)
    love.audio.setVolume(0.1)

    screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

    scm.AddScene("MENU", sceneMenu)
	scm.AddScene("JEU", sceneJeu)
	scm.AddScene("GAMEOVER", sceneGameOver)

	scm.ChangeScene("MENU")

end

function love.update(dt)
    scm.currentScene.update(dt)
end

function love.draw()
    scm.currentScene.draw()
end

function love.keypressed(key)
	scm.currentScene.keypressed(key)
end

function love.mousepressed(x,y,n)
	scm.currentScene.mousepressed(x,y,n)
end