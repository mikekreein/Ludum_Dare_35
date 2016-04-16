kTokenSizeWidth = 30
kTokenSizeHeight = 30
kJuiciness_TokenShiftSpeed = 0.5
kJuiciness_TokenDisappearSpeed = 0.5

local kShapes = {
    Shape.Create({{0,0}, {0,1}}), --vertical line
    Shape.Create({{0,0}, {1,0}}), --horizonal line
    Shape.Create({{0,0}, {0,1}, {1,1}}), --triangle 1
    Shape.Create({{0,0}, {1,0}, {1,1}}), --triangle 2
    Shape.Create({{0,0}, {0,1}, {-1,1}}), --triangle 3
    Shape.Create({{0,0}, {1,0}, {0,1}}), --triangle 4
    Shape.Create({{0,0}, {1,1}, {-1,1}}), --triangle 5
    Shape.Create({{0,0}, {0,1}, {1,1}, {1,0}}), --square
    Shape.Create({{0,0}, {1,1}, {0,2}, {-1,1}}), --diamond
    Shape.Create({{0,0}, {1,1}, {1,2}, {-1,2}, {-1, 1}}), --house
    -- Shape.Create({{0,0}, {2,1}, {1,3}, {-1,3}, {-2, 1}}), --pentagon
}

local currentLevel = 1
local highestShape = 1

GameGrid = { 
    tokens = {},
    selection = {1,1},
}
GameGrid.__index = GameGrid

function GameGrid:generate(width, height)
    self.tokens = {}
    
    kTokenSizeWidth = love.graphics.getWidth() / width
    kTokenSizeHeight = love.graphics.getHeight() / height
    -- Generate our board with starting shapes
    for x=1,width do
        self.tokens[x] = {}
        for y=1,height do
            local shape = nil
            -- if (math.random(100) < 25) then
                -- shape = kShapes[math.random(table.getn(kShapes))]
            -- end
            self.tokens[x][y] = Token.Create(x, y, shape)
            
        end
    end
end

function GameGrid:draw()
    -- Draw our selection carets
    love.graphics.setColor(255, 0, 0, 128)
    love.graphics.rectangle("fill", 0, (self.selection[2]-1) * kTokenSizeHeight, love.graphics.getWidth(),kTokenSizeHeight)
    love.graphics.rectangle("fill", (self.selection[1]-1) * kTokenSizeWidth, 0, kTokenSizeWidth, love.graphics.getHeight())
    -- love.graphics.circle("fill", self.selection[1] * kTokenSize + (kTokenSize/2), self.selection[2] * kTokenSize+ (kTokenSize/2), (kTokenSize/2),100)
    
    --Draw our token connections
    self:DrawTokenConnections()
    
    -- Draw our token shapes
    for x=1,table.getn(self.tokens) do
        for y=1, table.getn(self.tokens[x]) do
            self.tokens[x][y]:draw(self.tokens[x][y].x, self.tokens[x][y].y, kTokenSizeWidth, kTokenSizeHeight)
            -- self.tokens[x][y]:draw(x, y, kTokenSize, kTokenSize)
        end
    end

end

