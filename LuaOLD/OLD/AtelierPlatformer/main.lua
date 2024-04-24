-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

lstImage = {}
lstSprites = {}

map = {}
player = {}
level = {}

function love.load()

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	lstImage["1"] = love.graphics.newImage("images/tile1.png")

	love.window.setTitle("Mini platformer (c) Gamecodeur 2022")
	initGame(1)

end

function love.update(dt)
	for nSprite=#lstSprites,1,-1 do
		local sprite = lstSprites[nSprite]
		updateSprite(sprite, dt)
	end
end

function love.draw()
	for l=1,#map do
		for c=1,#map[1] do
			local char = string.sub(map[l],c,c)
			if lstImage[char] ~= nil then
				if lstImage[char] ~= 0 then
					love.graphics.draw(lstImage[char],(c-1)*32,(l-1)*32)
				end
			end
		end
	end

	for nSprite=#lstSprites,1,-1 do
		local sprite = lstSprites[nSprite]
		drawSprite(sprite)
	end
end

function love.keypressed(key)
end

function ChargeNiveau(pNiveau)
	map = {}
	if pNiveau == 1 then
		map[1] = "1111111111111111111111111"
		map[2] = "1000000000000000000000001"
		map[3] = "1000111111111111111100001"
		map[4] = "1000000000000000000010011"
		map[5] = "1000000000000000000000001"
		map[6] = "1000000000000000000000111"
		map[7] = "1000000000000000000000001"
		map[8] = "1000000000000000011111111"
		map[9] = "1000000000000100000000001"
		map[10] = "1000000000000001000000001"
		map[11] = "1000000000111100000000001"
		map[12] = "1000000000000000000000001"
		map[13] = "1111111000000000000000001"
		map[14] = "1000000000000000000000001"
		map[15] = "1100000000111100000000001"
		map[16] = "1000000001000010000000001"
		map[17] = "1000000010000001000000001"
		map[18] = "1111111111111111111111111"
		
		level = {}
		level.playerStart = {}
		level.playerStart.col = 2
		level.playerStart.lig = 14

	elseif pNiveau == 2 then
		map[1] = "1111111111111111111111111"
		map[2] = "1000000000000000000000001"
		map[3] = "1000111111111111111100001"
		map[4] = "1000000000000000000010011"
		map[5] = "1000000000000000000000001"
		map[6] = "1000000000000000000000111"
		map[7] = "1000000000000000000000001"
		map[8] = "1000000000000000011111111"
		map[9] = "1000000000000100000000001"
		map[10] = "1000000000000001000000001"
		map[11] = "1000000000111100000000001"
		map[12] = "1000000000000000000000001"
		map[13] = "1111111000000000000000001"
		map[14] = "1000000000000000000000001"
		map[15] = "1100000000011000000000001"
		map[16] = "1000000001000010000000001"
		map[17] = "1000000010000001000000001"
		map[18] = "1111111111111111111111111"

		level = {}
		level.playerStart = {}
		level.playerStart.col = 2
		level.playerStart.lig = 14
	end
end

function initGame(pNiveau)
	ChargeNiveau(pNiveau)
	bJumpReady = true
	player = CreateSprite("player", (level.playerStart.col-1) * 32, (level.playerStart.lig-1) * 32)
end

-- connaitre tuile a une position 
function getTileAt(pX, pY) 
	local col = math.floor( pX / 32) + 1
	local lig = math.floor( pY / 32) + 1 
	if col > 0 and col <= #map[1] and lig > 0 and lig <= #map then
		local id = string.sub(map[lig] ,col ,col)
		return id
	end
	return 0
end

function CreateSprite(pType, pX, pY)
	local mySprite = {}
	mySprite.type = pType
	mySprite.x = pX
	mySprite.y = pY
	mySprite.vx = 0
	mySprite.vy = 0
	mySprite.currentFrame = 0
	mySprite.standing = false
	table.insert(lstSprites,mySprite)
	return mySprite
end

