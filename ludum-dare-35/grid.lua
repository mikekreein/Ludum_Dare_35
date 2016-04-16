local kTokenSize = 30

local kShapes = {
    Shape.Create({{0,0}, {0,1}}), --vertical line
    Shape.Create({{0,0}, {1,0}}), --horizonal line
    Shape.Create({{0,0}, {0,1}, {1,1}}), --triangle 1
    Shape.Create({{0,0}, {1,0}, {1,1}}), --triangle 2
    Shape.Create({{0,0}, {0,1}, {1,1}, {1,0}}), --square
    Shape.Create({{0,0}, {1,1}, {0,2}, {-1,1}}), --diamond
}

local currentLevel = 1

GameGrid = { 
    tokens = {},
    selection = {1,1},
}
GameGrid.__index = GameGrid

function GameGrid:generate(width, height)
    self.tokens = {}
    
    -- Generate our board with starting shapes
    for x=1,width do
        self.tokens[x] = {}
        for y=1,height do
            local shape = nil
            self.tokens[x][y] = Token.Create(shape)
        end
    end
end

function GameGrid:draw()
    -- Draw our selection carets
    love.graphics.setColor(255, 0, 0, 128)
    love.graphics.rectangle("fill", 0, self.selection[2] * kTokenSize, love.graphics.getWidth(),kTokenSize)
    love.graphics.rectangle("fill", self.selection[1] * kTokenSize, 0, kTokenSize, love.graphics.getHeight())
    -- love.graphics.circle("fill", self.selection[1] * kTokenSize + (kTokenSize/2), self.selection[2] * kTokenSize+ (kTokenSize/2), (kTokenSize/2),100)
    
    -- Draw our token shapes
    for x=1,table.getn(self.tokens) do
        for y=1, table.getn(self.tokens[x]) do
            self.tokens[x][y]:draw(x, y, kTokenSize, kTokenSize)
        end
    end
end

function GameGrid:Shift(row, col, delta)
    if (row ~= nil) then
        if (delta < 0) then
            for y=1, table.getn(self.tokens[ self.selection[1]]) - 1 do
                if (self.tokens[ self.selection[1]][y].shape == nil) then
                    self.tokens[ self.selection[1]][y] = self.tokens[ self.selection[1]][y+1]
                    self.tokens[ self.selection[1]][y+1] = Token.Create()
                end
            end
        else 
            for y=table.getn(self.tokens[ self.selection[1]]), 2, -1 do
                if (self.tokens[ self.selection[1]][y].shape == nil) then
                    self.tokens[ self.selection[1]][y] = self.tokens[ self.selection[1]][y-1]
                    self.tokens[ self.selection[1]][y-1] = Token.Create()
                end
            end
        end
    else
        if (delta < 0) then
            for x=1,table.getn(self.tokens)- 1 do
                if (self.tokens[x][self.selection[2]].shape == nil) then
                    self.tokens[x][self.selection[2]] = self.tokens[ x + 1][self.selection[2]]
                    self.tokens[ x + 1][self.selection[2]] = Token.Create()
                end
            end
        else 
            for x=table.getn(self.tokens),2, -1 do
                if (self.tokens[x][self.selection[2]].shape == nil) then
                    self.tokens[x][self.selection[2]] = self.tokens[ x-1][self.selection[2]]
                    self.tokens[ x-1][self.selection[2]] = Token.Create()
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
                self.tokens[x][y] = self.tokens[x][y-1]
                self.tokens[x][y-1] = Token.Create()
            end
        end
    end
    
    for x=1,table.getn(self.tokens) do
        local shape = nil
        if (math.random(100) < 20 + currentLevel) then
          local shapeIndex = math.random(math.min(currentLevel,6))
          shape = kShapes[shapeIndex]
        end
        self.tokens[x][1] = Token.Create(shape)
    end
    self:SetSelection(nil, true, 1)
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
                
                    for i=1, table.getn(vertices) do
                        self.tokens[x + vertices[i][1]][y+vertices[i][2]] = Token.Create()
                    end
                    removedShape = true
                end
            end
        end
    end
    
    -- love.system.setClipboardText(debugLog)
    return removedShape
end