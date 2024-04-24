local animation = require("Animation")

local Sprite = {}

function Sprite:new(pType)
    local instance = {}
    setmetatable(instance, {__index = Sprite})

    instance.x = 0
    instance.y = 0
    instance.vx = 0
	instance.vy = 0
	instance.speed = 0
	instance.type = pType
	instance.animation = {}
    instance.isVisible = true
    instance.currentAnimation = nil
    instance.directionAnimation = 1

    return instance
end

function Sprite:Update(dt)
    -- Mise a jour animation
   if self.currentAnimation ~= nill then
        for i=1,#self.animation do
            if self.animation[i].nom == self.currentAnimation then
                self.animation[i]:Update(dt)
            end
        end
   end
   
   -- Mise a jour position sprite
   self.x = self.x + (self.vx * self.speed * dt)
   self.y = self.y + (self.vy * self.speed * dt)

   -- Machine a etat    
   if self.type == "Zombie" then
     self:IA()
   end
end

function Sprite:Draw()
   if self.currentAnimation ~= nill then
        for i=1,#self.animation do
            if self.animation[i].nom == self.currentAnimation then
                if (self.vx > 0) then
                    self.directionAnimation = -1
                elseif (self.vx < 0) then
                    self.directionAnimation = 1
                end
                self.animation[i]:Draw(self.x, self.y, self.directionAnimation,1)
            end
        end
    end
end

function Sprite:AddAnimation(pImage, pNom, pFrames, pWidth, pHeight,pVitesse)
    myAnimation = animation:new(pImage, pNom, pFrames, pWidth, pHeight,pVitesse)
    table.insert(self.animation,myAnimation)
end

function Sprite:LanceAnimation(pNom)
    self.currentAnimation = pNom  
end

function Sprite:SetPosition(pX, pY)
    self.x = pX
    self.y = pY 
end

function Sprite:SetVelocite(pVx, pVy)
    self.vx = pVx
    self.vy = pVy
end

function Sprite:SetSpeed(pSpeed)
    self.speed = pSpeed
end

return Sprite
