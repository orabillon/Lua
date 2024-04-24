-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Utilisation GUI
local myGUI = require("GCGUI")

-- Definition Font
local mainFont = love.graphics.newFont("assets/fonts/kenvector_future_thin.ttf", 15)
love.graphics.setFont(mainFont)

local groupTest 

-- evenement passer a la GUI
function onPanelHover(pState)
	print("Panel is hover :"..pState)
end
function onbuttonPressed(pState)
	print("Button is pressed :"..pState)
end
function onCheckboxSwitch(pState)
	print("Switch is:"..pState)
end

function love.load()

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	love.graphics.setBackgroundColor( 0.17, 0.57, 0.77, 1 )

	-- test GUI
	--panelTest1 = myGUI.newPanel(10, 350, 300, 200)
	panelTest1 = myGUI.newPanel(10, 350)

	textTest = myGUI.newText(panelTest1.X+10, panelTest1.Y, 300, 28, "HULL STATUS", mainFont, "center", "center", {151, 220, 250})
	panelTest1:setImage(love.graphics.newImage("assets/images/panel1.png"))

	buttonYes = myGUI.newButton(10, 20, 100, 43,"Yes", mainFont, {151, 220, 250})

	buttonNo = myGUI.newButton(115, 20, 100, 43,"No", mainFont, {151, 220, 250})
  	buttonNo:setImages(
    	love.graphics.newImage("assets/images/button_default.png"),
    	love.graphics.newImage("assets/images/button_hover.png"),
    	love.graphics.newImage("assets/images/button_pressed.png")
    )

	checkBoxTest1 = myGUI.newCheckbox(250, 30, 24, 24)
  	checkBoxTest1:setImages(
    	love.graphics.newImage("assets/images/dotRed.png"),
    	love.graphics.newImage("assets/images/dotGreen.png")
  	)
  	checkBoxTest1:setEvent("pressed", onCheckboxSwitch)

	title1 = myGUI.newText(panelTest1.X + 35, panelTest1.Y + 45, 0, 0, "Shield Generator", mainFont, "", "", {157, 164, 174})
	progressTest = myGUI.newProgressBar(panelTest1.X + 35, panelTest1.Y + 68, 220, 26, 100, {50,50,50}, {250, 129, 50})

	title2 = myGUI.newText(panelTest1.X + 35, panelTest1.Y + 45 + 70, 0, 0, "Generator Shield", mainFont, "", "", {157, 164, 174})
  
  	progressTest2 = myGUI.newProgressBar(panelTest1.X + 35, panelTest1.Y + 68 + 70, 220, 26, 100, {50,50,50}, {250, 129, 50})
                                    
  	progressTest2:setImages(love.graphics.newImage("assets/images/progress_grey.png"), love.graphics.newImage("assets/images/progress_green.png"))
	progressTest2:setValue(0)

	-- evenement GUI
	panelTest1:setEvent("hover", onPanelHover)
	buttonNo:setEvent("pressed", onbuttonPressed)
	checkBoxTest1:setEvent("pressed",onCheckboxSwitch)
	
	groupTest = myGUI.newGroup()
	groupTest:addElement(buttonYes)
	groupTest:addElement(buttonNo)
	groupTest:addElement(panelTest1)
	groupTest:addElement(textTest)
	groupTest:addElement(checkBoxTest1)
	groupTest:addElement(progressTest)
	groupTest:addElement(title1)
	groupTest:addElement(progressTest2)
	groupTest:addElement(title2)

end

function love.update(dt)
	groupTest:update(dt)

	if progressTest.Value > 0 then
		progressTest:setValue(progressTest.Value - 0.01)
	end
	if progressTest2.Value < 100 then
		progressTest2:setValue(progressTest2.Value + 0.01)
	end
end

function love.draw()
	groupTest:draw()
end

function love.keypressed(key)
end
