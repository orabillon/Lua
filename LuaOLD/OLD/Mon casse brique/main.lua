-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

require("tools")

local sceneJeu = require("SceneJeu")
local sceneMenu = require("SceneMenu")
local sceneGameOver = require("SceneGameOver")
local scm = require("SceneManager")

local Scene = sceneMenu
lstImgBrique = {}

function love.load()
	-- Redimentionne taille fenetre 
	love.window.setMode(528,600)
	love.window.setTitle("Casse Brique")
	love.audio.setVolume(0.1)

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	ChargerImage()
	ChargerSon()

	scm.AddScene("MENU", sceneMenu)
	scm.AddScene("JEU", sceneJeu)
	scm.AddScene("GAMEOVER", sceneGameOver)

	love.audio.play(sndIntro)
	scm.ChangeScene("MENU")
	
end

function love.update(dt)
	scm.currentScene.update(dt)
end

function love.draw()
	love.graphics.draw(imgFond,0,0)
	scm.currentScene.draw()
end

function ChargerImage()
	imgRaquette = love.graphics.newImage("images/raquette.png")
	imgRaquettePetit = love.graphics.newImage("images/raquette_petit.png")
	imgRaquetteGrand = love.graphics.newImage("images/raquette_grand.png")
	imgRaquetteTirs = love.graphics.newImage("images/raquette_Tirs.png")
	imgRaquettePetitTirs = love.graphics.newImage("images/raquette_petit_Tirs.png")
	imgRaquetteGrandTirs = love.graphics.newImage("images/raquette_grand_Tirs.png")
	imgBalle = love.graphics.newImage("images/balle.png")
	imgFond = love.graphics.newImage("images/fond_1.jpg")
	imgVie = love.graphics.newImage("images/bonus_vie.png")
	imgVieP = love.graphics.newImage("images/bonus_vie_p.png")
	imgFeu = love.graphics.newImage("images/bonus_feu.png")
	imgPadPetit = love.graphics.newImage("images/bonus_petit.png")
	imgPadGrand = love.graphics.newImage("images/bonus_grand.png")
	imgTirs = love.graphics.newImage("images/bonus_tirs.png")
	imgPtirs = love.graphics.newImage("images/tirs.png")
	imgMBL = love.graphics.newImage("images/bonus_multiball.png")
	imgLnt = love.graphics.newImage("images/bonus_lent.png")
	imgRpd = love.graphics.newImage("images/bonus_rapide.png")

	for i=1, 9 do
		lstImgBrique[i] = love.graphics.newImage("images/brique_"..i..".png")
	end
end

function ChargerSon()
	sndBriqueDure = love.audio.newSource("sons/arkanoid_brique_dure.wav","static")
	sndBrique = love.audio.newSource("sons/arkanoid_brique.wav","static")
	sndIntro= love.audio.newSource("sons/arkanoid_music_intro.wav","static")
	sndStart = love.audio.newSource("sons/arkanoid_music_start.wav","static")
	sndPerdu = love.audio.newSource("sons/arkanoid_perdu2.wav","static")
	sndRaquette = love.audio.newSource("sons/arkanoid_raquette.wav","static")
	sndCollision = love.audio.newSource("sons/wallCollision.wav","static")
	sndTirs = love.audio.newSource("sons/shoot.wav","static")
	sndVictoire = love.audio.newSource("sons/Applaudissements.wav","static")
end

function love.keypressed(key)
	scm.currentScene.keypressed(key)
end

function love.mousepressed(x,y,n)
		scm.currentScene.mousepressed(x,y,n)
end
