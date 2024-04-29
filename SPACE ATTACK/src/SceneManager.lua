local SceneManager = {}

SceneManager.lstScene = {}
SceneManager.currentScene = nil

function SceneManager.AddScene(pNom, pScene)
    SceneManager.lstScene[pNom] = pScene
end

function SceneManager.ChangeScene(pNom)
    if SceneManager.currentScene ~= nill then
        SceneManager.currentScene.unload()
    end

    SceneManager.currentScene = SceneManager.lstScene[pNom]
    SceneManager.currentScene.load()
end

function SceneManager.Load()
    if SceneManager.currentScene ~= nil then
        SceneManager.currentScene.load()
    end
end

function SceneManager.UnLoad()
    if SceneManager.currentScene ~= nil then
        SceneManager.currentScene.unload()
    end   
end

function SceneManager.Update(dt)
    if SceneManager.currentScene ~= nil then
        SceneManager.currentScene.update(dt)
    end
end

function SceneManager.Draw()
    if SceneManager.currentScene ~= nil then
        SceneManager.currentScene.draw()
    end
end

function SceneManager.Keypressed(key)
    if SceneManager.currentScene ~= nil then
        SceneManager.currentScene.keypressed(key)
    end
end

return SceneManager