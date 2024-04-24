local SceneGame= {}

function SceneGame:new()
    local instance = {}
    setmetatable(instance, {__index = SceneGame})

     instance.listeSprites = {}

    return instance 
end

local zombie = require("Zombie")
local heros = require("Hero")
local imageM = require("ImageManager")

function SceneGame:Load()

	images = imageM:new();
	images:Load("Heros_Animation")
	images:Load("ZombieAnimation")
 
	myZombie2 = zombie:new("Zombie")
	myZombie2:AddAnimation(images:GetImage("ZombieAnimation"),"Walk",{81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96},70,70,0.2)
	myZombie2:LanceAnimation("Walk")
	myZombie2:SetPosition(70,70)
	myZombie2:SetVelocite(1,0)
	myZombie2:SetSpeed(50)
	
    myHero = heros:new("Hero")
	myHero:AddAnimation(images:GetImage("Heros_Animation"),"Walk",{1,2,3,4,5,6,7,8,9,10},70,70,0.2)
	myHero:LanceAnimation("Walk")
	myHero:SetPosition(300,300)
	myHero:SetSpeed(150)

	table.insert(self.listeSprites,myZombie2)
    table.insert(self.listeSprites,myHero)
end

function SceneGame:UnLoad()
     self.listeSprites = {}
end

function SceneGame:Update(dt)
    for i=1, #self.listeSprites do 
		self.listeSprites[i]:Update(dt)
	end
end

function SceneGame:Draw()
    for i=1, #self.listeSprites do 
		self.listeSprites[i]:Draw()
	end
end

function SceneGame:Keypressed(key)
    if key == "escape" then
        SceneManager:ChangeScene("Menu")
    end
end

return SceneGame