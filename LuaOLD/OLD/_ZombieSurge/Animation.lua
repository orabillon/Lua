local Animation = {}

function Animation:new(pImage, pNom, pFrames, pWidth, pHeight, pVitesse)
    local instance = {}
    setmetatable(instance, {__index = Animation})

    instance.image = pImage
    instance.nombreframe = #pFrames
    instance.frames = {}
	instance.nom = pNom
    instance.currentFrame = 1
    instance.vitesse = pVitesse 
    instance.Width = pWidth
    instance.Height = pHeight

    instance.nbCol = instance.image:getWidth() / instance.Width

    local l,c 
    l = math.floor((pFrames[1] / instance.nbCol)) + 1
    
    for i=1,#pFrames do
        if pFrames[i] > instance.nbCol then
            c = pFrames[i] - ((l - 1) * instance.nbCol)
        else
            c = pFrames[i]
        end
    
        local x,y
    
        x = (c - 1) * instance.Width
        y = (l - 1) * instance.Height
    
        table.insert(instance.frames, love.graphics.newQuad(x, y, pWidth, pHeight, instance.image:getDimensions()))    
    end
    
   
    return instance
end

function Animation:Update(dt)
    self.currentFrame = self.currentFrame + self.vitesse * 60 * dt
    if self.currentFrame >= self.nombreframe + 1 then
        self.currentFrame = 1
    end
end

function Animation:Draw(pX, pY, pSensAnimation)
    love.graphics.draw(self.image, self.frames[math.floor(self.currentFrame)],pX ,pY, 0,pSensAnimation,1,35,35)
end

return Animation