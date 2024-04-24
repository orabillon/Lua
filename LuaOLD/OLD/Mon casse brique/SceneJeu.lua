local sceneJeu = {}

local scm = require("SceneManager")

sceneJeu.nbColonne = 11
sceneJeu.nbLigne = 20
sceneJeu.degre45 = math.rad(45) 
sceneJeu.BriqueWidth = 48
sceneJeu.BriqueHeight = 16
sceneJeu.nbVie = 3
sceneJeu.nbVieMax = 8
sceneJeu.nbScore = 0
sceneJeu.TAILLE_POLICE = 8
sceneJeu.etat = "ENCOUR"
sceneJeu.nbBriqueNiveau = 0
sceneJeu.nivCourrent = 1
sceneJeu.changeSc = 0

sceneJeu.pad = {}
sceneJeu.pad.x = 0
sceneJeu.pad.y = 0
sceneJeu.pad.width = 80
sceneJeu.pad.widthSav = 80
sceneJeu.pad.height = 16
sceneJeu.pad.bonusPetit = {actif = false, tempo = 0}
sceneJeu.pad.bonusGrand = {actif = false, tempo = 0}
sceneJeu.pad.tirs = false

sceneJeu.niveau = {}

sceneJeu.lstBrique = {}
sceneJeu.lstParticule = {}
sceneJeu.lstBonus = {}
sceneJeu.lstTirs = {}
sceneJeu.lstBalle = {}

local fontJeu

function sceneJeu.load()
	fontJeu = love.graphics.newFont("PIXEARG_.TTF", 9)
	love.graphics.setFont(fontJeu)
	sceneJeu.DemarrePartie()
end

