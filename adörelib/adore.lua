local adore = {}

Adore = {}
Adore.Lib = {}


Adore.globalScale = 1.2
Adore.drawables = {}
Adore.needsSort = true
Adore.Tile = {}
Adore.Camera = {x=0,y=0}
Adore.Ui = {}

Adore.Lib.ui = require("adörelib/ui")
Adore.Lib.object = require("adörelib/object")
Adore.Lib.tileM = require("adörelib/tileM")
Adore.Lib.timer = require("adörelib/timer")
Adore.Lib.main = adore

function adore:load()
        math.randomseed(os.time())
        Adore:registerSprites()

        Adore.Lib.tileM:load()
        Adore.Lib.ui:load()

        Adore.Lib.tileM.timer = Adore.Lib.timer

        Adore.started = true
end

function adore:update(dt)
    Adore.Lib.timer:update(dt)
    Adore.Lib.ui:update()
end

function adore:draw()
    -- Drawing objects
    if Adore.needsSort then
        function compare(a, b)
            if a.layer ~= b.layer then
                return a.layer < b.layer
            end

            return string.len(a.id) > string.len(b.id)
        end

        table.sort(Adore.drawables, compare)
        Adore.needsSort = false
    end
    for _,i in ipairs(Adore.drawables) do
        local x, y, w, h = i.quad:getViewport()
        orX = w / 2
        orY = h / 2
        if i.origin ~= nil then
            if i.origin.x ~= nil then
                orX = i.origin.x
            elseif i.origin.y ~= nil then
                orY = i.origin.y
            end
        end

        if i.x * Adore.globalScale < love.graphics.getWidth() + Adore.Camera.x * Adore.globalScale + 64  and i.x * Adore.globalScale >  Adore.Camera.x * Adore.globalScale - 64 and
        i.y * Adore.globalScale < love.graphics.getHeight() + Adore.Camera.y * Adore.globalScale + 64 and i.y * Adore.globalScale >  Adore.Camera.y * Adore.globalScale - 64 then 
            love.graphics.draw(i.drawable, i.quad, (i.x - Adore.Camera.x) * Adore.globalScale, (i.y - Adore.Camera.y) * Adore.globalScale, i.rot, (i.scale + 0.1) * Adore.globalScale, (i.scale + 0.1) * Adore.globalScale, orX, orY)
        end
    end

    -- Drawing UI
    Adore.Lib.ui:draw()
end

function Adore:registerSprites()
    local items = love.filesystem.getDirectoryItems("sprites")

    Adore.sprites = {}

    local dirs = {}

    for _, item in ipairs(items) do
        local fullPath = "sprites/" .. item

        if love.filesystem.getInfo(fullPath, "directory") then

            table.insert(dirs, fullPath)
        end
    end

    for _, dir in ipairs(dirs) do
        for i, img in ipairs(love.filesystem.getDirectoryItems(dir)) do
            if Adore.stringEndsWith(img, ".png") then
                table.insert(Adore.sprites, {
                    path = img,
                    img = love.graphics.newImage(dir .. "/" .. img)
                })
            end
        end
    end
end

function Adore.stringEndsWith(str, suffix)
    return string.sub(str, -string.len(suffix)) == suffix
end

function Adore:findSprite(sprite)
    for _, img in ipairs(Adore.sprites) do
        if img.path == sprite then
            return img.img
        elseif _ == #Adore.sprites then
            return Adore:findSprite("missing.png")
        end
    end
    return nil
end

function Adore:titleCase(phrase)
    local result = string.gsub( phrase, "(%a)([%w_']*)",
        function(first, rest)
            return first:upper() .. rest:lower()
        end
    )
    return result
end

local oldResize = love.resize
love.resize = function(w, h)
    Adore.Ui.Anchors = {
        m  = {x=w/2, y=h/2},
        r  = {x=w, y=h/2},
        l  = {x=0, y=h/2},
        tl = {x=0, y=0},
        tr = {x=w, y=0},
        bl = {x=0, y=h},
        br = {x=w, y=h},
        t  = {x=w/2, y=0},
        b  = {x=w/2, y=h}
    }
    Adore.Lib.ui:reloadUiAnchors()
    
    if oldResize then oldResize(w, h) end
end



return adore