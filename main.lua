-- Nicholas Koenig Flappy Bird Remake
--          "fifty bird"
--          FINAL VERSION


-- calling our virtual rez handling library
push = require 'push'

-- classic OOP class library
 --required to use classes
Class = require 'class'


-- all code related to game state and the state machines
-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'StateMachine'

require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'states/PauseState'

require 'Bird'
require 'Pipe'
require 'PipePair'


--setting the actual screen dimensions on windows
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- setting the virtual dimensions of the game
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--setting our backgrounds before putting them in the frame

--background image and starting scroll location (X-AXIS)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0 --variable to keep track of scroll amount

--ground image and starting scroll location (X-AXIS)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0 --variable

-- speed at which we should scroll our images, scaled by dt (2 separate variables)
local BACKGROUND_SCROLL_SPEED = 30 --arbitrary value
local GROUND_SCROLL_SPEED = 60  --must be higher than background speed (can change for diff effect)

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413 --looping point so we don't run out of image (x axis width)

-- global variable we can use to scroll the map
scrolling = true

function love.load()
    --gets rid of bluriness by getting rid of nearest neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG
    math.randomseed(os.time())

    --the title of our app on windows
    love.window.setTitle('Nicholas Koenig Flappy Bird')

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8) --press enter to start
    mediumFont = love.graphics.newFont('flappy.ttf', 14) -- for score
    flappyFont = love.graphics.newFont('flappy.ttf', 28) --name of game
    hugeFont = love.graphics.newFont('flappy.ttf', 56) --for countdown in middle of screen
    love.graphics.setFont(flappyFont)


    -- initialize our table of sounds
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['pause'] = love.audio.newSource('pause.wav', 'static'),
        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('wiimusic.wav', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()


    --initializing our virtual resolution of the game
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --initialize state machine with all state-returning functions
    --g represents that it is now a global variable
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['pause'] = function() return PauseState() end
    }
    gStateMachine:change('title')

    --initializes the input table for our keys
    --by assigning the table to an empty value we can input our own keys pressed into the table
    love.keyboard.keysPressed = {}

----initializes mouse input table
    --love.mouse.buttonsPressed = {}
end

--sets command do resize our application in push
--renders to the texture that we set as virtual width and height
--[[function love.resize (w,h)
    push:resize(w,h)
end]]


--this function gets called every time the user presses a key in the game
function love.keypressed(key)

    -- any time the user presses any key this our table with key gets defined as true
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end


-- love2d callbakc fired each time a mouse button is pressed; this gives the
-- X and Y of the mouse, as well as the button in question.

--[[function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end]]


--This New function used to check our global input table for keys we activated during
--this frame, looked up by their string value.
--checks if 'that' key was pressed
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--equivalent to our keyboard function above, but for mouse buttons.

--[[function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end]]



function love.update(dt)
    if scrolling then
        -- scroll background by preset speed * dt, looping back to 0 after the looping point
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT --% (modulus) sets value to remainder of the division (allows the infinite loop of the screen)

        -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end

        --instead of the long update function with if statements that was here before, we simply just update the state machine, which defers to the right state
    gStateMachine:update(dt)

        -- reset input table
    love.keyboard.keysPressed = {}
    love.keyboard.buttonsPressed = {}
end


--this is how we start drawing to our game
function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
