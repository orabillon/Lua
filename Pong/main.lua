-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

love.window.setTitle("Pong")

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

imgPad1 = love.graphics.newImage("images/Pad1.png")
imgPad2 = love.graphics.newImage("images/Pad2.png")
imgBall = love.graphics.newImage("images/Ball.png")

pad = {}
pad.x = 0
pad.y = 0
pad.largeur = nill
pad.hauteur = nill
pad.img = imgPad1

pad2 = {}
pad2.x = 0
pad2.y = 0
pad2.largeur = nill
pad2.hauteur = nill
pad2.img = imgPad2

balle = {}
balle.x = 400
balle.y = 300
balle.largeur = nill
balle.hauteur = nill
balle.vitesse_x = 1
balle.vitesse_y = 1
balle.img = imgBall

score_joueur1 = 0
score_joueur2 = 0

function CentreBalle()
    balle.x = love.graphics.getWidth() / 2
    balle.x = balle.x - balle.largeur / 2

    balle.y = love.graphics.getHeight() / 2
    balle.y = balle.y - balle.hauteur / 2

    pad.x = 0
    pad.y = 0

    pad2.x = screenWidth - pad2.largeur
    pad2.y = screenHeight - pad2.hauteur
end

function love.load()
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    pad.largeur = pad.img:getWidth()
    pad.hauteur = pad.img:getHeight()
    pad2.largeur = pad2.img:getWidth()
    pad2.hauteur = pad2.img:getHeight()
    balle.largeur = balle.img:getWidth()
    balle.hauteur = balle.img:getHeight()

    CentreBalle()
end

function love.update(dt)
    -- Pad 1
    if love.keyboard.isDown("q") and pad.y < love.graphics.getHeight() - pad.hauteur then
        pad.y = pad.y + 2
    end

    if love.keyboard.isDown("a") and pad.y > 0 then
        pad.y = pad.y - 2
    end

    -- Pad 2
    if love.keyboard.isDown("down") and pad2.y < love.graphics.getHeight() - pad2.hauteur then
        pad2.y = pad2.y + 2
    end

    if love.keyboard.isDown("up") and pad2.y > 0 then
        pad2.y = pad2.y - 2
    end

    balle.x = balle.x + balle.vitesse_x
    balle.y = balle.y + balle.vitesse_y

    if balle.x < 0 then
        balle.vitesse_x = balle.vitesse_x * -1
    -- ou : balle.vitesse_x = -balle.vitesse_x
    end
    if balle.y < 0 then
        balle.vitesse_y = balle.vitesse_y * -1
    end
    if balle.y > love.graphics.getHeight() - balle.hauteur then
        balle.vitesse_y = balle.vitesse_y * -1
    end

    -- La balle a-t-elle atteint la raquette de gauche ?
    if balle.x <= pad.x + pad.largeur then
        -- Tester maintenant si la balle est sur la raquette ou pas
        if balle.y + balle.hauteur > pad.y and balle.y < pad.y + pad.hauteur then
            balle.vitesse_x = balle.vitesse_x * -1
        end
    end

    -- La balle a-t-elle atteint le bord gauche de l'écran
    if balle.x <= 0 then
        -- Perdu jouer 1!
        CentreBalle()
        score_joueur2 = score_joueur2 + 1
    end

    -- La balle a-t-elle atteint la raquette de droite ?
    if balle.x + balle.largeur >= pad2.x then
        -- Tester maintenant si la balle est sur la raquette ou pas
        if balle.y + balle.hauteur > pad2.y and balle.y < pad2.y + pad2.hauteur then
            balle.vitesse_x = balle.vitesse_x * -1
        end
    end

    -- La balle a-t-elle atteint le bord droit de l'écran
    if balle.x + balle.largeur > love.graphics.getWidth() then
        -- Perdu joueur 2 !
        CentreBalle()
        score_joueur1 = score_joueur1 + 1
    end
end

function love.draw()
    -- Dessin des pads
    love.graphics.draw(pad.img, pad.x, pad.y)
    love.graphics.draw(pad2.img, pad2.x, pad2.y)

    -- Dessin de la balle
    love.graphics.draw(balle.img, balle.x, balle.y)

    -- BONUS : Affiche le score centré sur l'écran
    local font = love.graphics.getFont()
    local score = score_joueur1 .. " - " .. score_joueur2
    local largeur_score = font:getWidth(score)
    love.graphics.print(score, (love.graphics.getWidth() / 2) - (largeur_score / 2), 5)
end

function love.keypressed(key)
end
