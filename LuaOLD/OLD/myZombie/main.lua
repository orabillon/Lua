-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Returns the distance between two points.
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

-- Returns the angle between two vectors assuming the same origin.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

-- Machine a etat
local ZSTATES = {}
ZSTATES.NONE = ""
ZSTATES.WALK = "walk"
ZSTATES.ATTACK = "attack"
ZSTATES.BITE = "bite"
ZSTATES.CHANGEDIR = "change"

local debug = false
local nbZombie = 10

imgAlert = love.graphics.newImage("images/alert.png")

function UpdateZombie(pZombie, pEntities)

	if pZombie.state == ZSTATES.NONE then

		pZombie.state = ZSTATES.CHANGEDIR

	elseif pZombie.state == ZSTATES.WALK then
		-- Collision avec les bords
		local bCollide = false

		if pZombie.y <= 0 then
			pZombie.y = 0
			bCollide = true
		end 
		if pZombie.y  >= screenHeight then
			pZombie.y = screenHeight
			bCollide = true
		end 
		if pZombie.x <= 0 then
			pZombie.x = 0
			bCollide = true
		end 
		if pZombie.x  >= screenWitdh then
			pZombie.x = screenWitdh
			bCollide = true
		end 

		if bCollide then
			pZombie.state = ZSTATES.CHANGEDIR
		end

		-- observation de l'environnement 
		for i,sprite in ipairs (pEntities) do 
			if sprite.type == "human" and sprite.visible == true then
				local distance = math.dist(pZombie.x, pZombie.y,sprite.x,sprite.y)
				if distance < pZombie.range then
					pZombie.state = ZSTATES.ATTACK
					pZombie.target = sprite
				end
			end
		end

	elseif pZombie.state == ZSTATES.ATTACK then
		
		if pZombie.target == nil then
			pZombie.state = ZSTATES.CHANGEDIR
		end

		-- verifie si la cible est toujours visible
		local distance = math.dist(pZombie.x, pZombie.y,pZombie.target.x,pZombie.target.y)
		if distance > pZombie.range and pZombie.target.type == "human" then
			pZombie.state = ZSTATES.CHANGEDIR
		elseif distance  < 5 and pZombie.target.type == "human" then
			-- toujours en contact
			pZombie.state = ZSTATES.BITE
			pZombie.vx = 0
			pZombie.vy = 0
		else
			-- suis la cible
			local destX = love.math.random(pZombie.target.x - 20, pZombie.target.x + 20)
			local destY = love.math.random(pZombie.target.y - 20, pZombie.target.y + 20)
			local angle = math.angle(pZombie.x, pZombie.y, destX,destY)
			pZombie.vx = pZombie.speed * 3 * 60 * math.cos(angle)
			pZombie.vy = pZombie.speed * 3 * 60 * math.sin(angle)
		end

	elseif pZombie.state == ZSTATES.BITE then

		-- Toujours en contact
		local distance = math.dist(pZombie.x, pZombie.y,pZombie.target.x,pZombie.target.y)
		if distance  < 5 and pZombie.target.type == "human" then
			if pZombie.target.Hurt ~= nil then
				pZombie.target.Hurt()
				if pZombie.target.visible == false then
					pZombie.state = ZSTATES.CHANGEDIR
				end
			end	
		else 
			pZombie.state = ZSTATES.ATTACK	
		end

	elseif pZombie.state == ZSTATES.CHANGEDIR then

		local angle = math.angle(pZombie.x, pZombie.y, love.math.random(0, screenWitdh),love.math.random(0,screenHeight))
		pZombie.vx = pZombie.speed * 60 * math.cos(angle)
		pZombie.vy = pZombie.speed * 60 * math.sin(angle)
		pZombie.state = ZSTATES.WALK
	end

end

local lstSprites = {}
local human = {}
local timer = 30
local vague = 1

