local scm = require("src/SceneManager")

local sceneGameOver = {}

function sceneGameOver.load()
	love.mouse.setGrabbed(false)
	love.mouse.setVisible(true)
end

function sceneGameOver.update(dt)
end

function sceneGameOver.draw()
	love.graphics.print("GAME OVER")
end

function sceneGameOver.mousepressed(x,y,n)	
end

function sceneGameOver.keypressed(key)
	if key == "return" then
		scm.ChangeScene("MENU")
	end
end

function sceneGameOver.unload()
end

return sceneGameOver