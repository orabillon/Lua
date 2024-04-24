-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-- calcul de la distance entre 2 points 
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

local myGame = require("game")

function love.load()
  
  -- Change taille ecran
  love.window.setMode(1024,736)
  
  largeur_ecran = love.graphics.getWidth()
  hauteur_ecran = love.graphics.getHeight()
  
  myGame.Load()
  
end

function love.update(dt)
  myGame.Update(dt)
end

function love.draw()
    myGame.Draw()
end

function love.keypressed(key)
  
  print(key)
  
end