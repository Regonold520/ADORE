local tileM = {}

Adore.Tile.Lookups = {}

-- id lookup is an entry for each tile, dictating where they are on the atlas & any other info
Adore.Tile.Lookups.groundLookup = {{id = 'forest-grass', x = 0, y = 0, sizeX = 16, sizeY = 16,},
            {id = 'forest-dirt', x = 34, y = 0, sizeX = 16, sizeY = 16,},
            {id = 'desert-ground', x = 85, y = 0, sizeX = 16,sizeY = 16,}}


Adore.Tile.Lookups.flowerLookup = {}

-- the load map is the tilemap loaded to draw on load 
Adore.Tile.Map = { scalar = 64, atlas = 'ground.png', lookup = Adore.Tile.Lookups.groundLookup, tileSize = 16, idSet = 'ground-id '}
Adore.Tile.Flowers = { scalar = 64, atlas = 'flowers.png', lookup = Adore.Tile.Lookups.flowerLookup, tileSize = 32, idSet = 'flower'}
Adore.Tile.Tickers = {}


function cacheFlower(id, x, y, sizeX, sizeY, nectar, fertItem)
    local flower = {
            id = id,
            x = x,
            y = y,
            sizeX = sizeX,
            sizeY = sizeY,
            data = {pollen = Adore:titleCase(id).. " Pollen", nectar = nectar, fertItem = fertItem},
            funcs = {},
            blockstates = {
                currentState = "state1",

                state1 = {love.graphics.newQuad(x, y, sizeX, sizeY, Adore:findSprite('flowers.png'):getWidth(), Adore:findSprite('flowers.png'):getHeight())},
                state2 = {love.graphics.newQuad(x+sizeX, y, sizeX, sizeY, Adore:findSprite('flowers.png'):getWidth(), Adore:findSprite('flowers.png'):getHeight())},
                state3 = {love.graphics.newQuad(x+(sizeX*2), y, sizeX, sizeY, Adore:findSprite('flowers.png'):getWidth(), Adore:findSprite('flowers.png'):getHeight())}, 
                state4 = {love.graphics.newQuad(x+(sizeX*3), y, sizeX, sizeY, Adore:findSprite('flowers.png'):getWidth(), Adore:findSprite('flowers.png'):getHeight())}
            }
        }

    function flower.funcs:onTick()
        if self.parent.blockstates.currentState == "state1" and math.random(1,10) == 1 then self:changeState("state2") return end
        if self.parent.blockstates.currentState == "state2" and math.random(1,10) == 1 then self:changeState("state3") return end
        if self.parent.blockstates.currentState == "state3" and math.random(1,10) == 1 then self:changeState("state4") return end
    end

    function flower.funcs:changeState(newState)
        self.parent.quad = self.parent.blockstates[newState][1]
        self.parent.blockstates.currentState = newState
    end

    table.insert(Adore.Tile.Lookups.flowerLookup, flower
        
    )
end

function tileTick()
    for _,i in ipairs(Adore.drawables) do
        if i.funcs ~= nil then
            i.funcs:onTick()
        end
    end
end

function populateLookups()
    cacheFlower("daisy", 1, 1, 7, 8, 5, "Pollen Cluster")
    cacheFlower("sunflower", 1, 26, 11, 20, 5, "Sunflower Seed Cluster")
    cacheFlower("bluebell", 1, 47, 10, 11, 5, "Chime Blossom")
    cacheFlower("poppy", 1, 10, 9, 15, 5, "Tranquil Pod")
    cacheFlower("coneflower", 1, 59, 9, 12, 5, "Echinacea Root")
    cacheFlower("foxglove", 1, 72, 11, 18, 5, "Digitalis Extract")
    cacheFlower("lavender", 1, 91, 5, 19, 5, "Calming Fillament")
    cacheFlower("marigold", 1, 111, 9, 17, 5, "Marigold Pigment")
    cacheFlower("zinnia", 1, 129, 11, 15, 5, "Zinnia Bulb")
end

function tileM:load()
    populateLookups()

    for i = -100,100 do
        tileM:setTile(Adore.Tile.Flowers, i, -4, Adore.Tile.Lookups.flowerLookup[math.random(#Adore.Tile.Lookups.flowerLookup)].id, math.random(0, 2))
        tileM:setTile(Adore.Tile.Map, i, -5, 'forest-grass', 2)
        tileM:setTile(Adore.Tile.Map, i, -6, 'forest-dirt', 2)
        tileM:setTile(Adore.Tile.Map, i, -7, 'forest-dirt', 2)
        tileM:setTile(Adore.Tile.Map, i, -8, 'forest-dirt', 2)
    end

    Adore.Lib.timer.every(1, tileTick)
end

local tileQ = nil

function tileM:setTile( map, x, y, id, layer)
    local lookup = tileM:getTileLookup(id, map.lookup)

    tileQ = love.graphics.newQuad(lookup.x, lookup.y, lookup.sizeX, lookup.sizeY, Adore:findSprite(map.atlas):getWidth(), Adore:findSprite(map.atlas):getHeight())

    table.insert(map,
        {x = x, y = y, id = id})

    local tile = Adore.Lib.object:new(tileQ, map.atlas, x * map.scalar, y * -map.scalar, map.idSet, layer)

    if lookup.blockstates ~= nil then
        tile.blockstates = {}
        for k, v in pairs(lookup.blockstates) do
            if type(v) == 'table' then
                tile.blockstates[k] = {}
                for nk, nv in pairs(v) do
                    tile.blockstates[k][nk] = nv
                end
            else
                tile.blockstates[k] = v
            end
        end
    end
    

    if lookup.funcs ~= nil then
        tile.funcs = {}
        tile.funcs.onTick = lookup.funcs.onTick
        tile.funcs.changeState = lookup.funcs.changeState
        tile.funcs.parent = tile
    end

    if lookup.data ~= nil then tile.data = lookup.data end

end

function tileM:getTileLookup(check, idLookup)
    for _,id in ipairs(idLookup) do
            if check == id.id then
                return id
            end
    end
end

return tileM