function sceneJeu.update(dt)
	if sceneJeu.etat ~= "PAUSE" then
		sceneJeu.pad.x = love.mouse.getX()
		if sceneJeu.nbBriqueNiveau <= 0 then
			sceneJeu.nivCourrent = sceneJeu.nivCourrent + 1 
			sceneJeu.ChargerNiveau()
			sceneJeu.changeSc = 1
		end

		-- parcour liste balle
		for bl=#sceneJeu.lstBalle,1,-1  do
			local ball = sceneJeu.lstBalle[bl]
			if ball.colle == true then
				ball.x = sceneJeu.pad.x
				ball.y = sceneJeu.pad.y -(sceneJeu.pad.height / 2) - ball.rayon
			else 
	
				-- futur position de la balle 
				local dx = ball.vx * dt
				local dy = ball.vy * dt
	
				-- collision brique 
				for i=#sceneJeu.lstBrique, 1, -1 do
					local brique = sceneJeu.lstBrique[i]
					local bColision = false
	
					if CheckCollision(brique.x,brique.y,brique.width,brique.height, (ball.x - 5) + dx,ball.y - 5,10,10) then
						bColision = true
						if ball.bonusFeu.actif == false then
							ball.vx = ball.vx * -1
						end
					end
	
					if CheckCollision(brique.x,brique.y,brique.width,brique.height, ball.x - 5,(ball.y - 5) + dy,10,10) then
						bColision = true
						if ball.bonusFeu.actif == false then
							ball.vy = ball.vy * -1
						end
					end
	
					if bColision then
							if brique.type ~= 1 then
								brique.nbCoups = brique.nbCoups - 1
								-- brique detruite
								if brique.nbCoups <= 0  then
									sceneJeu.nbBriqueNiveau = sceneJeu.nbBriqueNiveau - 1
				
									sceneJeu.nbScore = sceneJeu.nbScore + brique.type * 6
			
									sceneJeu.genereBonus(brique.x + brique.width / 2, brique.y + brique.height / 2)
			
									if sndBrique:isPlaying() then
										sndBrique:stop()
									end
									love.audio.play(sndBrique)
									for n=1, 30 do
										sceneJeu.AjouteParticule(math.random(brique.x, brique.x + brique.width), math.random(brique.y, brique.y + brique.height), "BULLE",
										math.random(-100,100), math.random(0, 200), math.random()*3, math.random(1,6), true, -500)
									end
									table.remove(sceneJeu.lstBrique, i)
									
								else
									love.audio.play(sndBriqueDure)
								end
		
							else
								love.audio.play(sndBriqueDure)
								sceneJeu.nbScore = sceneJeu.nbScore + 1
							end
					end
				end
				
				ball.x = ball.x + ball.vx * dt
				ball.y = ball.y + ball.vy * dt
	
				-- ajout particule
				for n=1, 3 do
					sceneJeu.AjouteParticule(ball.x + math.random(-5,5), ball.y + math.random(-5,5), "POINT", 0, 0, math.random(1,20)/30,1, true, 0, {r=math.random(), g=math.random(), b=math.random()})
				end
	
					-- collision bord
				if ball.x - ball.rayon < 0 then
					ball.x = ball.x + ball.rayon
					ball.vx = ball.vx * -1
					love.audio.play(sndCollision)
				end
				if ball.x + ball.rayon > screenWidth then
					ball.x = screenWidth - ball.rayon
					ball.vx = ball.vx * -1
					love.audio.play(sndCollision)
				end
				if ball.y - ball.rayon < 0 then
					ball.y = ball.y + ball.rayon
					ball.vy = ball.vy * -1
					love.audio.play(sndCollision)
				end
				if ball.y + ball.rayon > screenHeight then
					table.remove(sceneJeu.lstBalle,bl)
					if #sceneJeu.lstBalle == 0 then
						sceneJeu.nbVie = sceneJeu.nbVie - 1
						if sceneJeu.nbVie <= 0 then
							scm.ChangeScene("GAMEOVER")
							sceneJeu.changeSc = 1
						end
						love.audio.play(sndPerdu)
		
						-- anulation des bonus
						sceneJeu.pad.bonusGrand.actif = false
						sceneJeu.pad.bonusGrand.tempo = 0
						sceneJeu.pad.bonusPetit.actif = false
						sceneJeu.pad.bonusPetit.tempo = 0
						sceneJeu.pad.width = sceneJeu.pad.widthSav
						sceneJeu.pad.tirs = false
						sceneJeu.lstTirs = {}
						sceneJeu.lstBalle = {}

						sceneJeu.AjouteBalle(0,0,0,0,0 - sceneJeu.degre45, 300, true)
					end
				end
	
				-- collision pad 
				local posCollisionPad = sceneJeu.pad.y - (sceneJeu.pad.height / 2) - ball.rayon
				if ball.y > posCollisionPad then
					local distance = ball.x - sceneJeu.pad.x 
					if math.abs(distance) < (sceneJeu.pad.width / 2) then
						ball.vy = ball.vy * -1
						ball.y = posCollisionPad
						love.audio.play(sndRaquette)
						if distance < 0 then
							-- Balle vers la gauche
							ball.vx = -(ball.vitesse * math.cos(ball.angle)) 
						else
							-- balle vers la droite
							ball.vx = ball.vitesse * math.cos(ball.angle)  
						end
						local coef = (sceneJeu.pad.width / 2) / math.abs(distance)
						ball.vx = ball.vx * 2/coef
					end 
				end
			end
		end

		-- particule
		for n=#sceneJeu.lstParticule, 1, -1 do
			local p = sceneJeu.lstParticule[n]
			p.vie = p.vie - dt
			if p.vie <= 0 then
				table.remove(sceneJeu.lstParticule,n)
			else
				if p.gravite ~= 0 then
					p.vy = p.vy + p.gravite * dt
				end
				p.x = p.x + p.vx * dt
				p.y = p.y + p.vy * dt
			end
		end

		-- tirs
		for n=#sceneJeu.lstTirs, 1, -1 do
			local p = sceneJeu.lstTirs[n]
			p.y = p.y - 150 * dt
			if p.y < 0 then
				table.remove(sceneJeu.lstTirs, n)
			else
				for b = #sceneJeu.lstBrique, 1, -1 do
					local brique = sceneJeu.lstBrique[b]
					if CheckCollision(p.x ,p.y,imgTirs:getWidth() - 2,imgTirs:getHeight() - 2 , brique.x,brique.y,brique.width,brique.height) then
						if brique.type ~= 1 then
							brique.nbCoups = brique.nbCoups - 1
							if brique.nbCoups <= 0 then
								sceneJeu.nbBriqueNiveau = sceneJeu.nbBriqueNiveau - 1
								
								sceneJeu.genereBonus(brique.x + brique.width / 2, brique.y)
								table.remove(sceneJeu.lstBrique, b)
								if sndBrique:isPlaying() then
									sndBrique:stop()
								end
								love.audio.play(sndBrique)
								
							else
								love.audio.play(sndBriqueDure)
							end
						else
							if sndBriqueDure:isPlaying() then
								sndBriqueDure:stop()
							end
							love.audio.play(sndBriqueDure)
						end
						sceneJeu.nbScore = sceneJeu.nbScore + 1
						table.remove(sceneJeu.lstTirs, n)
					end 
				end
			end
		end


		-- bonus
		for b=#sceneJeu.lstBonus, 1, -1 do 
			local bonus = sceneJeu.lstBonus[b]
			
			bonus.y = bonus.y + bonus.speed * dt
			 
			if CheckCollision(sceneJeu.pad.x - sceneJeu.pad.width / 2 ,sceneJeu.pad.y - sceneJeu.pad.height / 2,sceneJeu.pad.width,sceneJeu.pad.height, bonus.x,bonus.y,10,10) then
				if bonus.type == "VIE" then
					if sceneJeu.nbVie < sceneJeu.nbVieMax then
						sceneJeu.nbVie = sceneJeu.nbVie + 1
					end
				elseif bonus.type == "VIP" then
					sceneJeu.nbVie = sceneJeu.nbVie - 1
					if sceneJeu.nbVie <= 0 then
						scm.ChangeScene("GAMEOVER")
						sceneJeu.changeSc = 1
						love.audio.play(sndPerdu)
					end
				elseif bonus.type == "FEU" then
					for ll=1, #sceneJeu.lstBalle do
						balls = sceneJeu.lstBalle[ll]
						if balls.bonusFeu.actif == false then
							balls.bonusFeu.actif = true
							balls.bonusFeu.tempo = bonus.tempo
						else
							balls.bonusFeu.tempo = balls.bonusFeu.tempo + bonus.tempo
						end
					end
				elseif bonus.type == "RGT" then
					if sceneJeu.pad.bonusPetit.actif == true then
						sceneJeu.pad.bonusPetit.actif = false
						sceneJeu.pad.bonusPetit.tempo = 0
						sceneJeu.pad.width = sceneJeu.pad.widthSav
					else
						if sceneJeu.pad.bonusGrand.actif == false then
							sceneJeu.pad.bonusGrand.actif = true
							sceneJeu.pad.bonusGrand.tempo = bonus.tempo
							sceneJeu.pad.width = sceneJeu.pad.width * 2
						else
							sceneJeu.pad.bonusGrand.tempo = sceneJeu.pad.bonusGrand.tempo + bonus.tempo
						end
					end
				elseif bonus.type == "RPT" then
					if sceneJeu.pad.bonusGrand.actif == true then 
						sceneJeu.pad.bonusGrand.actif = false
						sceneJeu.pad.bonusGrand.tempo = 0
						sceneJeu.pad.width = sceneJeu.pad.widthSav
					else
						if sceneJeu.pad.bonusPetit.actif == false then
							sceneJeu.pad.bonusPetit.actif = true
							sceneJeu.pad.bonusPetit.tempo = bonus.tempo
							sceneJeu.pad.width = sceneJeu.pad.width / 2
						else
							sceneJeu.pad.bonusPetit.tempo = sceneJeu.pad.bonusPetit.tempo + bonus.tempo
						end
					end
				elseif bonus.type == "TIR" then
					sceneJeu.pad.tirs = true
				elseif bonus.type == "MBL" then
					for mbl=1,love.math.random(2,4) do
						sceneJeu.AjouteBalle(sceneJeu.lstBalle[1].x,sceneJeu.lstBalle[1].y,sceneJeu.lstBalle[1].vx + love.math.random(-5,5),sceneJeu.lstBalle[1].vy + love.math.random(-5,5),0 - sceneJeu.degre45, 300, false)
					end
				elseif bonus.type == "RPD" then
					for ll=1, #sceneJeu.lstBalle do
						balls = sceneJeu.lstBalle[ll]
						balls.vx = balls.vx * 2
						balls.vy = balls.vy * 2
					end
				elseif bonus.type == "LNT" then
					for ll=1, #sceneJeu.lstBalle do
						balls = sceneJeu.lstBalle[ll]
						balls.vx = balls.vx / 2
						balls.vy = balls.vy / 2
					end
				end
				if bonus.type ~= "TIR" then
					if sceneJeu.pad.tirs == true then
						sceneJeu.pad.tirs = false
					end
				end
				table.remove(sceneJeu.lstBonus, b)
			else
				if bonus.y > screenHeight then
					table.remove(sceneJeu.lstBonus, b)
				end
			end
		end
		-- Gestion des bonnus actif
		-- Balle feu
		for bl=1, #sceneJeu.lstBalle do
			ball = sceneJeu.lstBalle[bl]
			if ball.bonusFeu.actif == true then
				ball.bonusFeu.tempo = ball.bonusFeu.tempo - dt
				if ball.bonusFeu.tempo <= 0 then
					ball.bonusFeu.actif = false
					ball.bonusFeu.tempo = 0
				end
			end
		end
		if sceneJeu.pad.bonusPetit.actif == true then
			sceneJeu.pad.bonusPetit.tempo = sceneJeu.pad.bonusPetit.tempo - dt
			if sceneJeu.pad.bonusPetit.tempo <= 0 then
				sceneJeu.pad.bonusPetit.actif = false
				sceneJeu.pad.bonusPetit.tempo = 0
				sceneJeu.pad.width = sceneJeu.pad.widthSav
			end
		end
		if sceneJeu.pad.bonusGrand.actif == true then
			sceneJeu.pad.bonusGrand.tempo = sceneJeu.pad.bonusGrand.tempo - dt
			if sceneJeu.pad.bonusGrand.tempo <= 0 then
				sceneJeu.pad.bonusGrand.actif = false
				sceneJeu.pad.bonusGrand.tempo = 0
				sceneJeu.pad.width = sceneJeu.pad.widthSav
			end
		end
	end
