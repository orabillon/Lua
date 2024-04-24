local SceneMenu= {}

function SceneMenu:new()
    local instance = {}
    setmetatable(instance, {__index = SceneMenu})

    -- instance.nom = pNom

    return instance 
end

function SceneMenu:Load()
   
end

function SceneMenu:UnLoad()
  
end

function SceneMenu:Update(dt)
   
end

function SceneMenu:Draw()
    love.graphics.print('Menu', 10, 15)
    love.graphics.print('Jeu [ j ]', 10, 45)
end

function SceneMenu:Keypressed(key)
    if key == "j" then
        SceneManager:ChangeScene("Game")
    end
end

return SceneMenu