-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

local map = require("map")
local sprite = require("sprite")
local hero = nil

local listeSprites = {}

function love.load()

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	love.window.setTitle("Mini platformer (c) Gamecodeur 2021")
	InitGame(1)

end

function love.update(dt)
	hero.Update(dt)
end

function love.draw()

	for l=1,#map.Grid do
		for c=1,#map.Grid[1] do
		  	local char = string.sub(map.Grid[l],c,c)
		  	if tonumber(char) > 0 then
				love.graphics.draw(map.ImgTiles[char],(c-1)*map.TileSize,(l-1)*map.TileSize)
		  	end
		end
	end
	
end

function love.keypressed(key)
	
end

function love.mousepressed(x, y, button)
	print(map.getTileAt(x,y))
end

function InitGame(pNiveau)
	listeSprites = {}
	map.ChargeNiveau(1)
	hero = sprite.CreateSprite(listeSprites, "player", (map.level.playerStart.col - 1) * map.TileSize, (map.level.playerStart.lig - 1) * map.TileSize)
end
