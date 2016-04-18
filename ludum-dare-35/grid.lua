kTokenSizeWidth = 30
kTokenSizeHeight = 30
kJuiciness_TokenShiftSpeed = 0.5
kJuiciness_TokenDisappearSpeed = 0.5
kJuiciness_ScoreDisappearSpeed = 2

local kShapes = {
    Shape.Create({{0,0}, {0,1}}), --vertical line
    Shape.Create({{0,0}, {1,0}}), --horizonal line
    Shape.Create({{0,0}, {0,1}, {1,1}}), --triangle 1
    Shape.Create({{0,0}, {0,1}, {1,1}, {1,0}}), --square
    Shape.Create({{0,0}, {1,0}, {1,1}}), --triangle 2
    Shape.Create({{0,0}, {1,1}, {0,2}, {-1,1}}), --diamond
    Shape.Create({{0,0}, {0,1}, {-1,1}}), --triangle 3
    Shape.Create({{0,0}, {1,1}, {1,2}, {-1,2}, {-1, 1}}), --house
    Shape.Create({{0,0}, {1,0}, {0,1}}), --triangle 4
    Shape.Create({{0,0}, {2,1}, {1,3}, {-1,3}, {-2, 1}}), --pentagon
    Shape.Create({{0,0}, {1,1}, {-1,1}}), --triangle 5
    
    
    -- Shape.Create({{0,0}, {50,10}, {10,30}}), --pentagon
}

GameGrid = { 
    tokens = {},
    selection = {x=1,y=1, nCol=0, eCol=0,sCol=0,wCol=0,},
    background = {colorR = 255, colorG = 255, colorB = 255},
    currentGoal = 2,
    currentProgress = 0,
    highestShape = 1,
    currentScore = 0,
    clearScore = 0,
}
GameGrid.__index = GameGrid

function GameGrid:generate(width, height)
    self.tokens = {}
    
    kTokenSizeWidth = love.graphics.getWidth() / width
    kTokenSizeHeight = love.graphics.getHeight() / height
    
    self.currentGoal = 2
    self.currentProgress = 0
    self.highestShape = 1
    self.currentScore = 0
    self.clearScore = 0
    
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
    love.graphics.setBackgroundColor(self.background.colorR, self.background.colorG, self.background.colorB)
    
    -- Draw our selection carets
    
    -- left selection
    if (self.selection.wCol > 0) then
        love.graphics.setColor(255, 0, 0, self.selection.wCol)
        love.graphics.rectangle("fill", 0, (self.selection.y-1) * kTokenSizeHeight, (self.selection.x-1) * kTokenSizeWidth,kTokenSizeHeight)
        love.graphics.polygon("fill", (self.selection.x-1) * kTokenSizeWidth, (self.selection.y-1) * kTokenSizeHeight, (self.selection.x-1) * kTokenSizeWidth + (kTokenSizeWidth/2), (self.selection.y-1) * kTokenSizeHeight+ (kTokenSizeHeight/2), (self.selection.x-1) * kTokenSizeWidth, (self.selection.y) * kTokenSizeHeight)
    end
    
    -- right selection
    if (self.selection.eCol > 0) then
        love.graphics.setColor(255, 0, 0, self.selection.eCol)
        love.graphics.rectangle("fill", (self.selection.x) * kTokenSizeWidth, (self.selection.y-1) * kTokenSizeHeight,  love.graphics.getWidth() -(self.selection.x) * kTokenSizeWidth,kTokenSizeHeight)
        love.graphics.polygon("fill", (self.selection.x) * kTokenSizeWidth, (self.selection.y-1) * kTokenSizeHeight, (self.selection.x) * kTokenSizeWidth - (kTokenSizeWidth/2), (self.selection.y-1) * kTokenSizeHeight+ (kTokenSizeHeight/2), (self.selection.x) * kTokenSizeWidth, (self.selection.y) * kTokenSizeHeight)
    end
    
    -- up selection
    if (self.selection.nCol > 0) then
        love.graphics.setColor(255, 0, 0, self.selection.nCol)
        love.graphics.rectangle("fill", (self.selection.x-1) * kTokenSizeWidth, 0, kTokenSizeWidth, (self.selection.y-1) * kTokenSizeHeight)
        love.graphics.polygon("fill", (self.selection.x-1) * kTokenSizeWidth, (self.selection.y-1) * kTokenSizeHeight, (self.selection.x-1) * kTokenSizeWidth + (kTokenSizeWidth/2), (self.selection.y-1) * kTokenSizeHeight+ (kTokenSizeHeight/2), (self.selection.x) * kTokenSizeWidth, (self.selection.y-1) * kTokenSizeHeight)
    end
    
    -- down selection
    if (self.selection.sCol > 0) then
        love.graphics.setColor(255, 0, 0, self.selection.sCol)
        love.graphics.rectangle("fill", (self.selection.x-1) * kTokenSizeWidth, (self.selection.y) * kTokenSizeHeight, kTokenSizeWidth, love.graphics.getHeight() - (self.selection.y) * kTokenSizeHeight)
        love.graphics.polygon("fill", (self.selection.x-1) * kTokenSizeWidth, (self.selection.y) * kTokenSizeHeight, (self.selection.x) * kTokenSizeWidth - (kTokenSizeWidth/2), (self.selection.y-1) * kTokenSizeHeight+ (kTokenSizeHeight/2), (self.selection.x) * kTokenSizeWidth, (self.selection.y) * kTokenSizeHeight)
    end
    
    --Draw our token connections
    self:DrawTokenConnections()
    
    -- Draw our token shapes
    for x=1,table.getn(self.tokens) do
        for y=1, table.getn(self.tokens[x]) do
            self.tokens[x][y]:draw(self.tokens[x][y].x, self.tokens[x][y].y, kTokenSizeWidth, kTokenSizeHeight)
        end
    end

