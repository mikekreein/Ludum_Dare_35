local selection = {0, 0}
local textDirections = { alpha = 255, str = "MOUSE BUTTONS / MOUSE WHEEL / WASD to shift circles\n\nMIDDLE MOUSE / SHIFT / SPACE to advance\n\nShift circles into shapes\nDon't let them stack up!" }
local textGameOver = { alpha = 0, str = "\n\nGame Over\n\nPress any keyboard button to start a new game" }
local textScore = {alpha = 0}
local textClearScore = {alpha = 0}
local gameState = "Main"

function love.load()
    math.randomseed(os.time())

    sfxClearShape = love.audio.newSource("assets/sounds/sfx_clearshape.wav")
    sfxAddRow = love.audio.newSource("assets/sounds/sfx_addrow.wav")
    sfxShift = love.audio.newSource("assets/sounds/sfx_shift.wav")
    sfxShiftFail = love.audio.newSource("assets/sounds/sfx_shiftfail.wav")
    sfxDefeat = love.audio.newSource("assets/sounds/sfx_defeat.wav")
    sfxStart = love.audio.newSource("assets/sounds/sfx_start.wav")

    love.graphics.setBackgroundColor(255, 255, 255)

    startgame()
    -- flux.to( textDirections, speed, { alpha = 64 }):ease("linear"):after(textDirections, speed, { alpha = 255 }):ease("linear"):after(textDirections, speed, { alpha = 64 })
    -- :after(textDirections, speed, { alpha = 255 }):ease("linear"):after(textDirections, speed, { alpha = 0 })
    flux.to( textDirections, 10, { alpha = 255 }):ease("linear"):after(textDirections, 2, { alpha = 0 }):ease("linear")
    
end

function love.draw()

    
    -- love.graphics.printf (textDirections.str, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 'center')
    GameGrid:draw()
    
    if (textDirections.alpha > 0) then
        love.graphics.setNewFont("assets/fonts/TitanOne-Regular.ttf", 32)
        love.graphics.setColor(0,0,0, textDirections.alpha)
        love.graphics.printf (textDirections.str, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 'center')
    end
    if (textGameOver.alpha > 0) then
        love.graphics.setNewFont("assets/fonts/TitanOne-Regular.ttf", 32)
        love.graphics.setColor(0,0,0, textGameOver.alpha)
        love.graphics.printf (textGameOver.str, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 'center')
    end
    if (textScore.alpha > 0) then
        love.graphics.setNewFont("assets/fonts/TitanOne-Regular.ttf", 128)
        love.graphics.setColor(0,0,0, textScore.alpha)
        love.graphics.printf (GameGrid.currentScore, 0, love.graphics.getHeight()/3, love.graphics.getWidth(), 'center')
    end
    
    if (textClearScore.alpha > 0) then
        love.graphics.setColor(0,0,0, textClearScore.alpha)
        love.graphics.setNewFont("assets/fonts/TitanOne-Regular.ttf", 64)
        love.graphics.printf ("+"..GameGrid.clearScore, 0, love.graphics.getHeight()/4, love.graphics.getWidth(), 'center')
    end
end

function startgame()
-- GameGrid:generate((love.graphics.getWidth() / 30)-1, (love.graphics.getHeight() / 30)-2)
    GameGrid:generate(8, 6)
    GameGrid:AddRow()
    GameGrid:AddRow()
    gameState = "Main"
    
    flux.to( textGameOver, 1, { alpha = 0 }):ease("linear"):after( textGameOver, 1, { alpha = 0 }):ease("linear")
    flux.to( textScore, 1, { alpha = 0 }):ease("linear"):after( textScore, 1, { alpha = 0 }):ease("linear")
    flux.to( textClearScore, 1, { alpha = 0 }):ease("linear"):after( textClearScore, 1, { alpha = 0 }):ease("linear")
    
    love.audio.play(sfxStart)
end

function love.update(dt)
  flux.update(dt)
  
  
end

function love.mousemoved( x, y, dx, dy )
    GameGrid:SetSelection(x, y)
end

