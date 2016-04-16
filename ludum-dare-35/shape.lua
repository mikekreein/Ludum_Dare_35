Shape = { 
    vertices = {}
}
Shape.__index = Shape

function Shape.Create(vertices)
  local self = { }
  setmetatable(self, Shape)
  self.vertices = vertices
  return self
end

function Shape:render(posx, posy, width, height)
    -- Scale the lines and center them inside height and width restrictions

    local minX = 1000000
    local maxX = -1000000
    local minY = 1000000
    local maxY = -1000000
    for x=1,table.getn(self.vertices) do
        minX = math.min(minX, self.vertices[x][1])
        maxX = math.max(maxX, self.vertices[x][1])
        
        minY = math.min(minY, self.vertices[x][2])
        maxY = math.max(maxY, self.vertices[x][2])
    end

    local border = width / 4
    love.graphics.setColor(0, 0, 0, 255)
    
    
    local scaledAnchorX = (posx*width) + border
    local scaledAnchorY = (posy*height) + border
    local scaledWidth = (width - (2*border))/math.max(1,(maxX - minX))
    local scaledHeight = (height - (2*border))/math.max(1,(maxY - minY))
    for x=1,table.getn(self.vertices)-1 do
        local v1x = (self.vertices[x][1]*scaledWidth)
        local v1y = (self.vertices[x][2]*scaledHeight)
        local v2x = (self.vertices[x+1][1]*scaledWidth)
        local v2y = (self.vertices[x+1][2]*scaledHeight)
        love.graphics.line(scaledAnchorX + v1x, scaledAnchorY + v1y, scaledAnchorX + v2x, scaledAnchorY + v2y)
    end
    local v1x = (self.vertices[1][1]*scaledWidth)
    local v1y = (self.vertices[1][2]*scaledHeight)
    local v2x = (self.vertices[table.getn(self.vertices)][1]*scaledWidth)
    local v2y = (self.vertices[table.getn(self.vertices)][2]*scaledHeight)
    love.graphics.line(scaledAnchorX + v1x, scaledAnchorY + v1y, scaledAnchorX + v2x, scaledAnchorY + v2y)
    
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.circle("line", (posx*width) + (width/2), (posy*height) + (height/2), width/2)
end

function Shape:validate() 
    love.graphics.line(self.x*30, self.y*30, self.x*30 + 5, self.y*30 + 5)
end