end

function sceneJeu.draw()
	-- niveau
	for n=1, #sceneJeu.lstBrique do
		local brique = sceneJeu.lstBrique[n]
		love.graphics.draw(brique.texture, brique.x, brique.y)
	end

	-- vie
	for n=1, sceneJeu.nbVie do
		love.graphics.draw(imgVie, (n-1) * imgVie:getWidth(), screenHeight - imgVie:getHeight() )
	end 

	-- Score 
	love.graphics.print("Score : "..sceneJeu.nbScore, screenWidth - string.len("Score : "..sceneJeu.nbScore) * sceneJeu.TAILLE_POLICE ,screenHeight - 20)
	

	-- particule
	for n=1, #sceneJeu.lstParticule do
		local particule = sceneJeu.lstParticule[n]
		if particule.fade then
			love.graphics.setColor(1,1,1,particule.vie / particule.vieTotal)
		end
		if particule.color ~= nil then
			love.graphics.setColor(particule.color.r,particule.color.g,particule.color.b)
		end
		if particule.type == "POINT" then
			love.graphics.circle("fill", particule.x, particule.y, particule.taille)
		elseif particule.type == "BULLE" then
			love.graphics.circle("line", particule.x, particule.y, particule.taille)
		end
		love.graphics.setColor(1,1,1,1)
	end

	-- bonus
	for n=1, #sceneJeu.lstBonus do
		local bonus = sceneJeu.lstBonus[n]
		if bonus.type == "VIE" then
			love.graphics.draw(imgVie, bonus.x, bonus.y)
		elseif bonus.type == "FEU" then
			love.graphics.draw(imgFeu,bonus.x, bonus.y)
		elseif bonus.type == "RPT" then
			love.graphics.draw(imgPadPetit,bonus.x, bonus.y)
		elseif bonus.type == "RGT" then
			love.graphics.draw(imgPadGrand,bonus.x, bonus.y)
		elseif bonus.type == "TIR" then
			love.graphics.draw(imgTirs,bonus.x, bonus.y)
		elseif bonus.type == "MBL" then
			love.graphics.draw(imgMBL,bonus.x, bonus.y)
		elseif bonus.type == "RPD" then
			love.graphics.draw(imgRpd,bonus.x, bonus.y)
		elseif bonus.type == "LNT" then
			love.graphics.draw(imgLnt,bonus.x, bonus.y)
		elseif bonus.type == "VIP" then
			love.graphics.draw(imgVieP,bonus.x, bonus.y)
		end
	end 

	if sceneJeu.pad.bonusGrand.actif == true then
		if sceneJeu.pad.tirs == true then
			love.graphics.draw(imgRaquetteGrandTirs,  sceneJeu.pad.x - (sceneJeu.pad.width / 2), sceneJeu.pad.y - (sceneJeu.pad.height / 2))
		else
			love.graphics.draw(imgRaquetteGrand,  sceneJeu.pad.x - (sceneJeu.pad.width / 2), sceneJeu.pad.y - (sceneJeu.pad.height / 2))
		end
	elseif sceneJeu.pad.bonusPetit.actif == true then
		if sceneJeu.pad.tirs == true then
			love.graphics.draw(imgRaquettePetitTirs,  sceneJeu.pad.x - (sceneJeu.pad.width / 2), sceneJeu.pad.y - (sceneJeu.pad.height / 2))
		else
			love.graphics.draw(imgRaquettePetit,  sceneJeu.pad.x - (sceneJeu.pad.width / 2), sceneJeu.pad.y - (sceneJeu.pad.height / 2))
		end
	else
		if sceneJeu.pad.tirs == true then
			love.graphics.draw(imgRaquetteTirs,  sceneJeu.pad.x - (sceneJeu.pad.width / 2), sceneJeu.pad.y - (sceneJeu.pad.height / 2))
		else
			love.graphics.draw(imgRaquette,  sceneJeu.pad.x - (sceneJeu.pad.width / 2), sceneJeu.pad.y - (sceneJeu.pad.height / 2))
		end
	end

	-- tirs
	for n=1, #sceneJeu.lstTirs do
		local tirs = sceneJeu.lstTirs[n]
		love.graphics.draw(imgPtirs, tirs.x, tirs.y)	
	end
	
	for lb=1,#sceneJeu.lstBalle do
		ball = sceneJeu.lstBalle[lb]
		if ball.bonusFeu.actif == true then
			love.graphics.setColor(1,0.5,0,1)
		end	
		love.graphics.draw(imgBalle, ball.x - ball.rayon, ball.y - ball.rayon)
		love.graphics.setColor(1,1,1,1)
	end
	