function advancegame() 
    if (GameGrid:AddRow()) then
        love.audio.play(sfxAddRow)
    else
        love.audio.play(sfxDefeat)
        gameState = "GameOver"
        flux.to( textGameOver, 1, { alpha = 255 }):ease("linear"):after( textGameOver, 5, { alpha = 255 }):ease("linear")
        flux.to( textScore, 1, { alpha = 255 }):ease("linear"):after( textScore, 5, { alpha = 255 }):ease("linear")
        flux.to( textClearScore, 1, { alpha = 0 }):ease("linear"):after( textClearScore, 5, { alpha = 0 }):ease("linear")
    end
end

function love.wheelmoved(x, y)
    if (gameState == "Main") then
        if (y > 0) then
            if (GameGrid:Shift(true, nil, -1)) then
                love.audio.play(sfxShift)
            else
                love.audio.play(sfxShiftFail)
            end
        else
            if (GameGrid:Shift(true, nil, 1)) then
                love.audio.play(sfxShift)
            else
                love.audio.play(sfxShiftFail)
            end
        end
    end
end

function love.mousepressed(x, y, button)
    if (gameState == "Main") then
       if (button == 1) then
            if (GameGrid:Shift(nil, true, -1)) then
                love.audio.play(sfxShift)
            else
                love.audio.play(sfxShiftFail)
            end
        elseif (button == 2) then
            if (GameGrid:Shift(nil, true, 1)) then
                love.audio.play(sfxShift)
            else
                love.audio.play(sfxShiftFail)
            end
        elseif (button == 3) then
            if (GameGrid:Validate()) then
                GameGrid:FlashBackground(255, 133, 127)
                love.audio.play(sfxClearShape)
                local timer = {x =0}
                flux.to(timer, kJuiciness_TokenDisappearSpeed+0.1, {x = 1}):ease("linear"):oncomplete(
                    function()
                        advancegame() 
                    end)
                flux.to( textClearScore, kJuiciness_TokenDisappearSpeed, { alpha = 192 }):ease("linear"):after(textClearScore, kJuiciness_ScoreDisappearSpeed, { alpha = 0 }):ease("linear")
                flux.to( textScore, kJuiciness_TokenDisappearSpeed * 2, { alpha = 192 }):ease("linear"):after(textScore, kJuiciness_ScoreDisappearSpeed, { alpha = 0 }):ease("linear")
            else
                GameGrid:FlashBackground(192, 192, 192)
                advancegame() 
            end
       end
   end
end

function love.keypressed(key) 
   if (gameState == "Main") then
       if (key == "lshift" or key == "rshift" or key == "space") then
            if (GameGrid:Validate()) then
                love.audio.play(sfxClearShape)
                local timer = {x =0}
                flux.to(timer, kJuiciness_TokenDisappearSpeed+0.1, {x = 1}):ease("linear"):oncomplete(
                    function()
                        advancegame() 
                    end)
                flux.to( textClearScore, kJuiciness_TokenDisappearSpeed, { alpha = 192 }):ease("linear"):after(textClearScore, kJuiciness_ScoreDisappearSpeed, { alpha = 0 }):ease("linear")
                flux.to( textScore, kJuiciness_TokenDisappearSpeed * 2, { alpha = 192 }):ease("linear"):after(textScore, kJuiciness_ScoreDisappearSpeed, { alpha = 0 }):ease("linear")
            else
                GameGrid:FlashBackground(192, 192, 192)
                advancegame() 
            end
        elseif (key == "up" or key == "w") then
            if (GameGrid:Shift(true, nil, -1)) then
                love.audio.play(sfxShift)
            else
                love.audio.play(sfxShiftFail)
            end
        elseif (key =="down" or key =="s") then
            if (GameGrid:Shift(true, nil, 1)) then
                love.audio.play(sfxShift)
            else
                love.audio.play(sfxShiftFail)
            end
        elseif (key =="left" or key =="a") then
            if (GameGrid:Shift(nil, true, -1)) then
                love.audio.play(sfxShift)
            else
                love.audio.play(sfxShiftFail)
            end
        elseif (key =="right" or key =="d") then
            if (GameGrid:Shift(nil, true, 1)) then
                love.audio.play(sfxShift)
            else
                love.audio.play(sfxShiftFail)
            end
        elseif (key == "escape") then 
            os.exit() 
        end
    elseif (gameState == "GameOver") then
        startgame()
    end
end