Shape = { 
    vertices = {},
}
Shape.__index = Shape

function Shape.Create(vertices)
  local self = { }
  setmetatable(self, Shape)
  self.vertices = vertices
  return self
end

function Shape:render(posx, posy, width, height, alpha, scale)
    -- Scale the lines and center them inside height and width restrictions

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.circle("fill", (posx*width) + (width/2), (posy*height) + (height/2), width/3)
    
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
    
    local borderWidth = width / 4
    local borderHeight = height / 4
    love.graphics.setColor(0, 0, 0, alpha)
    
    local maxWidth = math.max(maxX-minX,maxY-minY)
    local divX = 2--math.max((maxX-minX), 1.5)
    local divY = 2--math.max((maxY-minY), maxWidth)
    
    local scaledAnchorX = (posx*width) + (scale/divX * borderWidth)
    local scaledAnchorY = (posy*height) + (scale/divY * borderHeight)
    -- local scaledAnchorX = (posx*width) + ((scale/2 * border) * (((maxX-minX / maxWidth))))
    -- local scaledAnchorY = (posy*height) + ((scale/2 * border) * (((maxY-minY / maxWidth))))
    local scaledWidth = (width - (scale*borderWidth))/math.max(1,(maxX - minX))
    local scaledHeight = (height - (scale*borderHeight))/math.max(1,(maxY - minY))
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
    
    love.graphics.setColor(0, 0, 0, alpha / 2)
    love.graphics.circle("line", (posx*width) + (width/2), (posy*height) + (height/2), width/3)
end

function Shape:validate() 
    love.graphics.line(self.x*30, self.y*30, self.x*30 + 5, self.y*30 + 5)
end