end

function GameGrid:DrawTokenConnections()

    -- local debugLog = ""
    
    love.graphics.setColor(0, 0, 0, 255)
    local xOffset = kTokenSizeWidth / 2
    local yOffset = kTokenSizeHeight / 2
    for x=table.getn(self.tokens),1,-1 do
        for y=table.getn(self.tokens[x]),1,-1 do

            if (self.tokens[x][y].shape ~= nil) then
                local shape = self.tokens[x][y].shape
                local vertices = self.tokens[x][y].shape.vertices
                
                local vertIndex = 1
                local renderMatch = false
                while (vertIndex <= table.getn(vertices) and not renderMatch) do                
                
                
                    local renderLines = {}
                    local currentX = x
                    local currentY = y
                    local previousX = currentX
                    local previousY = currentY
                    
                    for i=vertIndex+1, table.getn(vertices)+1 do
                        local checkVertX = vertices[1][1] - vertices[vertIndex][1]
                        local checkVertY = vertices[1][2] - vertices[vertIndex][2]
                        if (i <= table.getn(vertices)) then
                            checkVertX = vertices[i][1] - vertices[vertIndex][1] 
                            checkVertY = vertices[i][2] - vertices[vertIndex][2] 
                        end
                        
                        currentX = x + checkVertX
                        currentY = y + checkVertY
                        
                        if ((currentX <= table.getn(self.tokens)) and (currentX >= 1) and
                            (currentY <= table.getn(self.tokens[1])) and (currentY >= 1) and
                            (self.tokens[currentX][currentY] ~= nil)) then
                            if (self.tokens[currentX][currentY].shape == shape) then
                                table.insert(renderLines, {(previousX-1) * kTokenSizeWidth + xOffset, (previousY-1) * kTokenSizeHeight + yOffset, (currentX-1) * kTokenSizeWidth + xOffset, (currentY-1) * kTokenSizeHeight + yOffset})
                                previousX = currentX
                                previousY = currentY
                            end
                        end
                    end

                    if (table.getn(renderLines) == table.getn(vertices)) then
                        love.graphics.setColor(255, 0, 0, 255)
                        love.graphics.setLineWidth( 5 )
                        renderMatch = true
                    else
                        love.graphics.setColor(0, 0, 0, 255)
                        love.graphics.setLineWidth( 1 )
                    end
                    
                    for i=1, table.getn(renderLines) do
                        love.graphics.line(renderLines[i])
                    end
                    vertIndex = vertIndex + 1
                end
            end
        end
    end
    love.graphics.setLineWidth( 1 )
