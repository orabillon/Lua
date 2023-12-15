local Objet = {}

function Objet:new()
    local instance = {}
    setmetatable(instance, {__index = Objet})

    instance.x = 0
    instance.y = 0
    instance.img = nil
    instance.alpha = 0
    instance.visible = false

    return instance
end

function Objet:setImg(pImg)
    self.img = pImg
end

function Objet:show()
    self.visible = true
    self.alpha = 0
end

function Objet:hide()
    self.visible = false
    self.alpha = 1
end

function Objet:update(dt)
    if self.visible == true and self.alpha < 1 then
        self.alpha = self.alpha + dt
    end

    if self.visible == false and self.alpha > 0 then
        self.alpha = self.alpha - dt
    end
end

function Objet:draw()  
    if self.img ~= nill then
        love.graphics.setColor(1,1,1,self.alpha)
        love.graphics.draw(self.img, self.x, self.y)
    end
    love.graphics.setColor(1,1,1,1)
end

return Objet