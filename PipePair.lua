--Flappy Bird by Nicholas Koenig
--   PipePair Class

PipePair = Class{}

--our sizing for the gap between pipes
--to randomize gap size we add our math.random from (-30,30)
--the math.random causes our pipe to be at least 60 bits tall**
local GAP_HEIGHT = 90 + math.random(-30,30)


 --added ,GAP_HEIGHT because that is what we're initializing our PipePair with:
 -- a y value, and a GAP_HEIGHT! **
function PipePair:init(y, GAP_HEIGHT)
    --whether or not this pair of pipes has been scored yet
    --makes sure birds has gone past that pair of pipes

    self.scored = false

    --initializes pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y value is for the topmpst pipe; gap is a vertical shift in the second lower pipe
    self.y = y

    --instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        --math.min function takes min value of added values
        ['lower'] = Pipe('bottom', math.min(self.y + PIPE_HEIGHT + GAP_HEIGHT, VIRTUAL_HEIGHT - 40))
    }

    -- this is the gap value variable**
    -- to make the gap we take the minimum value of our GAP_H and our height is set by our Virtual Height - 20 - self.y+pipe_height
    --this makes it so the Pipes don't spawn very low/high in accordance to the screen
    self.gap = math.min(GAP_HEIGHT, VIRTUAL_HEIGHT - 20 - (self.y + PIPE_HEIGHT))

    --wheter this pipe pair is ready to be removed from our screen
    self.remove = false
end

function PipePair:update(dt)
    --remove the pipe from the scene if it's beyond the left edge of the screen,
    --or else move it from the right of the screen towards the left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for l, pipe in pairs(self.pipes) do
        pipe:render()
    end
end