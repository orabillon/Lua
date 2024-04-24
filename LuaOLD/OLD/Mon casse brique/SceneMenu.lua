local sceneMenu = {}

local scm = require("SceneManager")

local fontMenu
local lstColor = {}
local menuSin = 5
local amplitudeSin = 30

function sceneMenu.load()
	fontMenu = love.graphics.newFont("ec-bricks.ttf", 42)
	
	love.graphics.setFont(fontMenu)

	lstColor[1] = {105/255,106/255,106/255}
	lstColor[2] = {172/255,50/255,50/255}
	lstColor[3] = {223/255,113/255,38/255}
	lstColor[4] = {75/255,105/255,47/255}
	lstColor[5] = {91/255,110/255,225/255}

end

function sceneMenu.update(dt)
	menuSin = menuSin + 4 * 60 * dt
end

function sceneMenu.draw()
	local sMessage = "CASSE BRIQUE"
	local w = fontMenu:getWidth(sMessage)
	local h = fontMenu:getHeight(sMessage)
	local idColor = 1
	local x = (screenWidth - w)/2
	local y = 0

	for  c=1, sMessage:len() do 
		local Color = lstColor[idColor]
		love.graphics.setColor(Color[1],Color[2],Color[3])
		local char = string.sub(sMessage,c,c)
		y = math.sin((x+menuSin)/50)*amplitudeSin
		love.graphics.print(char, x, y + (screenHeight - h) /2)
		x = x + fontMenu:getWidth(char)
		idColor = idColor + 1
		if idColor > #lstColor then
			idColor = 1
		end
	end
	love.graphics.setColor(1,1,1,1)
end

function sceneMenu.unload()
end

function sceneMenu.keypressed(key)
	if key == "return" then
		scm.ChangeScene("JEU")
	end
end

function sceneMenu.mousepressed(x,y,n)

end


return sceneMenu