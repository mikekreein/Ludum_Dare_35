gameutilities = { }

function gameutilities.printText(text, position, color) 
    if (color ~= nil) then
        love.graphics.setColor(color[1], color[2], color[3], color[4])
    end
    love.graphics.print(text, position[1], position[2])
end