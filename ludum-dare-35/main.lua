local selection = {0, 0}
local textDirections = { x = 10, y = 10, alpha = 255, str = "MOUSE BUTTONS / MOUSE WHEEL to shift shapes\n\nShift shapes into shapes\n\nMIDDLE MOUSE to score" }

function love.load()
    math.randomseed(os.time())

    testImage = love.graphics.newImage("assets/images/test.png")
    testSound = love.audio.newSource("assets/sounds/test.wav")
    
    -- sfxClearShape = love.audio.newSource("assets/sounds/sfx_clearshape.wav")
    -- sfxAddRow = love.audio.newSource("assets/sounds/sfx_addrow.wav")
    
    
    love.graphics.setBackgroundColor(255, 255, 255)

    -- GameGrid:generate((love.graphics.getWidth() / 30)-1, (love.graphics.getHeight() / 30)-2)
    GameGrid:generate(8, 6)
    GameGrid:AddRow()
    GameGrid:AddRow()
    
    local speed = 2.5
    flux.to( textDirections, speed, { alpha = 64 }):ease("linear"):after(textDirections, speed, { alpha = 255 }):ease("linear"):after(textDirections, speed, { alpha = 64 })
    :after(textDirections, speed, { alpha = 255 }):ease("linear"):after(textDirections, speed, { alpha = 0 })
    
end

function love.draw()
    
    love.graphics.setColor(0,0,0, textDirections.alpha)
    love.graphics.print (textDirections.str, textDirections.x, textDirections.y)
    
    --love.graphics.setColor(0, 255, 0, 255)
    --love.graphics.draw(testImage, 10, 10)
    --love.graphics.setColor(0, 255, 0, 255)
    --love.graphics.print("Press \"A\" to play noise!", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    
    -- gameutilities.printText("Press \"A\" to play noise!", {love.graphics.getWidth()/2, love.graphics.getHeight()/2}, {0,0,255,255});
    
    -- if (love.keyboard.isDown("a")) then
       -- GameGrid:Shift(1, nil, -1)
       -- love.audio.play(testSound)
    -- end
    
    GameGrid:draw()
end

function love.update(dt)
  flux.update(dt)
  
  
end

function love.mousemoved( x, y, dx, dy )
    GameGrid:SetSelection(x, y)
end

function love.wheelmoved(x, y)
    if (y > 0) then
        GameGrid:Shift(true, nil, -1)
    else
        GameGrid:Shift(true, nil, 1)
    end
end

function love.mousepressed(x, y, button)
   if (button == 1) then
        GameGrid:Shift(nil, true, -1)
    elseif (button == 2) then
        GameGrid:Shift(nil, true, 1)
    elseif (button == 3) then
        if (GameGrid:Validate()) then
            
            -- love.audio.play(sfxClearShape)
            -- love.audio.play(sfxAddRow)
            local timer = {x =0}
            flux.to(timer, kJuiciness_TokenDisappearSpeed+0.1, {x = 1}):ease("linear"):oncomplete(
                function()
                    GameGrid:AddRow()
                end)
        else
            -- love.audio.play(sfxAddRow)
            GameGrid:AddRow()
        end
   end
end

function love.keypressed(key) 
    if (key == "space") then
        love.audio.play(sfxAddRow)
        GameGrid:AddRow()
    elseif (key == "up") then
        GameGrid:Shift(true, nil, -1)
    elseif (key =="down") then
        GameGrid:Shift(true, nil, 1)
    elseif (key =="left") then
        GameGrid:Shift(nil, true, -1)
    elseif (key =="right") then
        GameGrid:Shift(nil, true, 1)
    elseif (key == "w") then
        GameGrid:SetSelectionDelta(nil, true, -1)
    elseif (key =="s") then
        GameGrid:SetSelectionDelta(nil, true, 1)
    elseif (key =="a") then
        GameGrid:SetSelectionDelta(true, nil, -1)
    elseif (key =="d") then
        GameGrid:SetSelectionDelta(true, nil, 1)
    elseif (key == "escape") then 
        os.exit() 
    elseif (key == "lshift" or key == "rshift") then
    -- local timer = {x =0}
    -- flux.to(timer, 1, {x = 1}):ease("linear"):oncomplete(
        -- function()
        if (GameGrid:Validate()) then
            
            love.audio.play(sfxClearShape)
            love.audio.play(sfxAddRow)
            local timer = {x =0}
            flux.to(timer, kJuiciness_TokenDisappearSpeed+0.1, {x = 1}):ease("linear"):oncomplete(
                function()
                    GameGrid:AddRow()
                end)
        else
            love.audio.play(sfxAddRow)
            GameGrid:AddRow()
        end
        -- end)
    end
end