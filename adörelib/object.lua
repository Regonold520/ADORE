local adore = Adore

local object = {}

function object:new(quad, fileName, x, y, id, layer)
    obj = {
        quad = quad,
        drawable = adore:findSprite(fileName),
        x = x,
        y = y,
        rot = 0,
        scale = 4,
        id = id,
        layer = layer
    }

    table.insert(adore.drawables, obj)
    adore.needsSort = true

    return obj
end

return object