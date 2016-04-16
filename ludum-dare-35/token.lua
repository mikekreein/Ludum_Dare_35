Token = { 
    shape = nil,
}
Token.__index = Token

function Token.Create(shape)
  local self = { }
  setmetatable(self, Token)
  self.shape = shape
  return self
end

function Token:draw(x, y, width, height)
    if (self.shape ~= nil) then
        self.shape:render(x, y, width, height)
    end
end