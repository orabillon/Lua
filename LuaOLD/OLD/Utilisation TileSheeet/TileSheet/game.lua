local Game = {}

-- Representation de la carte
Game.Map = {}
Game.Map.Grid =  {
  {10, 10, 10, 10, 10, 10, 10, 10, 10, 61, 10, 13, 10, 10, 10, 10, 10, 10, 13, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15},
  {10, 10, 10, 10, 10, 11, 11, 11, 10, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 14, 15, 15, 129, 15, 15, 15, 15, 15, 15, 68, 15, 15},
  {10, 10, 61, 10, 11, 19, 19, 19, 11, 10, 10, 13, 10, 10, 169, 10, 10, 10, 10, 13, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15},
  {10, 10, 10, 11, 19, 19, 19, 19, 19, 11, 10, 13, 10, 10, 10, 10, 10, 10, 10, 10, 13, 14, 15, 15, 15, 68, 15, 15, 15, 15, 15, 15},
  {10, 10, 10, 11, 19, 19, 19, 19, 19, 11, 10, 13, 10, 10, 10, 10, 10, 10, 61, 10, 10, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15},
  {10, 10, 61, 10, 11, 19, 19, 19, 11, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 10, 10, 14, 15, 15, 129, 15, 15, 15, 68, 15, 129, 15},
  {10, 10, 10, 10, 10, 11, 11, 11, 10, 10, 61, 13, 10, 10, 10, 10, 10, 10, 10, 10, 10, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15},
  {10, 10, 10, 10, 10, 13, 13, 13, 13, 13, 13, 13, 10, 10, 10, 10, 10, 169, 10, 10, 10, 13, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15},
  {10, 10, 10, 10, 10, 10, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 61, 10, 13, 14, 14, 14, 14, 14, 14, 14, 15, 129},
  {10, 10, 10, 10, 10, 10, 10, 10, 13, 55, 10, 58, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 13, 14, 14},
  {10, 10, 10, 10, 10, 10, 10, 10, 13, 10, 10, 10, 55, 10, 58, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10},
  {10, 10, 10, 10, 10, 10, 10, 10, 13, 10, 58, 10, 10, 10, 10, 10, 10, 169, 10, 10, 10, 10, 10, 10, 61, 10, 10, 10, 10, 10, 1, 1},
  {10, 10, 10, 10, 10, 10, 10, 10, 13, 10, 10, 10, 58, 10, 10, 10, 10, 10, 10, 10, 10, 61, 10, 10, 10, 10, 10, 10, 10, 1, 37, 37},
  {13, 13, 13, 13, 13, 13, 13, 13, 13, 10, 55, 10, 10, 10, 55, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 1, 1, 37, 37, 37},
  {10, 10, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 55, 10, 10, 10, 10, 169, 10, 10, 10, 10, 10, 10, 10, 10, 1, 37, 37, 37, 37, 37},
  {10, 10, 10, 10, 13, 10, 10, 10, 10, 142, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 1, 37, 37, 37, 37, 37, 37},
  {10, 10, 10, 10, 13, 10, 10, 10, 10, 10, 10, 10, 10, 142, 10, 10, 10, 10, 10, 10, 10, 169, 10, 10, 1, 37, 37, 37, 37, 37, 37, 37},
  {14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 1, 37, 37, 37, 37, 37, 37, 37},
  {14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 1, 37, 37, 37, 37, 37, 37, 37},
  {19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 1, 37, 37, 37, 37, 37, 37, 37},
  {20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 1, 37, 37, 37, 37, 37, 37},
  {21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 1, 37, 37, 37, 37},
  {21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 1, 37, 37, 37}
  }
  
Game.TileSheet = nil
Game.Textures = {}
Game.TileTypes = {}
Game.Hero = require("hero")

Game.Map.MAP_WIDTH = 32
Game.Map.MAP_HEIGHT = 23
Game.Map.TILE_WIDTH = 32
Game.Map.TILE_HEIGHT = 32

function Game.Load()
  print("GAME:Chargement textures ...")
  -- chargement TileSheet
  Game.TileSheet = love.graphics.newImage("images/tilesheet.png");
  
  -- Decoupage de la tileSheet en quad representant les textures
  Game.Textures[0] = nil
  local nbColumns = Game.TileSheet:getWidth() / Game.Map.TILE_WIDTH
  local nbLines = Game.TileSheet:getHeight() / Game.Map.TILE_HEIGHT

  local l,c
  local idTile = 1
  for l=1, nbLines do
    for c=1, nbColumns do
      Game.Textures[idTile] = love.graphics.newQuad((c - 1) * Game.Map.TILE_WIDTH, (l - 1) * Game.Map.TILE_HEIGHT
, Game.Map.TILE_WIDTH, Game.Map.TILE_HEIGHT
, Game.TileSheet:getWidth(), Game.TileSheet:getHeight())
      idTile = idTile + 1
    end
  end
  -- Asso nom ID
  Game.TileTypes[10] = "Herbe"
  Game.TileTypes[11] = "Herbe"
  Game.TileTypes[13] = "Sable"
  Game.TileTypes[14] = "Sable"
  Game.TileTypes[15] = "Sable"
  Game.TileTypes[129] = "Rocher"
  Game.TileTypes[169] = "Rocher"
  Game.TileTypes[55] = "Arbre"
  Game.TileTypes[58] = "Arbre"
  Game.TileTypes[142] = "Arbre"
  Game.TileTypes[61] = "Arbre"
  Game.TileTypes[68] = "Arbre"
  Game.TileTypes[1] = "Gravier"
  Game.TileTypes[37] = "Lave"
  Game.TileTypes[19] = "Eau"
  Game.TileTypes[20] = "Eau"
  Game.TileTypes[21] = "Eau"

  print("GAME:Chargement textures terminée...")
end

function Game.Draw()
  
  -- dessin de la carte 
  local l,c
  for l = 1, Game.Map.MAP_HEIGHT
 do
    for c = 1, Game.Map.MAP_WIDTH
 do 
      local id = Game.Map.Grid[l][c]
      local textureQuad = Game.Textures[id]
      if textureQuad ~= nil then
        love.graphics.draw(Game.TileSheet,textureQuad,(c-1)*Game.Map.TILE_WIDTH,(l-1)*Game.Map.TILE_HEIGHT)
      end
    end
  end
  
  -- dessin du hero
  Game.Hero.Draw(Game.Map)
  
  -- recuperation de la tile ou se trouve la souris 
  local x,y = love.mouse.getPosition()
  local col = math.floor(x / Game.Map.TILE_WIDTH) + 1
  local lig = math.floor(y / Game.Map.TILE_HEIGHT
) + 1
  if col >= 0 and col <= Game.Map.MAP_WIDTH
 then
    if lig >= 0 and lig <= Game.Map.MAP_HEIGHT
 then
      local id = Game.Map.Grid[lig][col]
      print(Game.TileTypes[id])
    end
  end
  
end

function Game.Update(dt)
  Game.Hero.Update(Game.Map,dt)
end


-- fonction perso
function Game.Map.IsSolid(pId)
  local typeTile =  Game.TileTypes[pId]
  if typeTile == "Rocher" or typeTile == "Arbre" or typeTile == "Eau" or typeTile == "Lave" then
    return true
  end
  return false
end

return Game