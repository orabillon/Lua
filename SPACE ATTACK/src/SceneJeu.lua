local sceneJeu = {}

local scm = require("src/SceneManager")

local fontJeu
local scrolling = 0
local imageFond = love.graphics.newImage("assets/images/fond1.png")

local vaisseau = {}
local imageVaisseau = love.graphics.newImage("assets/images/ship.png")
local imageExplosion = love.graphics.newImage("assets/images/explosion.png")

local enemies = {}
local imageEnemie = love.graphics.newImage("assets/images/ennemi.png")
local timerEnemie = 0
local frequenceEnemie = 3

local imageTir = love.graphics.newImage("assets/images/tir.png")
local tirs = {}

local score = 0

local scoreFont = love.graphics.newFont("assets/font/pixelmix.ttf", 35)

sonTir = love.audio.newSource("assets/sons/tir.wav", "static")
sonExplosion = love.audio.newSource("assets/sons/explosion.wav", "static")

function initJeu()
    vaisseau.x = 800 / 2
    vaisseau.y = 600 - imageVaisseau:getHeight() 
    vaisseau.explose = 0
    enemies = {}
    timmerEnemie = 0
    frequenceEnemie = 3 -- apparition toutes les 3 secondes
    tirs = {}
    score = 0
end

function DrawCentre(image, x, y)
    love.graphics.draw(image, x, y, 0, 1, 1,image:getWidth() / 2, image:getHeight() / 2)
end

function Tire()
    local leTir = {
        x = vaisseau.x,
        y = vaisseau.y
    }
    table.insert(tirs, leTir)
    sonTir:stop()
    sonTir:play()
end

function Distance(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end


function sceneJeu.load()
	--fontJeu = love.graphics.newFont("PIXEARG_.TTF", 9)
	--love.graphics.setFont(fontJeu)
	love.graphics.setFont(scoreFont)
    initJeu()
	
end

function sceneJeu.update(dt)
	if sceneJeu.etat ~= "PAUSE" then
		if vaisseau.explose == true then
			scm.ChangeScene("GAMEOVER")
			return
		end
	
		scrolling = scrolling + 25 * dt 
		if scrolling >= imageFond:getHeight() then
			scrolling = 0
		end
	
		if love.keyboard.isDown("left") and vaisseau.x > 0 then
			vaisseau.x = vaisseau.x - (200 * dt)
		end
	
		if love.keyboard.isDown("right") and vaisseau.x < 800 then
			vaisseau.x = vaisseau.x + (200 * dt)
		end
	
		timerEnemie = timerEnemie + dt
		if timerEnemie > frequenceEnemie then
			-- Crée une table pour y stocker les infos du nouvel ennemis
			local nouvelEnnemi = {
				-- Commence à une position horizontale aléatoire
				x = love.math.random(0, 800),
				-- Commence verticalement en dehors de l'écran
				y = 0 - imageEnemie:getHeight()
			}
			-- Ajoute la table à notre liste
			table.insert(enemies, nouvelEnnemi)
			-- Redémarre le timer
			timerEnemie = 0
		end
	
		-- Mise à jour des ennemis
		for i = #enemies, 1, -1 do
			enemies[i].y = enemies[i].y + 100 * dt -- Déplacer l'ennemi vers le bas
			-- Si l'ennemi dépasse le bas de l'écran
			if enemies[i].y > 600 + imageEnemie:getHeight() / 2 then
				table.remove(enemies, i)
			else
				if Distance(vaisseau.x, vaisseau.y,enemies[i].x, enemies[i].y) < imageEnemie:getWidth() then
					vaisseau.explose = true
					sonExplosion:stop()
					sonExplosion:play()
				end
			end
		end
	
		if frequenceEnemie > 0.1 then
			frequenceEnemie = frequenceEnemie - (0.1 * dt)
		end
	
		for n = #tirs, 1, -1 do
			local leTir = tirs[n]
			leTir.y = leTir.y - (400 * dt)
			if leTir.y < 0 - imageTir:getHeight() / 2 then -- Sort de l'écran
				table.remove(tirs, n)
			else -- Sinon teste collisions avec chaque ennemi
				for nc = #enemies, 1, -1 do
					local lEnnemi = enemies[nc]
					local tailleEnnemi = imageEnemie:getWidth()
					if Distance(lEnnemi.x, lEnnemi.y, leTir.x, leTir.y) < tailleEnnemi / 2 then
						table.remove(enemies, nc)
						table.remove(tirs, n)
						score = score + 1
						sonExplosion:stop()
						sonExplosion:play()
						break -- sort de la boucle
					end
				end
			end
		end
	end
end

function sceneJeu.draw()
	love.graphics.draw(imageFond, 0, scrolling)
    love.graphics.draw(imageFond, 0, scrolling - imageFond:getHeight())
    if vaisseau.explose == true then
        DrawCentre(imageExplosion, vaisseau.x, vaisseau.y)
    else 
        DrawCentre(imageVaisseau, vaisseau.x, vaisseau.y)
    end
    for i = 1, #enemies do
        DrawCentre(imageEnemie, enemies[i].x, enemies[i].y)
    end
    for k, v in ipairs(tirs) do
        DrawCentre(imageTir, v.x, v.y)
    end
   
    love.graphics.print(score, 5, 5)
end


function sceneJeu.mousepressed(x,y,n)   
end

function sceneJeu.keypressed(key)	
	if key == "escape" then
        scm.ChangeScene("MENU")
    elseif key == "space" and #tirs < 3 then
        Tire()
    end
end

function sceneJeu.unload()
end

return sceneJeu