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
    
    local maxDimension = math.max(maxX-minX,maxY-minY)
    -- local total = (maxX-minX+maxY-minY)
    -- local divX = (maxX-minX) / total
    -- local divY = (maxY-minY) / total
    -- local highestDiv = math.max(divX, divY)

    local scaledWidth = (borderWidth / maxDimension)
    local scaledHeight = (borderHeight / maxDimension)
    local pointSize = (math.max(scaledWidth, scaledHeight)/3)
    
    local scaledAnchorX = (posx*width) + (width/2) - (scaledWidth * (maxX-minX)/2)
    local scaledAnchorY = (posy*height) + (height/2) - (scaledHeight * (maxY-minY)/2)
    
    for x=1,table.getn(self.vertices)-1 do
        local v1x = (((self.vertices[x][1]-minX) )*scaledWidth)
        local v1y = (((self.vertices[x][2]-minY) )*scaledHeight)
        local v2x = (((self.vertices[x+1][1]-minX) )*scaledWidth)
        local v2y = (((self.vertices[x+1][2]-minY) )*scaledHeight)
        
        love.graphics.setColor(0, 0, 0, alpha)
        love.graphics.line(scaledAnchorX + v1x, scaledAnchorY + v1y, scaledAnchorX + v2x, scaledAnchorY + v2y)
    
        
        love.graphics.setColor(0, 0, 0, alpha/4)
        love.graphics.circle("line", scaledAnchorX + v1x, scaledAnchorY + v1y, pointSize)
    end
    local v1x = (((self.vertices[1][1]-minX) )*scaledWidth)
    local v1y = (((self.vertices[1][2]-minY) )*scaledHeight)
    local v2x = (((self.vertices[table.getn(self.vertices)][1]-minX) )*scaledWidth)
    local v2y = (((self.vertices[table.getn(self.vertices)][2]-minY) )*scaledHeight)
    
    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.line(scaledAnchorX + v1x, scaledAnchorY + v1y, scaledAnchorX + v2x, scaledAnchorY + v2y)
    love.graphics.setColor(0, 0, 0, alpha/4)
    love.graphics.circle("line", scaledAnchorX + v2x, scaledAnchorY + v2y, pointSize)
    
    love.graphics.setColor(0, 0, 0, alpha / 2)
    love.graphics.circle("line", (posx*width) + (width/2), (posy*height) + (height/2), width/3)
end

function Shape:validate() 
    love.graphics.line(self.x*30, self.y*30, self.x*30 + 5, self.y*30 + 5)
end