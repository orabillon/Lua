-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- fonction outil en global
require("outils")

local scene_manager = require("Scene/SceneManager")
local menu = require("Scene/SceneMenu")
local game = require("Scene/SceneGame")

SceneManager = scene_manager:new()

function love.load()

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	SceneManager:SetScene("Menu",menu:new())
	SceneManager:SetScene("Game",game:new())
	SceneManager:ChangeScene("Menu")
end

function love.update(dt)
	 SceneManager:Update(dt)
end

function love.draw()
	SceneManager:Draw()
end

function love.keypressed(key)
	SceneManager:Keypressed(key)
end
