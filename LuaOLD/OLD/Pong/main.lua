pad = {}
pad.x = 0
pad.y = 0
pad.largeur = 20
pad.hauteur = 80

pad2 = {}
pad2.x = 0
pad2.y = 0
pad2.largeur = 20
pad2.hauteur = 80

balle = {}
balle.x = 400
balle.y = 300
balle.largeur = 20
balle.hauteur = 20
balle.vitesse_x = 2
balle.vitesse_y = 2

score_joueur1 = 0
score_joueur2 = 0

function CentreBalle()
  balle.x = love.graphics.getWidth() / 2
  balle.x = balle.x - balle.largeur / 2

  balle.y = love.graphics.getHeight() / 2
  balle.y = balle.y - balle.hauteur / 2
  
  balle.vitesse_x = 2
  balle.vitesse_y = 2
  
  pad.x = 0
  pad.y = 0
  
  pad2.x = love.graphics.getWidth() - pad2.largeur
  pad2.y = love.graphics.getHeight() - pad2.hauteur
end

function love.load()
  
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
  love.graphics.rectangle("fill", pad.x, pad.y, pad.largeur, pad.hauteur)
  love.graphics.rectangle("fill", pad2.x, pad2.y, pad2.largeur, pad2.hauteur)

  -- Dessin de la balle
  love.graphics.rectangle("fill", balle.x, balle.y, balle.largeur, balle.hauteur)
  
  -- BONUS : Affiche le score centré sur l'écran
  local font = love.graphics.getFont()
  local score = score_joueur1.." - "..score_joueur2
	local largeur_score = font:getWidth(score)
  love.graphics.print(score, (love.graphics.getWidth() / 2) - (largeur_score / 2), 5)

end