end

function sceneJeu.DemarrePartie()
	-- cache la souris
	love.mouse.setVisible(false)
	-- capture la souris qui ne peut jamais sortir de la zone de la fenetre
	love.mouse.setGrabbed(true)

	
	sceneJeu.lstBalle = {}
	sceneJeu.lstParticule = {}
	sceneJeu.lstBonus = {}
	sceneJeu.lstBrique = {}
	sceneJeu.lstTirs = {}

	sceneJeu.pad.y = (screenHeight - sceneJeu.pad.height / 2) - 20
	sceneJeu.pad.width = sceneJeu.pad.widthSav
	sceneJeu.nbVie = 3
	sceneJeu.nbScore = 0
	sceneJeu.nivCourrent = 1
	sceneJeu.changeSc = 0
	sceneJeu.ChargerNiveau()

end

function sceneJeu.ChargerNiveau()
	-- initialisation niveau
	sceneJeu.pad.bonusPetit = {actif = false, tempo = 0}
	sceneJeu.pad.bonusGrand = {actif = false, tempo = 0}
	sceneJeu.pad.tirs = false

	sceneJeu.niveau = {}
	sceneJeu.lstBrique = {}
	sceneJeu.lstTirs = {}
	sceneJeu.lstBalle = {}
	sceneJeu.lstParticule = {}
	sceneJeu.lstBonus = {}
	
	sceneJeu.LireNiveau()

	sceneJeu.AjouteBalle(0,0,0,0,0 - sceneJeu.degre45, 300, true)

	if sceneJeu.changeSc == 0 then
		-- Creation des brique
		for l=1, sceneJeu.nbLigne do 
			for c=1, sceneJeu.nbColonne do 
				if sceneJeu.niveau[l][c] ~= 0 then
					local type = sceneJeu.niveau[l][c]
					--[[local nbCoup = math.floor(type/4)
					if nbCoup < 1 then
						nbCoup = 1
					end]]
					sceneJeu.AjouteBrique((c-1) * sceneJeu.BriqueWidth,(l-1) * sceneJeu.BriqueHeight, sceneJeu.BriqueWidth, sceneJeu.BriqueHeight,lstImgBrique[type],type, 1)
				end
			end
		end

		love.audio.play(sndStart)
	else
		sceneJeu.changeSc = 0
	end
