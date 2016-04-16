local selection = {0, 0}

function love.load()
    testImage = love.graphics.newImage("assets/images/test.png")
    testSound = love.audio.newSource("assets/sounds/test.wav")
    
    sfxClearShape = love.audio.newSource("assets/sounds/sfx_clearshape.wav")
    sfxAddRow = love.audio.newSource("assets/sounds/sfx_addrow.wav")
    
    
    love.graphics.setBackgroundColor(255, 255, 255)
    
    -- GameGrid:generate((love.graphics.getWidth() / 30)-1, (love.graphics.getHeight() / 30)-2)
    GameGrid:generate(12, 8)
    GameGrid:AddRow()
    GameGrid:AddRow()
end

function love.draw()
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
        GameGrid:SetSelection(nil, true, -1)
    elseif (key =="s") then
        GameGrid:SetSelection(nil, true, 1)
    elseif (key =="a") then
        GameGrid:SetSelection(true, nil, -1)
    elseif (key =="d") then
        GameGrid:SetSelection(true, nil, 1)
    elseif (key == "escape") then 
        os.exit() 
    end
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
    end
        -- end)
end