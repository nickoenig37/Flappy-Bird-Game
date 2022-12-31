--Nicholas Koenig FLAPPY BIRD Game
-- BIRD CLASS

Bird = Class{}

local GRAVITY = 20 --was 20 originally, changed because of problem*



function Bird:init() --initializer of bird function
    local images = {
    'Flappybird.png',
    'Flappybirdblue.png',
    'Flappybirdred.png',
}
    math.randomseed(os.time())
    local flappyb = images[math.random(#images)]

    --load bird image from disk and assign its width and height
    --using the table and the random seed given, self.image will be given to 1 of 3 bird colors
    if flappyb == 'Flappybird.png' then
        self.image = love.graphics.newImage('Flappybird.png')

    elseif flappyb == 'Flappybirdblue.png' then
        self.image = love.graphics.newImage('Flappybirdblue.png')

    elseif flappyb == 'Flappybirdred.png' then
        self.image = love.graphics.newImage('Flappybirdred.png')
    end

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --coordinate to position the bird in the middle of the screen at start
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8

    -- Y velocity; gravity
    self.dy = 0 --initial velocity is 0

    self.health = 100 --initializing our birds starting health
end



-- AABB collision that expects a pipe, which will have an X and Y and reference global pipe width and height values.
--tells us if none of this is true then there must be a collision
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end


function Bird:update(dt)
    --apply gravity to velocity
    self.dy = self.dy + GRAVITY * dt --adds gravity scaled by delta time so it scales the same amount no matter the fps

    --if space was pressed, then that sets our self.dy to -5 causing the bird to fall
    if love.keyboard.wasPressed('space') --[[or love.mouse.wasPressed(1)]] then
        self.dy = -5
        if self.y > 0 then --a part of stopping bird from flying out of frame
            sounds['jump']:play()
        end
    end

    --apply current velocity to Y position
    --this is a part of making it so our bird cant fly out of frame
    self.y = math.max(self.y + self.dy, 0)
end

function Bird:render() --renders our bird to screen
    love.graphics.draw(self.image, self.x, self.y)
end