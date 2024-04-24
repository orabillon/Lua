-- Variable simple local au fichier
local largeur_ecran
local hauteur_ecran

local pad = {}
pad.x = 0
pad.y = 0
pad.largeur = 80
pad.hauteur = 20

local balle = {}
balle.x = 0
balle.y = 0
balle.vx = 0
balle.vy = 0
balle.angle = 0
balle.vitesse = 0
balle.colle = true
balle.rayon = 10
degre45 = (math.pi*2) / (360/45)

local brique = {}
local niveau = {}

function Demarre()
  pad.y = hauteur_ecran - (15/2)
  
  brique.hauteur = 25
  brique.largeur = largeur_ecran / 15

  balle.angle = 0 - degre45
  balle.vitesse = 300
  balle.colle = true
  
  -- creation niveau
  for l = 1,6 do
    niveau[l] = {}
    for c = 1,15 do
      if (l + c) % 2 == 0 then
      niveau[l][c] = 1
    else
      niveau[l][c] = 2
    end
      
    end
  end
end

function love.load()
  largeur_ecran = love.graphics.getWidth()
  hauteur_ecran = love.graphics.getHeight()
  -- cache la souris
  love.mouse.setVisible(false)
  Demarre()
end

function love.update(dt)
  pad.x = love.mouse.getX()
  
  -- position raquette bord ecran
  if (pad.x - pad.largeur / 2) < 0 then pad.x = pad.largeur / 2 end
  if (pad.x + pad.largeur / 2)> largeur_ecran then pad.x = largeur_ecran - pad.largeur / 2 end
  
  -- balle sur pad
  if balle.colle == true then
    balle.x = pad.x
    balle.y = pad.y - (pad.hauteur/2) - (balle.rayon)
  else
    balle.x = balle.x + balle.vx*dt
    balle.y = balle.y + balle.vy*dt
    
    -- Transformation de la position sous forme de tableau pour tester brique 
    local c = math.floor((balle.x / brique.largeur)) + 1
    local l = math.floor((balle.y / brique.hauteur)) + 1
    
    if l > 0  and l <= #niveau and c >= 1 and c <= 15 then
      if niveau[l][c] == 1 then
        niveau[l][c] = 0
        balle.vy = balle.vy * -1
      elseif niveau[l][c] == 2 then
        niveau[l][c] = 1
        balle.vy = balle.vy * -1
      end
    end
    
    -- collision balle Pad
    if balle.y > (pad.y - pad.hauteur/2) - balle.rayon then
      local distanceX = math.abs(pad.x - balle.x)
      if distanceX < pad.largeur / 2 then
        balle.vy = balle.vy * -1
        balle.y = (pad.y - pad.hauteur/2) - balle.rayon
      end
    end
    
    -- collision mur
    if balle.x > largeur_ecran or balle.x < 0 then
      balle.vx = balle.vx * -1
    end
    if balle.y < 0 then balle.vy = balle.vy * -1 end
    
    if balle.y > hauteur_ecran then
      balle.colle = true
    end
  end

end

function love.draw()
  --dessin des briques
  local bx, by = 0,0
  for l = 1,6 do
    bx = 0
    for c = 1,15 do
      if niveau[l][c] == 1 then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill",bx + 1, by + 1, brique.largeur - 2, brique.hauteur - 2)
      elseif niveau[l][c] == 2 then
        love.graphics.setColor(0,0,1)
        love.graphics.rectangle("fill",bx + 1, by + 1, brique.largeur - 2, brique.hauteur - 2)
      end
      bx = bx + brique.largeur
    end
    by = by + brique.hauteur
  end

  love.graphics.setColor(0,1,0)
  love.graphics.rectangle("fill", pad.x - (pad.largeur/2), pad.y - (pad.hauteur/2), pad.largeur, pad.hauteur)
  love.graphics.setColor(1,1,0)
  love.graphics.circle("fill", balle.x, balle.y, balle.rayon)
end

function love.mousepressed(px, py, pn)
  if balle.colle == true then
    balle.colle = false
    balle.vx = balle.vitesse * math.cos(balle.angle)
    balle.vy = balle.vitesse * math.sin(balle.angle)
  end
end