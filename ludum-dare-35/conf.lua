--------------------------------------------------
-- Include any additional lua files here
--------------------------------------------------

require "gameutilities"
lume = require "libraries/lume"

--------------------------------------------------

function love.conf(t) 
    t.window.title = "Ludum Dare 35"
    t.window.width = 800
    t.window.height = 600
end
