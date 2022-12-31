--Nicholas Koenig Flappy Bird Game
-- Pipe Class

Pipe = Class{}


--we call this because we only want the image loaded once, not per instant, so we define it externally (why it's local)
local PIPE_IMAGE = love.graphics.newImage('pipe.png')


--initializes our pipe values
function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH + 64--sets our pipe to spawn on the right edge of the screen

    self.y = y

    --takes the width of our image file (allows us to store our width)
    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

--this function allows our pipe to scroll
function Pipe:update(dt)

end

--render the pipe
function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, --rotation
        1, -- X scale
        self.orientation == 'top' and -1 or 1)
end
