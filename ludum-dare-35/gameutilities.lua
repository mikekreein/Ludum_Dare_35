gameutilities = { }

function gameutilities.printText(text, position, color) 
    if (color ~= nil) then
        love.graphics.setColor(color[1], color[2], color[3], color[4])
    end
    love.graphics.print(text, position[1], position[2])
end

function gameutilities.deepcopy(orig) 
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[gameutilities.deepcopy(orig_key)] = gameutilities.deepcopy(orig_value)
        end
        setmetatable(copy, gameutilities.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function gameutilities.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function gameutilities.swap(array, index1, index2)
    array[index1], array[index2] = array[index2], array[index1]
end

function gameutilities.shuffle(array)
    local counter = #array
    while counter > 1 do
        local index = math.random(counter)
        gameutilities.swap(array, index, counter)
        counter = counter - 1
    end
end