end

function GameGrid:Shift(row, col, delta)
    local shiftedTokens = false
    if (row ~= nil) then
        if (delta < 0) then
            for y=1, table.getn(self.tokens[ self.selection.x]) - 1 do
                if (self.tokens[ self.selection.x][y].shape == nil and self.tokens[ self.selection.x][y+1].shape ~= nil) then
                    self.tokens[ self.selection.x][y].shape = self.tokens[ self.selection.x][y+1].shape
                    self.tokens[ self.selection.x][y+1].shape = nil
                    self.tokens[ self.selection.x][y].y = self.tokens[ self.selection.x][y+1].y
                    flux.to( self.tokens[ self.selection.x][y], kJuiciness_TokenShiftSpeed, { x = self.selection.x, y = y}):ease("linear")
                    flux.to(self.selection, kJuiciness_TokenShiftSpeed/2, {nCol = 128}):ease("linear"):after(self.selection, kJuiciness_TokenShiftSpeed/2, {nCol = 0})
                    shiftedTokens = true
                end
            end
        else 
            for y=table.getn(self.tokens[ self.selection.x]), 2, -1 do
                if (self.tokens[ self.selection.x][y].shape == nil and self.tokens[ self.selection.x][y-1].shape ~= nil) then
                    self.tokens[ self.selection.x][y].shape = self.tokens[ self.selection.x][y-1].shape
                    self.tokens[ self.selection.x][y-1].shape = nil
                    self.tokens[ self.selection.x][y].y = self.tokens[ self.selection.x][y-1].y
                    flux.to( self.tokens[ self.selection.x][y], kJuiciness_TokenShiftSpeed, { x = self.selection.x, y = y}):ease("linear")
                    flux.to(self.selection, kJuiciness_TokenShiftSpeed/2, {sCol = 128}):ease("linear"):after(self.selection, kJuiciness_TokenShiftSpeed/2, {sCol = 0})
                    shiftedTokens = true
                end
            end
        end
    else
        if (delta < 0) then
            for x=1,table.getn(self.tokens)- 1 do
                if (self.tokens[x][self.selection.y].shape == nil and self.tokens[ x + 1][self.selection.y].shape ~= nil) then
                    self.tokens[x][self.selection.y].shape = self.tokens[ x + 1][self.selection.y].shape
                    self.tokens[ x + 1][self.selection.y].shape = nil
                    self.tokens[x][self.selection.y].x = self.tokens[ x + 1][self.selection.y].x
                    flux.to( self.tokens[x][self.selection.y], kJuiciness_TokenShiftSpeed, { x = x, y = self.selection.y}):ease("linear")
                    flux.to(self.selection, kJuiciness_TokenShiftSpeed/2, {wCol = 128}):ease("linear"):after(self.selection, kJuiciness_TokenShiftSpeed/2, {wCol = 0})
                    shiftedTokens = true
                end
            end
        else 
            for x=table.getn(self.tokens),2, -1 do
                if (self.tokens[x][self.selection.y].shape == nil and self.tokens[ x-1][self.selection.y].shape ~= nil) then
                    self.tokens[x][self.selection.y].shape = self.tokens[ x-1][self.selection.y].shape
                    self.tokens[ x-1][self.selection.y].shape = nil
                    self.tokens[x][self.selection.y].x = self.tokens[ x - 1][self.selection.y].x
                    flux.to( self.tokens[x][self.selection.y], kJuiciness_TokenShiftSpeed, { x = x, y = self.selection.y}):ease("linear")
                    flux.to(self.selection, kJuiciness_TokenShiftSpeed/2, {eCol = 128}):ease("linear"):after(self.selection, kJuiciness_TokenShiftSpeed/2, {eCol = 0})
                    shiftedTokens = true
                end
            end
        end
    end
    
    return shiftedTokens
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
    

    local shapes = {}
    for x=1,table.getn(self.tokens) do
        if (x < self.highestShape+1) then
            local shapeIndex = math.random(math.min(self.highestShape, table.getn(kShapes)))
            table.insert(shapes, shapeIndex)
        else
            table.insert(shapes, 0)
        end
    end
    
    gameutilities.shuffle(shapes)
    
    for x=1,table.getn(self.tokens) do
        if (self.tokens[x][1].shape == nil) then
        local shape = nil
        if (shapes[x] ~= 0) then
            shape = kShapes[shapes[x]]
            -- shape = kShapes[math.random(math.min(highestShape, table.getn(kShapes)))]
        end
        self.tokens[x][1] = Token.Create(x, 1, shape)
        else
            return false
        end
    end

    return true
