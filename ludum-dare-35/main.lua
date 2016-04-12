
function love.load()
    testImage = love.graphics.newImage("assets/images/test.png")
    testSound = love.audio.newSource("assets/sounds/test.wav")
    love.graphics.setBackgroundColor(255, 255, 255)
end

function love.draw()
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.draw(testImage, 10, 10)
    --love.graphics.setColor(0, 255, 0, 255)
    --love.graphics.print("Press \"A\" to play noise!", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    
    gameutilities.printText("Press \"A\" to play noise!", {love.graphics.getWidth()/2, love.graphics.getHeight()/2}, {0,0,255,255});
    
    if (love.keyboard.isDown("a")) then
        love.audio.play(testSound)
    end
end