local map = {}

map.TileSize = 32

map.Grid = {}
map.level = {}
map.level.playerStart = {}

map.ImgTiles = {}
map.ImgTiles["1"] = love.graphics.newImage("images/tile1.png")

function map.ChargeNiveau(pNiveau)
    map.Grid = {}
    if pNiveau == 1 then

        map.Grid[1]  = "1111111111111111111111111"
        map.Grid[2]  = "1000000000000000000000001"
        map.Grid[3]  = "1000111111111111111100001"
        map.Grid[4]  = "1000000000000000000010011"
        map.Grid[5]  = "1000000000000000000000001"
        map.Grid[6]  = "1000000000000000000000111"
        map.Grid[7]  = "1000000000000000000000001"
        map.Grid[8]  = "1000000000000000011111111"
        map.Grid[9]  = "1000000000000100000000001"
        map.Grid[10] = "1000000000000001000000001"
        map.Grid[11] = "1000000000111100000000001"
        map.Grid[12] = "1000000000000000000000001"
        map.Grid[13] = "1111111000000000000000001"
        map.Grid[14] = "1000000010000000000000001"
        map.Grid[15] = "1100000000111100000000001"
        map.Grid[16] = "1000000001000010000000001"
        map.Grid[17] = "1000000010000001000000001"
        map.Grid[18] = "1111111111111111111111111"

        map.level.playerStart.col = 2
        map.level.playerStart.lig = 14

    elseif pNiveau == 2 then

        map.Grid[1]  = "1111111111111111111111111"
        map.Grid[2]  = "1000000000000000000000001"
        map.Grid[3]  = "1000111111111111111100001"
        map.Grid[4]  = "1000000000000000000010011"
        map.Grid[5]  = "1000000000000000000000001"
        map.Grid[6]  = "1000000000000000000000111"
        map.Grid[7]  = "1000000000000000000000001"
        map.Grid[8]  = "1000000000000000011111111"
        map.Grid[9]  = "1000000000000100000000001"
        map.Grid[10] = "1000000000000001000000001"
        map.Grid[11] = "1000000000111100000000001"
        map.Grid[12] = "1000000000000000000000001"
        map.Grid[13] = "1111111000000000000000001"
        map.Grid[14] = "1000000010000000000000001"
        map.Grid[15] = "1100000000100100000000001"
        map.Grid[16] = "1000000001000010000000001"
        map.Grid[17] = "1000000010000001000000001"
        map.Grid[18] = "1111111111111111111111111"

        map.level.playerStart.col = 2
        map.level.playerStart.lig = 14
    end
end

function map.getTileAt(pX,pY)

    local col = math.floor(pX / map.TileSize) + 1
    local lig = math.floor(pY / map.TileSize) + 1

    if col>0 and col<=#map.Grid[1] and lig>0 and lig<=#map.Grid then
        local id = string.sub(map.Grid[lig],col,col)
        return id
    end

    return 0
end

return map