end

function GameGrid:FlashBackground(r, g, b)
    flux.to(self.background, kJuiciness_TokenDisappearSpeed/2, {colorR = r, colorG = g, colorB=b}):ease("linear"):after(self.background, kJuiciness_TokenDisappearSpeed/2, {colorR = 255, colorG = 255, colorB=255})
    
end

function GameGrid:SetSelection(x, y) 
    self.selection.x = math.floor(x / kTokenSizeWidth) + 1
    self.selection.y = math.floor(y / kTokenSizeHeight) + 1
    
    -- Clamp our selection so we don't go past our bounds
    self.selection.x = math.max(1, self.selection.x)
    self.selection.x = math.min(table.getn(self.tokens), self.selection.x)
    
    self.selection.y = math.max(1, self.selection.y)
    self.selection.y = math.min(table.getn(self.tokens[1]), self.selection.y)
end

function GameGrid:SetSelectionDelta(row, col, delta)
    if (row ~= nil) then
        self.selection.x = self.selection.x + delta
    else
        self.selection.y = self.selection.y + delta
    end
    
    -- Clamp our selection so we don't go past our bounds
    self.selection.x = math.max(1, self.selection.x)
    self.selection.x = math.min(table.getn(self.tokens), self.selection.x)
    
    self.selection.y = math.max(1, self.selection.y)
    self.selection.y = math.min(table.getn(self.tokens[1]), self.selection.y)
end

function GameGrid:Validate()
    -- Check if any of our tokens should be removed!
    local removedShapes = 0
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
                    -- local currentShape = 1
                    -- for i=1, table.getn(kShapes) do
                        -- if (kShapes[i] == self.tokens[x][y].shape) then
                            -- currentShape = i+1
                            -- break
                        -- end
                    -- end
                    
                    -- if (self.highestShape < currentShape) then
                        -- self.highestShape = currentShape
                    -- end
                    
                    for i=1, table.getn(vertices) do
                        -- flux.to( self.tokens[x + vertices[i][1]][y+vertices[i][2]], kJuiciness_TokenDisappearSpeed, { alpha = 0 }):ease("linear")
                        
                        flux.to( self.tokens[x + vertices[i][1]][y+vertices[i][2]], kJuiciness_TokenDisappearSpeed, { alpha = 0 }):ease("linear"):oncomplete(
                            function()
                                self.tokens[x + vertices[i][1]][y+vertices[i][2]] = Token.Create(x + vertices[i][1], y+vertices[i][2])
                            end
                        )
                                -- self.tokens[x + vertices[i][1]][y+vertices[i][2]] = Token.Create(x + vertices[i][1], y+vertices[i][2])
                    end
                    removedShapes = removedShapes + 1
                end
            end
        end
    end
    
    self.clearScore = (removedShapes*removedShapes) * 10
    self.currentScore = self.currentScore + self.clearScore
    
    if (removedShapes > 0) then
        self.currentProgress = self.currentProgress + removedShapes
        while (self.currentProgress >= self.currentGoal) do
            self.currentProgress = self.currentProgress - self.currentGoal
            self.highestShape = self.highestShape + 1
            self.currentGoal = self.currentGoal * 2
        end
        flux.to(self.background, kJuiciness_TokenDisappearSpeed/2, {colorR = 255, colorG = 133, colorB=127}):ease("linear"):after(self.background, kJuiciness_TokenDisappearSpeed/2, {colorR = 255, colorG = 255, colorB=255})
    end
    
    -- love.system.setClipboardText(debugLog)
    return (removedShapes > 0)
end