-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-- Returns the angle between two vectors assuming the same origin.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end


hero = {}
sprites = {}
tirs = {}
aliens = {}

camera = {}
camera.y = 0
camera.vitesse = 60

ecran_courant = "menu"
victoire = false
timerVictoire = 100

-- niveau 32*24 (Tuile 32 * 32) ecran 1024*768
niveau = require("map")

-- jeu
jeux = require("jeux")
menu = require("menu")

tuiles = {}
tuiles[0] = nil
for n=1, 3 do
  tuiles[n] = love.graphics.newImage("images/tuile_"..n..".png")
end

Explosions = {}
for n=1, 5 do
  Explosions[n] = love.graphics.newImage("images/explode_"..n..".png")
end

function CreerAlien (pType, px, py)
  local image = ""
 
 if pType == 1 then
    image = "enemy1"
  elseif pType == 2 then 
    image = "enemy2"
  elseif pType == 3 then
    image = "enemy3"
  elseif pType == 4 then
    image = "tourelle"
  end
 
 local alien = CreerSprite(image, px, py, 0)
  
 if pType == 1 then
    alien.vy = 100
    alien.vx = 0
    alien.vie = 1
    alien.score = 100
  elseif pType == 2 then 
    alien.vy = 110
    local direction = love.math.random(1,2)
    if direction  == 1 then
      alien.vx = 110
    else
      alien.vx = -110 
    end
    alien.vie = 3
    alien.score = 300
  elseif pType == 3 then
    alien.vy = 200
    alien.vx = 0
    alien.vie = 15
    alien.score = 500
    alien.angle = 0
  elseif pType == 4 then
    alien.vy = camera.vitesse
    alien.vx = 0
    alien.vie = 5
    alien.score = 1500
  end
  
  -- Pour que les alien n'agisse qu'a l'écran
  alien.isActif = false
  
  alien.type = pType
  alien.chronoTir = 0
  
  table.insert(aliens, alien)
  
end

function CreerSprite (pNomImage, pX, pY, pVitesseX, pVitesseY)

sprite = {}
sprite.x = pX
sprite.y = pY
sprite.image = love.graphics.newImage("images/"..pNomImage..".png")
sprite.largeur = sprite.image:getWidth()
sprite.hauteur = sprite.image:getHeight()
sprite.vitesseX = pVitesseX
sprite.vitesseY = pVitesseY
sprite.isSupprime = false
sprite.frame = 1
sprite.listeFrames = {}
sprite.maxFrame = 1

table.insert(sprites,sprite)
return sprite

end

function CreerTir(pType,pImage,pX,pY,pVitesseX,pVitesseY)
  tir = CreerSprite(pImage,pX, pY, pVitesseX, pVitesseY)
  tir.type = pType
  table.insert(tirs,tir)
  sonTir:play()
end

function CreerExplosion(pX,pY)
  local nouvExplosion = CreerSprite("explode_1",pX,pY,0,0)
  nouvExplosion.listeFrames = Explosions
  nouvExplosion.maxFrame = 5
end

function collision(pObjet1, pObjet2)
  if pObjet1 == pObjet2 then return false end
  local dx = pObjet1.x - pObjet2.x
  local dy = pObjet1.y - pObjet2.y
  if(math.abs(dx) < pObjet1.image:getWidth() + pObjet2.image:getWidth()) then
    if(math.abs(dy) < pObjet1.image:getHeight() + pObjet2.image:getHeight()) then
      return true
    end
  end
  return false
end

function DemmarerPartie() 
  sprites = {}
  tirs = {}
  aliens = {}
  hero = CreerSprite("heros",largeur_ecran / 2, 0, 200, 200)
  hero.y = hauteur_ecran - (hero.image:getHeight() /2) - 10
  hero.score = 0
  hero.vie = 10
  camera.y = 0
  victoire = false
  timerVictoire = 100
  
  -- creation alien
  CreerAlien(1,(13-1)*niveau.tuileWidht,((4-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(14-1)*niveau.tuileWidht,((6-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(15-1)*niveau.tuileWidht,((6-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(16-1)*niveau.tuileWidht,((4-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(4-1)*niveau.tuileWidht,((10-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(5-1)*niveau.tuileWidht,((12-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(6-1)*niveau.tuileWidht,((12-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(7-1)*niveau.tuileWidht,((10-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(21-1)*niveau.tuileWidht,((26-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(22-1)*niveau.tuileWidht,((28-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(23-1)*niveau.tuileWidht,((28-1)*niveau.tuileHeight)*-1)
  CreerAlien(1,(24-1)*niveau.tuileWidht,((26-1)*niveau.tuileHeight)*-1)
  CreerAlien(2,(14-1)*niveau.tuileWidht,((17-1)*niveau.tuileHeight)*-1)
  CreerAlien(2,(15-1)*niveau.tuileWidht,((19-1)*niveau.tuileHeight)*-1)
  CreerAlien(2,(16-1)*niveau.tuileWidht,((19-1)*niveau.tuileHeight)*-1)
  CreerAlien(2,(17-1)*niveau.tuileWidht,((17-1)*niveau.tuileHeight)*-1)
  CreerAlien(4,(16-1)*niveau.tuileWidht,((17-1)*niveau.tuileHeight)*-1)
  CreerAlien(4,(7-1)*niveau.tuileWidht,((28-1)*niveau.tuileHeight)*-1)
  CreerAlien(3,(15-1)*niveau.tuileWidht,((35-1)*niveau.tuileHeight)*-1)

end

function love.load()
  
  -- Definition parametre fenetre 
  love.window.setMode(1024,768)
  love.window.setTitle("Shoot em up")
  
  largeur_ecran = love.graphics.getWidth()
  hauteur_ecran = love.graphics.getHeight()  
  
  -- chargement son 
  sonTir = love.audio.newSource("sons/shoot.wav","static")
  sonExplosion = love.audio.newSource("sons/explode_touch.wav","static")
  
  imgMenu = love.graphics.newImage("images/menu.jpg")
  imgPerdu = love.graphics.newImage("images/gameover.jpg")
  imgVictoire = love.graphics.newImage("images/victory.jpg")

end

function love.update(dt)
  if ecran_courant == "jeux" then
    jeux.update(dt)
  end
end

function love.draw()
  if ecran_courant == "menu" then
    menu.draw()
  elseif ecran_courant == "jeux" then
    jeux.draw()
  elseif ecran_courant == "perdu" then
    love.graphics.draw(imgPerdu,0,0)
  elseif ecran_courant == "victoire" then
    love.graphics.draw(imgVictoire,0,0)
  end
  
end

function love.keypressed(key)
  
  if key == "space" then
    if ecran_courant == "menu" then
      ecran_courant = "jeux"
      DemmarerPartie()
    elseif ecran_courant == "jeux" then
      CreerTir("hero","laser1",hero.x, hero.y - hero.hauteur / 2, 0, -300)
    elseif ecran_courant == "victoire" or ecran_courant == "perdu" then
      ecran_courant = "menu"
    end
  end
  print(key)
  
end