function CreateZombie()
	local myZombie = CreateSprite(lstSprites,"zombie","monster_",2)
	myZombie.x = love.math.random(10,screenWitdh - 10)
	myZombie.y = love.math.random(10,(screenHeight/6)*3)
	myZombie.speed = love.math.random(5,50) / 200
	myZombie.state = ZSTATES.NONE
	myZombie.range = love.math.random(10,150)
	myZombie.target = nil

end

function CreateHuman()
	local myHuman = CreateSprite(lstSprites,"human","player_",4)
	myHuman.x = screenWitdh / 2
	myHuman.y = (screenHeight / 6) * 5
	myHuman.speed = 60
	myHuman.life = 100
	myHuman.Hurt = function()
		myHuman.life = myHuman.life - 0.1
		if myHuman.life < 0 then
			myHuman.life = 0
			myHuman.visible = false
		end
	end
	return myHuman
end

function CreateSprite(pListe,pType,pImage,pNombreFrame)
	local mySprite = {}
	mySprite.x = 0
	mySprite.y = 0
	mySprite.vx = 0
	mySprite.vy = 0
	mySprite.speed = 0
	mySprite.type = pType
	mySprite.visible = true
	mySprite.currentFrame = 1
	mySprite.frames = {}

	local i
	for i=1, pNombreFrame do 
		local file = "images/"..pImage..tostring(i)..".png"
		mySprite.frames[i] = love.graphics.newImage(file)
	end

	mySprite.width = mySprite.frames[1]:getWidth()
	mySprite.height = mySprite.frames[1]:getHeight()

	table.insert(pListe, mySprite)
	return mySprite
end

function love.load()

	-- /2 car on fait un scale 2
	screenWitdh = love.graphics.getWidth() / 2
	screenHeight = love.graphics.getHeight() / 2

	human = CreateHuman()

	local nZombie
	for nZombie = 1, nbZombie do 
		CreateZombie()
	end

end

function love.update(dt)

	-- deplacement du personnage
	if love.keyboard.isDown("up") and human.y >= 0 then
		human.y = human.y - human.speed * dt
	end
	if love.keyboard.isDown("left") and human.x >= 0 then
		human.x = human.x - human.speed * dt
	end
	if love.keyboard.isDown("down") and human.y <= screenHeight then
		human.y = human.y + human.speed * dt
	end
	if love.keyboard.isDown("right") and human.x <= screenWitdh then
		human.x = human.x + human.speed * dt
	end

	for i,sprite in ipairs(lstSprites) do
		-- animation des sprites
		sprite.currentFrame = sprite.currentFrame + 0.05
		if sprite.currentFrame >= #sprite.frames + 1 then
			sprite.currentFrame = 1
		end
		-- velocity
		sprite.x = sprite.x + sprite.vx * dt
		sprite.y = sprite.y + sprite.vy * dt

		-- mise a jour zombie
		if sprite.type == "zombie" then
			UpdateZombie(sprite, lstSprites)
		end
	end

	timer = timer - dt

end

function love.draw()

	love.graphics.print(" life :  "..tostring(math.floor(human.life)).."  -  Vague n°  : "..tostring(vague).."   -   Zombie : "..tostring(nbZombie).."   -  Temps restant(sec) : "..tostring(math.floor(timer)), 1, 1)

	love.graphics.push()
    
  	love.graphics.scale(2,2)
	
	-- affichage de tous les sprites
	for i,sprite in ipairs(lstSprites) do
		if sprite.visible then
			love.graphics.draw(sprite.frames[math.floor(sprite.currentFrame)],sprite.x - sprite.width / 2 ,sprite.y - sprite.height / 2)
		
			if debug then
				if sprite.type == "zombie" then
					love.graphics.print(sprite.state, sprite.x - 10, sprite.y - sprite.height - 10)	
				end
			else
				if sprite.type == "zombie" then
					if sprite.state == ZSTATES.ATTACK then
						love.graphics.draw(imgAlert, sprite.x - imgAlert:getWidth() / 2, sprite.y - sprite.height - 2)
					end
				end
			end
		end	
	end


	love.graphics.pop()
	
end

function love.keypressed(key)
	if key == "d" then
		if debug then
			debug = false
		else
			debug = true
		end
	end
end