function GameGrid:DrawTokenConnections()
    -- Check if any of our tokens should be removed!
    local removedShape = false
    -- local debugLog = ""
    
    love.graphics.setColor(0, 0, 0, 255)
    local xOffset = kTokenSizeWidth / 2
    local yOffset = kTokenSizeHeight / 2
    for x=1,table.getn(self.tokens) do
        for y=1, table.getn(self.tokens[x]) do

            if (self.tokens[x][y].shape ~= nil) then
                local shape = self.tokens[x][y].shape
                local vertices = self.tokens[x][y].shape.vertices
                for i=1, table.getn(vertices) do
                    for j=1, table.getn(vertices) do
                        local xoff = vertices[i][1] - vertices[j][1]
                        local yoff = vertices[i][2] - vertices[j][2]
                        if (((x+ xoff) <= table.getn(self.tokens)) and ((x+ xoff) >= 1) and
                            ((y+ yoff) <= table.getn(self.tokens[1])) and ((y+ yoff) >= 1) and
                            (self.tokens[x + xoff][y+yoff] ~= nil)) then
                            if (self.tokens[x + xoff][y+yoff].shape == shape) then
                                love.graphics.line((x-1) * kTokenSizeWidth + xOffset, (y-1) * kTokenSizeHeight + yOffset, ((x-1) + xoff) * kTokenSizeWidth + xOffset, ((y-1) + yoff) * kTokenSizeHeight + yOffset)
                            end
                        end
                    
                        -- if (((x+ vertices[i][1]) <= table.getn(self.tokens)) and ((x+ vertices[i][1]) >= 1) and
                            -- ((y+ vertices[i][2]) <= table.getn(self.tokens[1])) and ((y+ vertices[i][2]) >= 1) and
                            -- (self.tokens[x + vertices[i][1]][y+vertices[i][2]] ~= nil)) then
                            -- if (self.tokens[x + vertices[i][1]][y+vertices[i][2]].shape == shape) then
                                -- love.graphics.line(x * kTokenSize + offset, y * kTokenSize + offset, (x + vertices[i][1]) * kTokenSize + offset, (y + vertices[i][2]) * kTokenSize + offset)
                            -- end
                        -- elseif (((x- vertices[i][1]) <= table.getn(self.tokens)) and ((x- vertices[i][1]) >= 1) and
                                -- ((y- vertices[i][2]) <= table.getn(self.tokens[1])) and ((y- vertices[i][2]) >= 1) and
                            -- (self.tokens[x - vertices[i][1]][y-vertices[i][2]] ~= nil)) then
                            -- if (self.tokens[x - vertices[i][1]][y-vertices[i][2]].shape == shape) then
                                -- love.graphics.line(x * kTokenSize + offset, y * kTokenSize + offset, (x - vertices[i][1]) * kTokenSize + offset, (y - vertices[i][2]) * kTokenSize + offset)
                            -- end
                        -- end
                    end
                end
                
            end
        end
    end
    
    -- love.system.setClipboardText(debugLog)
    return removedShape
end

function GameGrid:Shift(row, col, delta)
    if (row ~= nil) then
        if (delta < 0) then
            for y=1, table.getn(self.tokens[ self.selection[1]]) - 1 do
                if (self.tokens[ self.selection[1]][y].shape == nil) then
                    -- self.tokens[ self.selection[1]][y] = self.tokens[ self.selection[1]][y+1]
                    -- self.tokens[ self.selection[1]][y+1] = Token.Create(self.selection[1],y+1)
                    self.tokens[ self.selection[1]][y].shape = self.tokens[ self.selection[1]][y+1].shape
                    self.tokens[ self.selection[1]][y+1].shape = nil
                    self.tokens[ self.selection[1]][y].y = self.tokens[ self.selection[1]][y+1].y
                    flux.to( self.tokens[ self.selection[1]][y], kJuiciness_TokenShiftSpeed, { x = self.selection[1], y = y}):ease("linear")

                end
            end
        else 
            for y=table.getn(self.tokens[ self.selection[1]]), 2, -1 do
                if (self.tokens[ self.selection[1]][y].shape == nil) then
                    -- self.tokens[ self.selection[1]][y] = self.tokens[ self.selection[1]][y-1]
                    -- self.tokens[ self.selection[1]][y-1] = Token.Create(self.selection[1],y-1)
                    self.tokens[ self.selection[1]][y].shape = self.tokens[ self.selection[1]][y-1].shape
                    self.tokens[ self.selection[1]][y-1].shape = nil
                    self.tokens[ self.selection[1]][y].y = self.tokens[ self.selection[1]][y-1].y
                    flux.to( self.tokens[ self.selection[1]][y], kJuiciness_TokenShiftSpeed, { x = self.selection[1], y = y}):ease("linear")
                end
            end
        end
    else
        if (delta < 0) then
            for x=1,table.getn(self.tokens)- 1 do
                if (self.tokens[x][self.selection[2]].shape == nil) then
                    -- self.tokens[x][self.selection[2]] = self.tokens[ x + 1][self.selection[2]]
                    -- self.tokens[ x + 1][self.selection[2]] = Token.Create(x + 1, self.selection[2])
                    self.tokens[x][self.selection[2]].shape = self.tokens[ x + 1][self.selection[2]].shape
                    self.tokens[ x + 1][self.selection[2]].shape = nil
                    self.tokens[x][self.selection[2]].x = self.tokens[ x + 1][self.selection[2]].x
                    flux.to( self.tokens[x][self.selection[2]], kJuiciness_TokenShiftSpeed, { x = x, y = self.selection[2]}):ease("linear")
                end
            end
        else 
            for x=table.getn(self.tokens),2, -1 do
                if (self.tokens[x][self.selection[2]].shape == nil) then
                    -- self.tokens[x][self.selection[2]] = self.tokens[ x-1][self.selection[2]]
                    -- self.tokens[ x-1][self.selection[2]] = Token.Create(x-1, self.selection[2])
                    self.tokens[x][self.selection[2]].shape = self.tokens[ x-1][self.selection[2]].shape
                    self.tokens[ x-1][self.selection[2]].shape = nil
                    self.tokens[x][self.selection[2]].x = self.tokens[ x - 1][self.selection[2]].x
                    flux.to( self.tokens[x][self.selection[2]], kJuiciness_TokenShiftSpeed, { x = x, y = self.selection[2]}):ease("linear")
                end
            end
        end
    end