end

function sceneJeu.LireNiveau()
	sceneJeu.niveau = {}

	local chemin = "levels/level_"..sceneJeu.nivCourrent..".bbx"
	-- verification que le fichier existe
	local info = love.filesystem.getInfo(chemin)
	if info ~= nil then
		-- lecture ligne
		local l = 1
		for line in love.filesystem.lines(chemin) do
			sceneJeu.niveau[l] = {}
			for c=1, sceneJeu.nbColonne do
				sceneJeu.niveau[l][c] = tonumber(string.sub(line,c,c))
				c=c+1
			end
			l = l + 1
		end
	else
		scm.ChangeScene("GAMEOVER")
		sceneJeu.changeSc = 1
		love.audio.play(sndVictoire)
	end

end

function sceneJeu.AjouteBrique(pX, pY, pWidht, pHeight, pTexture, pType, pNbCoup)
	local maBrique = {}
	maBrique.x = pX
	maBrique.y = pY
	maBrique.width = pWidht
	maBrique.height = pHeight
	maBrique.texture = pTexture
	maBrique.type = pType
	maBrique.nbCoups = pNbCoup
	table.insert(sceneJeu.lstBrique, maBrique)

	if maBrique.type > 1 then
		sceneJeu.nbBriqueNiveau = sceneJeu.nbBriqueNiveau + 1
	end
