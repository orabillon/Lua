-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
  require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

grille = {}
grille_largeur = 0
grille_hauteur = 0
taille_cell = 0

pause = true

function love.load()
  nouveau(160, 120)
  randomgame()
end

function love.update(dt)
  if pause == false then
    lifegame()
  end
      
  if love.mouse.isDown(1) then
    local c = math.floor((love.mouse.getX() / taille_cell) + 1)
    local l = math.floor((love.mouse.getY() / taille_cell) + 1)
    if l >= 1 and l <= grille_hauteur and c >= 1 and c <= grille_largeur then
      grille[l][c] = 1
    end
  end
end

function love.draw()
  for l=1,grille_hauteur do
    for c=1,grille_largeur do
      if grille[l][c] == 1 then
        love.graphics.rectangle("fill", (c-1) * taille_cell, (l-1) * taille_cell, taille_cell, taille_cell)
      end
    end
  end
end

function love.keypressed(key)
  if key == "space" then
    pause = not pause
  end
  if key == "right" and pause == true then
    lifegame()
  end
  if key == "left" and pause == true then
    randomgame()
  end
end

-- Fonction perso

function nouveau(largeur, hauteur)
  grille_largeur = largeur
  grille_hauteur = hauteur
  
  grille = {}
  for l=1,grille_hauteur do
    grille[l] = {}
    for c=1,grille_largeur do
      grille[l][c] = 0
    end
  end
  
  local taille_largeur = love.graphics.getWidth() / grille_largeur
  local taille_hauteur = love.graphics.getHeight() / grille_hauteur
  if taille_largeur * grille_hauteur > love.graphics.getHeight() then
    taille_cell = taille_hauteur
  else
    taille_cell = taille_largeur
  end
end

function randomgame()
  for l=1,grille_hauteur do
    for c=1,grille_largeur do
      if love.math.random(1,10) == 1 then
        grille[l][c] = 1
      end
    end
  end
end

function CellValeur(pl, pc)
  if pl >= 1 and pc >= 1 and pl <= grille_hauteur and pc <= grille_largeur then
    return grille[pl][pc]
  else
    return 0
  end
end

function CalcVoisins(pl, pc)
  local nb_voisins = 0
  
  nb_voisins = nb_voisins + CellValeur(pl-1, pc-1)
  nb_voisins = nb_voisins + CellValeur(pl-1, pc)
  nb_voisins = nb_voisins + CellValeur(pl-1, pc+1)
  
  nb_voisins = nb_voisins + CellValeur(pl, pc-1)
  nb_voisins = nb_voisins + CellValeur(pl, pc+1)
  
  nb_voisins = nb_voisins + CellValeur(pl+1, pc-1)
  nb_voisins = nb_voisins + CellValeur(pl+1, pc)
  nb_voisins = nb_voisins + CellValeur(pl+1, pc+1)  
  
  return nb_voisins
end

function lifegame()
  local nouvelle_grille = {}
  
  for l=1,grille_hauteur do
    nouvelle_grille[l] = {}
    for c=1,grille_largeur do
      local v = CalcVoisins(l, c)
      if v == 2 then
        nouvelle_grille[l][c] = grille[l][c]
      elseif v == 3 then
        nouvelle_grille[l][c] = 1
      else
        nouvelle_grille[l][c] = 0
      end
    end
  end
  grille = nouvelle_grille
end