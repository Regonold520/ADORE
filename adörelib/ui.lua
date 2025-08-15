local adore = Adore

local Ui = {}



local Q = {
    empty = love.graphics.newQuad(0, 0, 0, 0, 103, 50),
    square = love.graphics.newQuad(1, 1, 48, 48, 103, 50),
    long = love.graphics.newQuad(50, 17, 16, 32, 103, 50),
    tiny_square = love.graphics.newQuad(67, 21, 28, 28, 103, 50)
}

local font = love.graphics.newFont("fonts/pixellari.ttf", 16)
font:setFilter("nearest", "nearest")

local fOver = {}

function Ui:load()

    adore.Ui.Anchors = {m = {x=love.graphics.getWidth() / 2, y=love.graphics.getHeight() / 2, id="m"},
            r = {x=love.graphics.getWidth(), y=love.graphics.getHeight() / 2, id="r"},
            l = {x=0, y=love.graphics.getHeight() / 2, id="l"},
            tl = {x=0, y=0, id="tl"},
            tr = {x=love.graphics.getWidth(), y=0, id="tr"},
            bl = {x=0, y=love.graphics.getHeight(), id="bl"},
            br = {x=love.graphics.getWidth(), y=love.graphics.getHeight(), id="br"},
            t = {x=love.graphics.getWidth() / 2, y=0, id="t"},
            b = {x=love.graphics.getWidth() / 2, y=love.graphics.getHeight(), id="b"}}

    adore.Ui.Objects = {}
    

    Ui:addPanel("pollen_panel", adore.Ui.Anchors.tl, {x=0, y=0, pX=10, pY=10}, Q.square, adore:findSprite("testui.png"), 1)

    for i = -2,2 do
        Ui:addPanel("inv".. i + 3, adore.Ui.Anchors.b, {x=0, y=0, pX=120 * i, pY=-10}, Q.tiny_square, adore:findSprite("testui.png"), 1)
        Ui:addPanel("slot".. i + 3, adore.Ui.Anchors.b, {x=0, y=0, pX=120 * i, pY=-35, scale = 1.4}, Q.empty, adore:findSprite("testui.png"), 2)
        Ui:addText("slot".. i + 3 .. "text", adore.Ui.Anchors.b, {x=0, y=0, pX=120 * i+ 40, pY=0}, 3, "")
    end


    Ui:addText("pollen_text", adore.Ui.Anchors.tl, {x=0,y=0, pX=30,pY=70}, 2, "")
    Ui:addText("nectar_text", adore.Ui.Anchors.tl, {x=0,y=0, pX=30,pY=30}, 2, "")

end

function Ui:update()
    Ui:buttonHovering()


end

function Ui:addPanel(id, anchor, offset, quad, drawable, layer)
    adore.Ui.Objects[id] = {
        type = "panel",
        anchor = anchor,
        offset =offset,
        quad = quad,
        drawable = drawable,
        layer = layer
    }
end

function Ui:addButton(id, anchor, offset, quad, drawable, layer, pressedFunc)
    adore.Ui.Objects[id] = {
        type = "button",
        anchor = anchor,
        offset =offset,
        quad = quad,
        drawable = drawable,
        layer = layer,
        id = id
    }

    adore.Ui.Objects[id].pressed = pressedFunc
end

function Ui:addText(id, anchor, offset, layer, text)
    adore.Ui.Objects[id] = {
        type = "text",
        anchor = anchor,
        offset = offset,
        layer = layer,
        id = id,
        text = text
    }
end

function Ui:reloadUiAnchors()

    for _, i in pairs(adore.Ui.Objects) do

        if i.anchor.id ~= nil then
            if i.anchor.id == "tr" then i.anchor.x, i.anchor.y = adore.Ui.Anchors.tr.x , adore.Ui.Anchors.tr.y 
            elseif i.anchor.id == "r" then i.anchor.x, i.anchor.y = adore.Ui.Anchors.r.x , adore.Ui.Anchors.r.y 
            elseif i.anchor.id == "br" then i.anchor.x, i.anchor.y = adore.Ui.Anchors.br.x , adore.Ui.Anchors.br.y 
            elseif i.anchor.id == "b" then i.anchor.x, i.anchor.y = adore.Ui.Anchors.b.x , adore.Ui.Anchors.b.y 
            elseif i.anchor.id == "bl" then i.anchor.x, i.anchor.y = adore.Ui.Anchors.bl.x , adore.Ui.Anchors.bl.y 
            elseif i.anchor.id == "l" then i.anchor.x, i.anchor.y = adore.Ui.Anchors.l.x , adore.Ui.Anchors.l.y 
            elseif i.anchor.id == "tl" then i.anchor.x, i.anchor.y = adore.Ui.Anchors.tl.x , adore.Ui.Anchors.tl.y 
            elseif i.anchor.id == "t" then i.anchor.x, i.anchor.y = adore.Ui.Anchors.t.x , adore.Ui.Anchors.t.y 
            elseif i.anchor.id == "m" then i.anchor.x, i.anchor.y = adore.Ui.Anchors.m.x , adore.Ui.Anchors.m.y end
        end
    end