end

function sceneJeu.AjouteParticule(pX, pY, pType, pVx, pVy, pVie, pTaille, pFade, pGravite, pColor) 
	local maParticule = {}
	maParticule.x = pX
	maParticule.y = pY
	maParticule.type = pType
	maParticule.vx = pVx
	maParticule.vy = pVy
	maParticule.vie = pVie
	maParticule.vieTotal = pVie
	maParticule.taille = pTaille
	maParticule.fade = pFade
	maParticule.color = pColor
	maParticule.gravite = pGravite
	table.insert(sceneJeu.lstParticule, maParticule)
end

function sceneJeu.AjouteBonus (pX, pY, pType, pSpeed, pTempo)
	local monBonus = {}
	monBonus.x = pX
	monBonus.y = pY
	monBonus.type = pType
	monBonus.speed = pSpeed
	monBonus.tempo = pTempo
	table.insert(sceneJeu.lstBonus, monBonus)
end

function sceneJeu.AjouteTirs(pX, pY)
	local tir = {}
	tir.x = pX
	tir.y = pY
	table.insert(sceneJeu.lstTirs, tir)
end

function sceneJeu.mousepressed(x,y,n)
    for lb=1, #sceneJeu.lstBalle do
		ball = sceneJeu.lstBalle[lb]
		if ball.colle == true then 
			ball.colle = false
			ball.vx = ball.vitesse * math.cos(ball.angle)
			ball.vy = ball.vitesse * math.sin(ball.angle)
		end
	end
