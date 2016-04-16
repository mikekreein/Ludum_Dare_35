--------------------------------------------------
-- Include any additional lua files here
--------------------------------------------------

flux = require "libraries/flux"
lume = require "libraries/lume"
require "gameutilities"

require "shape"
require "token"
require "grid"

--------------------------------------------------

function love.conf(t) 
    t.window.title = "Shapeshifter - Ludum Dare 35"
    t.window.width = 800
    t.window.height = 600
end
