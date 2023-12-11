-- Init function {#f00,1}
function _init()
    elapsedTime = 0
end


-- Helper functions {#f00}
-- Calculate distance between two points
    function distanceSquared(x1, y1, x2, y2)
        return (x2 - x1)^2 + (y2 - y1)^2
    end
-- Checking for collision
function collides(obj1, obj2)
    return obj1.x < obj2.x + obj2.width and
           obj1.x + obj1.width > obj2.x and
           obj1.y < obj2.y + obj2.height and
           obj1.y + obj1.height > obj2.y
end



-->8
-- bonk data

--Bonk data table {#c81}
bonk = {
    position = {x = 20, y = 20}, -- Initial position of the character
    sprites = {0, 1, 2},
    width = 8,
    height = 8,
    currentFrame = 0,
    anim_counter = 0,
    spd = 1,
    flip = false,
}

--This animation functions looks to see if the bonk.currentFrame value is more than the number of sprites for Bonk. If so, it resets the current frame to zero.
-- Bonk change frame function {#c81,6}
function updateAnimation()
        bonk.currentFrame = bonk.currentFrame + 1
        if bonk.currentFrame > #bonk.sprites then
            bonk.currentFrame = 0
        end
end



-- Function for drawing bonk {#c81}
function drawBonk()
    if bonk.flip then
        spr(bonk.sprites[bonk.currentFrame], bonk.position.x, bonk.position.y, 1, 1, true, false)
    else
        spr(bonk.sprites[bonk.currentFrame], bonk.position.x, bonk.position.y)
    end
end


-->8
-- thief data

-- Thief data table {#c0c}
thief = {
    position = {x = 40, y = 20}, -- Initial position of the character
    sprites = {
        {5, 21}, -- First animation frame
        {6, 22} -- Second animation frame
    },
    width = 8,
    height = 16,
    direction = {x = 0, y = 0},
    currentFrame = 1,
    spd = 1,
    animTimer = 0, -- New property to keep track of animation time
    animSpeed = 12, -- Adjust the speed to control the animation
}

--Thief movement logic {#c0c}
-- Loop to ensure the thief doesn't move straight right, up, or down
while thief.direction.x == 0 or thief.direction.y == 0 do
    thief.direction = {x = flr(rnd(3)) - 1, y = flr(rnd(3)) - 1}
end

--Prevent standstill {#c0c}
-- Check if both direction components are zero, and if so, set a default direction
    if thief.direction.x == 0 and thief.direction.y == 0 then
        thief.direction = {x = 1, y = 1} -- If both are zero, default to (1, 1)
    end



-- Function for drawing thief {#c0c}
function drawThief()
    if thief.flip then
        spr(thief.sprites[thief.currentFrame][1], thief.position.x, thief.position.y, 1, 1, true, false)
        spr(thief.sprites[thief.currentFrame][2], thief.position.x, thief.position.y + 8, 1, 1, true, false)
    else
        spr(thief.sprites[thief.currentFrame][1], thief.position.x, thief.position.y)
        spr(thief.sprites[thief.currentFrame][2], thief.position.x, thief.position.y + 8)
    end
end




-->8
--bone data

-- Initialize variables for bone spawning {#fff}
bones = {}
maxBones = 10
spawnInterval = 100  --this number refers to frames that have happened (adjust as needed)

-- bone spawn logic {#fff}
function spawnBone()
    -- Check if there are fewer than the maximum allowed bones
    if #bones < maxBones then
        -- Spawn a new bone at a random location and set it to active = true
        bones[#bones + 1] = {
            x = rnd(120),
            y = rnd(120),
            width = 8,
            height = 4,
            active = true,
            collected = false,
            sprites = {36, 52},
            currentFrame = 1,
            anim_counter = 0,
            anim_speed = 20, --every 20 frames the animation updates to next frame
        }
    end
end



-->8
--code

-- update function {#f00,1}
function _update()

-- bonk animation updates & respawning from other side
    -- movement and animation updates {#c81}
    p_moved = false
    if btn(0) then 
        bonk.position.x = bonk.position.x - bonk.spd
        bonk.flip = true
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if btn(1) then
        bonk.position.x = bonk.position.x + bonk.spd
        bonk.flip = false
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if btn(2) then
        bonk.position.y = bonk.position.y - bonk.spd
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if btn(3) then
        bonk.position.y = bonk.position.y + bonk.spd
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if p_moved then
        if bonk.anim_counter >= 5 then
            updateAnimation()
            bonk.anim_counter = 0
        end
    end

-- respawning from other side {#c81}
    if bonk.position.x < -4 then bonk.position.x = 124
        elseif bonk.position.x > 124 then bonk.position.x = -4
        elseif bonk.position.y < -4 then bonk.position.y = 124
        elseif bonk.position.y > 124 then bonk.position.y = -4
    end

-- Increase overall timer {#fff}
    elapsedTime += 1  -- Increment elapsed time by 1 frame

-- Check if it's time to spawn a new bone {#fff}
    if elapsedTime >= spawnInterval then
        elapsedTime = 0
        spawnBone()
    end

-- Update bone animation {#fff}
    for i = 1, #bones do
        if bones[i] and bones[i].active then
            bones[i].anim_counter += 1
            if bones[i].anim_counter % bones[i].anim_speed == 0 then
                bones[i].currentFrame = 3 - bones[i].currentFrame -- Toggle between 1 and 2 frames
            end
        end
    end


-- Move the thief randomly {#c0c}
    -- Move thief
    thief.position.x += thief.direction.x * thief.spd
    thief.position.y += thief.direction.y * thief.spd
-- Bounce off the walls
    if thief.position.x <= 0 or thief.position.x >= 120 then
        thief.direction.x *= -1 -- Reverse horizontal direction
    end
    if thief.position.y <= 0 or thief.position.y >= 112 then
        thief.direction.y *= -1 -- Reverse vertical direction
    end

-- Update thief animation frame {#c0c}
    thief.animTimer += 1
    if thief.animTimer >= thief.animSpeed then
        thief.animTimer = 0
        -- Toggle frames between 1 and 2
        if thief.currentFrame == 1 then
            thief.currentFrame = 2
        else
            thief.currentFrame = 1
        end
    end

-- Handle other game logic, interactions, etc. HERE

end

-->8
--draw

-- Draw function {#f00}
function _draw()

-- here's another color {#0f0}

-- Screen background color
    cls(0)




-- Draw Bones with animation frames {#fff}
for i = 1, #bones do
    if bones[i] and bones[i].active then
        spr(bones[i].sprites[bones[i].currentFrame], bones[i].x, bones[i].y)
    end
end



-- Draw Bonk {#c81}
    drawBonk()

-- Draw Thief {#c0c}
    drawThief()


end
