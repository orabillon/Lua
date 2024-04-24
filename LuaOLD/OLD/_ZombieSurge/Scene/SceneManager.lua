local SceneManager = {}

function SceneManager:new()
    local instance = {}
    setmetatable(instance, {__index = SceneManager})

    instance.sceneCourante = nil
    instance.listeScene = {}
    
    return instance
end

function SceneManager:ChangeScene(pScene)
    
    if self.sceneCourante ~= nil then
        self.sceneCourante:UnLoad()
    end
    
    self.sceneCourante = self.listeScene[pScene]
    self.sceneCourante:Load()
end

function SceneManager:SetScene(pNom,pScene)
    self.listeScene[pNom] = pScene
end

function SceneManager:Load()
    if self.sceneCourante ~= nil then
        self.sceneCourante:Load()
    end
end

function SceneManager:UnLoad()
    if self.sceneCourante ~= nil then
        self.sceneCourante:UnLoad()
    end   
end

function SceneManager:Update(dt)
    if self.sceneCourante ~= nil then
        self.sceneCourante:Update(dt)
    end
end

function SceneManager:Draw()
    if self.sceneCourante ~= nil then
        self.sceneCourante:Draw()
    end
end

function SceneManager:Keypressed(key)
    if self.sceneCourante ~= nil then
        self.sceneCourante:Keypressed(key)
    end
end

return SceneManager
