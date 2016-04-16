--------------------------------------------------
-- Include any additional lua files here
--------------------------------------------------

require "gameutilities"
require "shape"
require "token"
require "grid"

lume = require "libraries/lume"

--------------------------------------------------

function love.conf(t) 
    t.window.title = "Shiftshifter - Michael Chrien - Ludum Dare 35"
    t.window.width = 800
    t.window.height = 600
end