end


function Ui:draw()
    love.graphics.setColor(1, 1, 1)

    local ordered = {}
    for _, obj in pairs(adore.Ui.Objects) do
        table.insert(ordered, obj)
    end

    table.sort(ordered, function(a, b)
        return a.layer < b.layer
    end)

    for _, i in ipairs(ordered) do
        Ui:basicDraw(i)
    end
end

function Ui:click()
    if fOver[1] ~= nil then
        fOver[1]:pressed()
    end
end

function Ui:buttonHovering()
    local over = {}


    for _,i in pairs(adore.Ui.Objects) do
        if i ~= nil and i.trueOffset ~= nil and i.type == "button" then

            local Mx, My = love.mouse.getPosition()

            local x, y, w, h = i.quad:getViewport()

            local newX = i.anchor.x + (love.graphics.getWidth() / 100 * i.offset.x) + i.offset.pX
            local newY = i.anchor.y + (love.graphics.getHeight() / 100 * i.offset.y) + i.offset.pY

            if Mx > newX - w * 2 and Mx < newX + w * 2 + i.trueOffset.x and
                    My > newY - h * 2 and My < newY + h * 2  + i.trueOffset.y then table.insert(over, i) end
        end
    end

    function compare(a, b)
        return a.layer > b.layer
    end

    table.sort(over, compare)

    fOver = over

end

function Ui:basicDraw(asset)
    if asset ~= nil then
        local x, y, w, h = 0
        local mult = 0
        local txt = nil

        if asset.type ~= "text" then
            x, y, w, h = asset.quad:getViewport()
            mult = 2
        else
            txt = love.graphics.newText(font, asset.text)
            w, h = txt:getDimensions()
            mult = 1
        end

        local offset = {x=0,y=0}

        if asset.anchor.id == "tl" then offset = {x = w * mult, y = h * mult} 
        elseif asset.anchor.id == "t" then offset = {x = 0, y = h * mult} 
        elseif asset.anchor.id == "tr" then offset = {x = -w * mult, y = h * mult} 
        elseif asset.anchor.id == "r" then offset = {x = -w * mult, y = 0} 
        elseif asset.anchor.id == "br" then offset = {x = -w * mult, y = -h * mult} 
        elseif asset.anchor.id == "b" then offset = {x = 0, y = -h * mult} 
        elseif asset.anchor.id == "bl" then offset = {x = w * mult, y = -h * mult} 
        elseif asset.anchor.id == "l" then offset = {x = w * mult, y = 0} end

        asset.trueOffset = offset
        local scOffset = 1

        if asset.offset.scale then scOffset = asset.offset.scale end


        if asset.offset.x ~= 0 then offset.x = 0 end
        if asset.offset.y ~= 0 then offset.y = 0 end

        if asset.type ~= "text" then
            love.graphics.draw(asset.drawable, asset.quad, 
            
                asset.anchor.x + offset.x + (love.graphics.getWidth() / 100 * asset.offset.x) + asset.offset.pX, 
                asset.anchor.y + offset.y + (love.graphics.getHeight() / 100 * asset.offset.y) + asset.offset.pY, 

                0, 4 * scOffset, 4 * scOffset, w / 2, h / 2)
        else
            love.graphics.draw(txt, 
            
                asset.anchor.x + offset.x + (love.graphics.getWidth() / 100 * asset.offset.x) + asset.offset.pX, 
                asset.anchor.y + offset.y + (love.graphics.getHeight() / 100 * asset.offset.y) + asset.offset.pY, 

                0, 2 * scOffset, 2 * scOffset, w / 2, h / 2)
        end
    end
end

return Ui