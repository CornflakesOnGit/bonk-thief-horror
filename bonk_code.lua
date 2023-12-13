function _init()
    elapsedTime = 0
end


-->8
--data tables

bonk = {
    pos = {x = 20, y = 20}, -- Initial pos of the character
    sprites = {0, 1, 2},
    width = 8,
    height = 8,
    currentFrame = 0,
    anim_counter = 0,
    spd = 1,
    flip = false,
}

thief = {
    pos = {x = 40, y = 20}, -- Initial position of the character
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

bones = {
    max = 10,
    spawn_interval = 100, --this number refers to frames that have happened (adjust as needed)
}


-->8
-- bonk functions


-- Function for drawing bonk {#c81}
function drawBonk()
    if bonk.flip then
        spr(bonk.sprites[bonk.currentFrame], bonk.pos.x, bonk.pos.y, 1, 1, true, false)
    else
        spr(bonk.sprites[bonk.currentFrame], bonk.pos.x, bonk.pos.y)
    end
end

-- movement and animation updates {#c81}
function bonk_movement()
    p_moved = false
    if btn(0) then 
        bonk.pos.x = bonk.pos.x - bonk.spd
        bonk.flip = true
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if btn(1) then
        bonk.pos.x = bonk.pos.x + bonk.spd
        bonk.flip = false
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if btn(2) then
        bonk.pos.y = bonk.pos.y - bonk.spd
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if btn(3) then
        bonk.pos.y = bonk.pos.y + bonk.spd
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if p_moved then
        if bonk.anim_counter >= 5 then
            bonk_animation()
            bonk.anim_counter = 0
        end
    end

    -- respawning from other side {#c81}
    if bonk.pos.x < -4 then bonk.pos.x = 124
        elseif bonk.pos.x > 124 then bonk.pos.x = -4
        elseif bonk.pos.y < -4 then bonk.pos.y = 124
        elseif bonk.pos.y > 124 then bonk.pos.y = -4
    end
end

-- Bonk change frame function {#c81,6}
function bonk_animation()
    --This animation functions looks to see if the bonk.currentFrame value is more than the number of sprites for Bonk. If so, it resets the current frame to zero.
    bonk.currentFrame = bonk.currentFrame + 1
    if bonk.currentFrame > #bonk.sprites then
        bonk.currentFrame = 0
    end
end

-->8
-- thief functions

-- Move the thief randomly {#c0c}
function thief_movement()
    -- Move thief
    thief.pos.x = thief.pos.x + thief.direction.x * thief.spd
    thief.pos.y = thief.pos.y + thief.direction.y * thief.spd

    -- Bounce off the walls
    if thief.pos.x <= 0 or thief.pos.x >= 120 then
        thief.direction.x = thief.direction.x * -1 -- Reverse horizontal direction
    end

    if thief.pos.y <= 0 or thief.pos.y >= 112 then
        thief.direction.y = thief.direction.y * -1 -- Reverse vertical direction
    end

    --Prevent standstill {#c0c}
    -- Check if both direction components are zero, and if so, set a default direction
    if thief.direction.x == 0 and thief.direction.y == 0 then
        thief.direction = {x = 1, y = 1} -- If both are zero, default to (1, 1)
    end
end

-- Loop to ensure the thief doesn't move straight right, up, or down
function ensure_thief_diagonal()
    while thief.direction.x == 0 or thief.direction.y == 0 do
        thief.direction = {x = flr(rnd(3)) - 1, y = flr(rnd(3)) - 1}
    end
end

-- Update thief animation
function thief_animation()
    -- Update thief animation frame {#c0c}
        thief.animTimer = thief.animTimer + 1
        if thief.animTimer >= thief.animSpeed then
            thief.animTimer = 0
            -- Toggle frames between 1 and 2
            if thief.currentFrame == 1 then
                thief.currentFrame = 2
            else
                thief.currentFrame = 1
            end
        end
end

-- Function for drawing thief {#c0c}
function drawThief()
    if thief.flip then
        spr(thief.sprites[thief.currentFrame][1], thief.pos.x, thief.pos.y, 1, 1, true, false)
        spr(thief.sprites[thief.currentFrame][2], thief.pos.x, thief.pos.y + 8, 1, 1, true, false)
    else
        spr(thief.sprites[thief.currentFrame][1], thief.pos.x, thief.pos.y)
        spr(thief.sprites[thief.currentFrame][2], thief.pos.x, thief.pos.y + 8)
    end
end



--Print help text on screen
function timer()
    print(time(),50,10,7)
end


-->8
-- bone functions

-- Check if it's time to spawn a new bone and do it{#fff}

-- How to spawn a new bone into the bone table
function spawnBone()
    -- Check if there are fewer than the maximum allowed bones
    if #bones < bones.max then
        -- Spawn a new bone at a random location and set it to active = true
        bones[#bones + 1] = {
            pos = {x = rnd(120), y = rnd(120)}, -- random spawn position
            --x = rnd(120),
            --y = rnd(120),
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

-- Spawn a bone after time elapses if under 10 bones
function spawn_new_bone()
    if elapsedTime >= bones.spawn_interval then
        elapsedTime = 0
        spawnBone()
    end
end

-- Draw Bones with animation frames {#fff}
function draw_bones()
    for i = 1, #bones do
        if bones[i] and bones[i].active then
            spr(bones[i].sprites[bones[i].currentFrame], bones[i].pos.x, bones[i].pos.y)
        end
    end
end

-- Update bone animation {#fff}
function bone_animation()
    for i = 1, #bones do
        if bones[i] and bones[i].active then
            bones[i].anim_counter = bones[i].anim_counter + 1
            if bones[i].anim_counter % bones[i].anim_speed == 0 then
                bones[i].currentFrame = 3 - bones[i].currentFrame -- Toggle between 1 and 2 frames
            end
        end
    end
end


-->8
-- collision functions

-- main collision function {#0f0}
function checkcollision(obj1, obj2)
    if (obj1.pos.x > obj2.pos.x + obj2.width) then return false end
    if (obj1.pos.y > obj2.pos.y + obj2.height) then return false end
    if (obj1.pos.x + obj1.width < obj2.pos.x) then return false end
    if (obj1.pos.y + obj1.height < obj2.pos.y) then return false end
    return true
end

--Check collision between thief and bonk {#c0c}
function collision_bonk_thief()
    if checkcollision(bonk, thief) then
            sfx(03)
    end
end

-- check collision between bonk and bones
function collision_bonk_bone()
    if #bones > 0 then
        for i = 1, #bones do
            if bones[i] and bones[i].active and bones[i].pos and checkcollision(bonk, bones[i]) then
                sfx(04)
                bones[i].active = false
            end
        end
    end
end



-->8
-- Other functions

-- Increase overall timer {#fff}
function game_timer()
    elapsedTime = elapsedTime + 1  -- Increment elapsed time by 1 frame
end



-->8
--update

function _update()
    game_timer()
    bonk_movement()
    thief_movement()
    ensure_thief_diagonal()
    thief_animation()
    collision_bonk_thief()
    collision_bonk_bone()
    spawn_new_bone()
    bone_animation()
end



-->8
--draw

function _draw()
    cls(0)
    timer()
    draw_bones()
    drawBonk()
    drawThief()
end