function updatePlayer(pPlayer,dt)
	-- variable physics
	local accel = 500
	local friction = 150
	local maxSpeed = 150
	local jumpVelocity = - 280

	-- friction
	if pPlayer.vx > 0 then
		pPlayer.vx = pPlayer.vx - friction * dt
		if pPlayer.vx < 0 then 
			pPlayer.vx = 0 
		end
	end
	if pPlayer.vx < 0 then
		pPlayer.vx = pPlayer.vx + friction * dt
		if pPlayer.vx > 0 then 
			pPlayer.vx = 0 
		end
	end

	-- keyboard
	if love.keyboard.isDown("right") then
		pPlayer.vx = pPlayer.vx + accel*dt
		if pPlayer.vx > maxSpeed then 
			pPlayer.vx = maxSpeed 
		end
	end

	if love.keyboard.isDown("left") then
		pPlayer.vx = pPlayer.vx - accel*dt
		if pPlayer.vx < -maxSpeed then 
			pPlayer.vx = -maxSpeed 
		end
	end

	if love.keyboard.isDown("up") and pPlayer.standing and bJumpReady then
		pPlayer.vy = jumpVelocity
		pPlayer.standing = false
		bJumpReady = false
	end
	if love.keyboard.isDown("up") == false and bJumpReady == false then
		bJumpReady = true
	end

	-- Move
	pPlayer.x = pPlayer.x + pPlayer.vx * dt
	pPlayer.y = pPlayer.y + pPlayer.vy * dt
		
end

function updateSprite(pSprite, dt)
	-- Locals for Collisions
	local oldX = pSprite.x
	local oldY = pSprite.y

	-- Specific behavior for the player
	if pSprite.type == "player" then
		updatePlayer(pSprite, dt)
	end

	-- Collision detection
	local collide = false
	-- On the right
	if pSprite.vx > 0 then
		collide = CollideRight(pSprite)
	end
	-- On the left
	if pSprite.vx < 0 then
		collide = CollideLeft(pSprite)
	end
	-- Stop!
	if collide then
		pSprite.vx = 0
		local col = math.floor((pSprite.x + 16) / 32) + 1
		pSprite.x = (col-1)*32
	end
	collide = false
	
	-- Above
	if pSprite.vy < 0 then
		collide = CollideAbove(pSprite)
		if collide then
			pSprite.vy = 0
			local lig = math.floor((pSprite.y + 16) / 32) + 1
			pSprite.y = (lig-1)*32
		end		
	end
	collide = false
	
	-- Below
	if pSprite.standing or pSprite.vy > 0 then
		collide = CollideBelow(pSprite)
		if collide then
			pSprite.standing = true
			pSprite.vy = 0
			local lig = math.floor((pSprite.y + 16) / 32) + 1
			pSprite.y = (lig-1)*32
		else
			pSprite.standing = false
		end
	end

	-- Sprite falling
	if pSprite.standing == false then
		pSprite.vy = pSprite.vy + 500 * dt
	end
end

function isSolid(pID)
	if pID == "0" then return false end
	if pID == "1" then return true end
end

function CollideRight(pSprite)
	local id1 = getTileAt(pSprite.x + 32, pSprite.y + 3)
	local id2 = getTileAt(pSprite.x + 32, pSprite.y + 30)
	return isSolid(id1) or isSolid(id2)
end

function CollideLeft(pSprite)
	local id1 = getTileAt(pSprite.x-1, pSprite.y + 3)
	local id2 = getTileAt(pSprite.x-1, pSprite.y + 30)
	return isSolid(id1) or isSolid(id2)
end

function CollideBelow(pSprite)
	local id1 = getTileAt(pSprite.x + 1, pSprite.y + 32)
	local id2 = getTileAt(pSprite.x + 30, pSprite.y + 32)
	return isSolid(id1) or isSolid(id2)
end

function CollideAbove(pSprite)
	local id1 = getTileAt(pSprite.x + 1, pSprite.y-1)
	local id2 = getTileAt(pSprite.x + 30, pSprite.y-1)
	return isSolid(id1) or isSolid(id2)
end

function drawSprite(pSprite)
	if pSprite.type == "player" then
		love.graphics.rectangle("fill", pSprite.x, pSprite.y, 32, 32)
	else
		love.graphics.rectangle("fill", pSprite.x, pSprite.y, 32, 32)
	end
end
	
	