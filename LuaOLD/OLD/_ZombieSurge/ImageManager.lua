local ImageManager = {}

function ImageManager:new()
    local instance = {}
    setmetatable(instance, {__index = ImageManager})

    instance.lstImage = {}

    return instance
end

function ImageManager:Load(pNomImage)
    self.lstImage[pNomImage] = love.graphics.newImage("/assets/images/"..pNomImage..".png")
end

function ImageManager:GetImage(pNomImage)
    return self.lstImage[pNomImage]
end

return ImageManager