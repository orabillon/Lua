-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- =======================================================================================================================================
-- ========= VARIABLE GLOBAL =========
-- =======================================================================================================================================

scene = "menu"

local subMarine = {}
subMarine.x = 0
subMarine.y = 0

-- =======================================================================================================================================
-- ========= GAME LOOP LOVE =========
-- =======================================================================================================================================

function love.load()
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	imgFond = love.graphics.newImage("images/fond.jpg")

	subMarine.img = love.graphics.newImage("images/sous-marin-heros.png")

	iniGame()
	
end

function love.update(dt)
	if (scene == "menu") then
		updateMenu(dt)
	elseif (scene == "game") then
		updateGame(dt)
	elseif (scene == "gameOver") then
		updateGameOver(dt)
	end
end

function love.draw()
	if (scene == "menu") then
		drawMenu()
	elseif (scene == "game") then
		drawGame()
	elseif (scene == "gameOver") then
		drawMenuGameOver()
	end
end

function love.keypressed(key)
	if (scene == "menu") then
		keypressedMenu(key)
	elseif (scene == "game") then
		keypressedGame(key)
	elseif (scene == "gameOver") then
		keypressedMenuGameOver(key)
	end
end

-- =======================================================================================================================================
-- =================== MENU =====================
-- =======================================================================================================================================

function updateMenu(dt)
	
end

function drawMenu()

end

function keypressedMenu(key)
	if (key == "space") then
		scene = "game"
	end
end

-- =======================================================================================================================================
-- =================== GamePlay =====================
-- =======================================================================================================================================

function updateGame(dt)
	
end

function drawGame()
	love.graphics.draw(imgFond,0,0)
	love.graphics.draw(subMarine.img,subMarine.x,subMarine.y)
end

function keypressedGame(key)
end

-- =======================================================================================================================================
-- =================== Game Over=====================
-- =======================================================================================================================================

function updateGameOver(dt)
	
end

function drawMenuGameOver()

end

function keypressedMenuGameOver(key)
end


-- =======================================================================================================================================
-- =======================================================================================================================================
-- =======================================================================================================================================

function iniGame() 
	subMarine.x = (screenWidth / 2) - (subMarine.img:getWidth() / 2)
	subMarine.y = (screenHeight / 2) - (subMarine.img:getHeight() / 2)
end
