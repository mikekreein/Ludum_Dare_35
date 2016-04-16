Token = { 
    shape = nil,
    x = 0,
    y = 0,
    alpha = 255,
    scale = 3,
}
Token.__index = Token

function Token.Create(x, y, shape)
  local self = { }
  setmetatable(self, Token)
  self.x = x
  self.y = y
  self.shape = shape
  return self
end

function Token:draw(x, y, width, height)
    if (self.shape ~= nil) then
        self.shape:render(x-1, y-1, width, height, self.alpha, self.scale)
    end
end