end

function sceneJeu.keypressed(key)
	if key == "b" then
		love.mouse.setGrabbed(false)
		love.mouse.setVisible(true)
	end
	if key == "space" then
		if sceneJeu.pad.tirs == true then
			if sceneJeu.pad.bonusPetit.actif == false then
				sceneJeu.AjouteTirs(sceneJeu.pad.x - sceneJeu.pad.width / 2 + 8 , sceneJeu.pad.y - sceneJeu.pad.height / 2)
				sceneJeu.AjouteTirs(sceneJeu.pad.x + sceneJeu.pad.width / 2 - 13 , sceneJeu.pad.y - sceneJeu.pad.height / 2)
			else
				sceneJeu.AjouteTirs(sceneJeu.pad.x - 2, sceneJeu.pad.y - sceneJeu.pad.height / 2)
			end
			love.audio.play(sndTirs)
		end
	end
	if key == "escape" then
		scm.ChangeScene("MENU")
		love.mouse.setGrabbed(false)
		love.mouse.setVisible(true)
	end
	if key == "p" then
		if sceneJeu.etat == "ENCOUR" then
			sceneJeu.etat = "PAUSE"
			love.window.setTitle("Super Casse Brique ( PAUSE )")
		else 
			sceneJeu.etat = "ENCOUR"
			love.window.setTitle("Super Casse Brique")
		end
	end
end

function sceneJeu.genereBonus(pX, pY)
	-- proba bonus
	bfeu = false
	for bl=1, #sceneJeu.lstBalle do
		ball = sceneJeu.lstBalle[bl]
		bfeu = ball.bonusFeu.actif
	end
	if bfeu == false then
		-- sceneJeu.AjouteBonus(pX, pY, "TIR", 140,0)
		local proba = love.math.random(1,10)
		if proba >= 8 then
			local bonus = love.math.random(1,9)
			if bonus == 8  then
				sceneJeu.AjouteBonus(pX, pY, "VIE", 140,0)
			elseif bonus == 4 then
				sceneJeu.AjouteBonus(pX, pY, "FEU", 140,4)
			elseif bonus == 2 then
				sceneJeu.AjouteBonus(pX, pY, "RGT", 140,20)
			elseif bonus == 1 then
				sceneJeu.AjouteBonus(pX, pY, "RPT", 140,20)
			elseif bonus == 3 then
				sceneJeu.AjouteBonus(pX, pY, "TIR", 140,0)
			elseif bonus == 6 then
				sceneJeu.AjouteBonus(pX, pY, "MBL", 140,0)
			elseif bonus == 7 then
				sceneJeu.AjouteBonus(pX, pY, "LNT", 140,0)
			elseif bonus == 5 then
				sceneJeu.AjouteBonus(pX, pY, "RPD", 140,0)
			elseif bonus == 9 then
				sceneJeu.AjouteBonus(pX, pY, "VIP", 140,0)
			end
		end
	end
end

function sceneJeu.AjouteBalle(pX,pY,pVx,pVy,pAngle, pVitesse, pColle)
	local balle = {}
	balle.x = pX
	balle.y = pY
	balle.rayon = 8
	balle.colle = pColle
	balle.angle = pAngle
	balle.vitesse = pVitesse
	balle.vx = pVx
	balle.vy = pVy
	balle.bonusFeu = {actif = false, tempo = 0}
	table.insert(sceneJeu.lstBalle, balle)
end

function sceneJeu.unload()
end

return sceneJeu