end

function GameGrid:AddRow()
    -- Shift all existing tokens down one row!
     for x=1,table.getn(self.tokens) do
        for y=table.getn(self.tokens[x]), 2, -1 do
            if (self.tokens[x][y].shape == nil) then
                self.tokens[x][y].shape = self.tokens[x][y-1].shape
                self.tokens[x][y].y = self.tokens[x][y-1].y
                flux.to( self.tokens[x][y], kJuiciness_TokenShiftSpeed, { x = x, y = y}):ease("linear")
                self.tokens[x][y-1] = Token.Create(x, y-1)
            end
        end
    end
    
    for x=1,table.getn(self.tokens) do
        local shape = nil
        if (math.random(100) < 20 + currentLevel) then
          local shapeIndex = math.random(math.min(highestShape, table.getn(kShapes)))
          shape = kShapes[shapeIndex]
        end
        self.tokens[x][1] = Token.Create(x, 1, shape)
    end
    -- self:SetSelection(nil, true, 1)
    currentLevel = currentLevel + 1
end

function GameGrid:SetSelection(row, col, delta)
    if (row ~= nil) then
        self.selection[1] = self.selection[1] + delta
    else
        self.selection[2] = self.selection[2] + delta
    end
    
    -- Clamp our selection so we don't go past our bounds
    self.selection[1] = math.max(1, self.selection[1])
    self.selection[1] = math.min(table.getn(self.tokens), self.selection[1])
    
    self.selection[2] = math.max(1, self.selection[2])
    self.selection[2] = math.min(table.getn(self.tokens[1]), self.selection[2])
end

function GameGrid:Validate()
    -- Check if any of our tokens should be removed!
    local removedShape = false
    -- local debugLog = ""
    for x=1,table.getn(self.tokens) do
        for y=1, table.getn(self.tokens[x]) do

            if (self.tokens[x][y].shape ~= nil) then
                local shape = self.tokens[x][y].shape
                local vertices = self.tokens[x][y].shape.vertices
                local shapesToRemove = {}
                for i=1, table.getn(vertices) do
                    if (((x+ vertices[i][1]) <= table.getn(self.tokens)) and ((x+ vertices[i][1]) >= 1) and
                        ((y+ vertices[i][2]) <= table.getn(self.tokens[1])) and ((y+ vertices[i][2]) >= 1) and
                        (self.tokens[x + vertices[i][1]][y+vertices[i][2]] ~= nil)) then
                        if (self.tokens[x + vertices[i][1]][y+vertices[i][2]].shape == shape) then
                            table.insert(shapesToRemove, self.tokens[x + vertices[i][1]][y + vertices[i][2]])
                        else
                            break
                        end
                    end
                end
                -- debugLog = debugLog .. table.getn(shapesToRemove) .. " " .. table.getn(vertices) .. "\n"
                if (table.getn(shapesToRemove) == table.getn(vertices)) then
                    local currentShape = 1
                    for i=1, table.getn(kShapes) do
                        if (kShapes[i] == self.tokens[x][y].shape) then
                            currentShape = i+1
                            break
                        end
                    end
                    
                    if (highestShape < currentShape) then
                        highestShape = currentShape
                    end
                    
                    for i=1, table.getn(vertices) do
                        -- flux.to( self.tokens[x + vertices[i][1]][y+vertices[i][2]], kJuiciness_TokenDisappearSpeed, { alpha = 0 }):ease("linear")
                        
                        flux.to( self.tokens[x + vertices[i][1]][y+vertices[i][2]], kJuiciness_TokenDisappearSpeed, { alpha = 0 }):ease("linear"):oncomplete(
                            function()
                                self.tokens[x + vertices[i][1]][y+vertices[i][2]] = Token.Create(x + vertices[i][1], y+vertices[i][2])
                            end
                        )
                                -- self.tokens[x + vertices[i][1]][y+vertices[i][2]] = Token.Create(x + vertices[i][1], y+vertices[i][2])
                    end
                    removedShape = true
                end
            end
        end
    end
    
    -- love.system.setClipboardText(debugLog)
    return removedShape
end