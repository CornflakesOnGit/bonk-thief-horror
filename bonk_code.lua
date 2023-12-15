function _init()
    score = 0

    life = 5
    invincible = false
    invincibility_timer = 20
    invincibility_flash_timer = 1
    show_bonk = true

    elapsed_bone_time = 0
    elapsed_poop_time = 0
    time_left = 62

    poop_announcement = 0

-- for flashing text
    poop_flash_timer = 0
    show_poop_text = true

-- debugging my teleporting poop
    unstuck_counter = 0
    no_collision_frames = 0

    score_sound_played = false

end


-->8
--data tables

bonk = {
    pos = {x = 60, y = 110}, -- Initial position of the character
    sprites = {0, 1, 2},
    width = 8,
    height = 8,
    currentFrame = 0,
    anim_counter = 0,
    speed = 1,
    flip = false,
}


thief1 = {
    pos = {x = flr(rnd((24)+8)), y = flr(rnd(90) + 8)}, -- Initial position of the character
    sprites = {
        {5, 21}, -- First animation frame
        {6, 22} -- Second animation frame
    },
    width = 8,
    height = 16,
--might want to implement this for movement in all 4 directions: 
--direction = {x = flr(rnd(3)) - 1, y = flr(rnd(3)) - 1}
    direction = {x = flr(rnd(2)), y = flr(rnd(2))},
    currentFrame = 1,
    speed = 1.6,
    animTimer = 0, -- New property to keep track of animation time
    animSpeed = 12, -- Controls the animation speed
}

thief2 = {
    pos = {x = flr(rnd((26)+94)), y = flr(rnd(90) + 8)}, -- Initial position of the character
    sprites = {
        {5, 21}, -- First animation frame
        {6, 22} -- Second animation frame
    },
    width = 8,
    height = 16,
    direction = {x = flr(rnd(2)), y = flr(rnd(2))},
    currentFrame = 1,
    speed = 1.6,
    animTimer = 0, -- New property to keep track of animation time
    animSpeed = 12, -- Controls the animation speed
}

bones = {
    max = 10,
    spawn_interval = 70, --this number refers to frames that have been drawn
}

poop1 = {
    pos = {x = 40, y = flr(rnd(91) + 20)}, -- Initial position of poop
    width = 8,
    height = 8,
}

poop2 = {
    pos = {x = 85, y = flr(rnd(91) + 20)}, -- Initial position of poop
    width = 8,
    height = 8,
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
        bonk.pos.x = bonk.pos.x - bonk.speed
        bonk.flip = true
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if btn(1) then
        bonk.pos.x = bonk.pos.x + bonk.speed
        bonk.flip = false
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if btn(2) then
        bonk.pos.y = bonk.pos.y - bonk.speed
        p_moved = true
        bonk.anim_counter = bonk.anim_counter + 1
    end
    if btn(3) then
        bonk.pos.y = bonk.pos.y + bonk.speed
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

-- Move thief1 randomly {#c0c}
function thief1_movement()
    -- Move thief1
    thief1.pos.x = thief1.pos.x + thief1.direction.x * thief1.speed
    thief1.pos.y = thief1.pos.y + thief1.direction.y * thief1.speed

    -- Bounce off the walls
    if thief1.pos.x <= 0 or thief1.pos.x >= 120 then
        thief1.direction.x = thief1.direction.x * -1 -- Reverse horizontal direction
    end

    if thief1.pos.y <= 0 or thief1.pos.y >= 112 then
        thief1.direction.y = thief1.direction.y * -1 -- Reverse vertical direction
    end

    --Prevent standstill {#c0c}
    -- Check if both direction components are zero, and if so, set a default direction
    if thief1.direction.x == 0 and thief1.direction.y == 0 then
        thief1.direction = {x = 1, y = 1} -- If both are zero, default to (1, 1)
    end
end
-- Move thief2 randomly {#c0c}
function thief2_movement()
    -- Move thief2
    thief2.pos.x = thief2.pos.x + thief2.direction.x * thief2.speed
    thief2.pos.y = thief2.pos.y + thief2.direction.y * thief2.speed

    -- Bounce off the walls
    if thief2.pos.x <= 0 or thief2.pos.x >= 120 then
        thief2.direction.x = thief2.direction.x * -1 -- Reverse horizontal direction
    end

    if thief2.pos.y <= 0 or thief2.pos.y >= 112 then
        thief2.direction.y = thief2.direction.y * -1 -- Reverse vertical direction
    end

    --Prevent standstill {#c0c}
    -- Check if both direction components are zero, and if so, set a default direction
    if thief2.direction.x == 0 and thief2.direction.y == 0 then
        thief2.direction = {x = 1, y = 1} -- If both are zero, default to (1, 1)
    end
end


-- Loop to ensure the thief1 doesn't move straight right, up, or down
function ensure_thief1_diagonal()
    while thief1.direction.x == 0 or thief1.direction.y == 0 do
        thief1.direction = {x = flr(rnd(3)) - 1, y = flr(rnd(3)) - 1}
    end
end
-- Loop to ensure the thief2 doesn't move straight right, up, or down
function ensure_thief2_diagonal()
    while thief2.direction.x == 0 or thief2.direction.y == 0 do
        thief2.direction = {x = flr(rnd(3)) - 1, y = flr(rnd(3)) - 1}
    end
end


-- Update thief1 animation
function thief1_animation()
    -- Update thief1 animation frame {#c0c}
        thief1.animTimer = thief1.animTimer + 1
        if thief1.animTimer >= thief1.animSpeed then
            thief1.animTimer = 0
            -- Toggle frames between 1 and 2
            if thief1.currentFrame == 1 then
                thief1.currentFrame = 2
            else
                thief1.currentFrame = 1
            end
        end
end
-- Update thief2 animation
function thief2_animation()
    -- Update thief2 animation frame {#c0c}
        thief2.animTimer = thief2.animTimer + 1
        if thief2.animTimer >= thief2.animSpeed then
            thief2.animTimer = 0
            -- Toggle frames between 1 and 2
            if thief2.currentFrame == 1 then
                thief2.currentFrame = 2
            else
                thief2.currentFrame = 1
            end
        end
end


-- Function for drawing thief1 {#c0c}
function draw_thief1()
    if thief1.flip then
        spr(thief1.sprites[thief1.currentFrame][1], thief1.pos.x, thief1.pos.y, 1, 1, true, false)
        spr(thief1.sprites[thief1.currentFrame][2], thief1.pos.x, thief1.pos.y + 8, 1, 1, true, false)
    else
        spr(thief1.sprites[thief1.currentFrame][1], thief1.pos.x, thief1.pos.y)
        spr(thief1.sprites[thief1.currentFrame][2], thief1.pos.x, thief1.pos.y + 8)
    end
end
-- Function for drawing thief2 {#c0c}
function draw_thief2()
    if thief2.flip then
        spr(thief2.sprites[thief2.currentFrame][1], thief2.pos.x, thief2.pos.y, 1, 1, true, false)
        spr(thief2.sprites[thief2.currentFrame][2], thief2.pos.x, thief2.pos.y + 8, 1, 1, true, false)
    else
        spr(thief2.sprites[thief2.currentFrame][1], thief2.pos.x, thief2.pos.y)
        spr(thief2.sprites[thief2.currentFrame][2], thief2.pos.x, thief2.pos.y + 8)
    end
end



-->8
-- bone functions

-- Next 2 functions: check if it's time to spawn a new bone and do it{#fff}

-- How to spawn a new bone into the bone table
function spawnBone()
    -- Check if there are fewer than the maximum allowed bones
    if #bones < bones.max then
        -- Spawn a new bone at a random location and set it to active = true
        bones[#bones + 1] = {
            pos = {x = rnd(120), y = rnd(110)}, -- random spawn position
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
    if elapsed_bone_time >= bones.spawn_interval then
        elapsed_bone_time = 0
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
-- poop

function draw_poop()
    if poop2.pos.x == poop1.pos.x and poop2.pos.y == poop1.pos.y then
        poop2.pos.x = flr(rnd(60) + 20)
        poop2.pos.y = flr(rnd(60) + 20)
        -- Update previous poop positions
        prev_poop1_pos = {x = poop1.pos.x, y = poop1.pos.y}
        prev_poop2_pos = {x = poop2.pos.x, y = poop2.pos.y}
    end
    spr(4, poop1.pos.x, poop1.pos.y)
    spr(4, poop2.pos.x, poop2.pos.y)
end


function poop_change()
    if time_left < 89 and poop_announcement == 0 then
        --poop1.pos = {x = 40, y = rnd((60 + 40))}
        --poop2.pos = {x = 85, y = rnd((60 + 40))}
        poop_announcement = 1
    elseif time_left < 60 and poop_announcement == 1 then
        poop1.pos = {x = 40, y = rnd((91) + 20)}
        poop2.pos = {x = 85, y = rnd((91) + 20)}
        poop_announcement = 2
    elseif time_left < 30 and poop_announcement == 2 then
        poop1.pos = {x = 40, y = rnd((91) + 20)}
        poop2.pos = {x = 85, y = rnd((91) + 20)}
        poop_announcement = 3
    end
end



function emergency_poop_jump()
    collision_detected = false

    if checkcollision(thief1, poop1) or checkcollision(thief1, poop2) or
       checkcollision(thief2, poop1) or checkcollision(thief2, poop2) then
        collision_detected = true
        unstuck_counter = unstuck_counter + 1
        if unstuck_counter > 7 then
            if checkcollision(thief1, poop1) then
                thief1.pos.x = thief1.pos.x + 10
            elseif checkcollision(thief1, poop2) then
                thief1.pos.x = thief1.pos.x + 10
            elseif checkcollision(thief2, poop1) then
                thief2.pos.x = thief2.pos.x + 10
            elseif checkcollision(thief2, poop2) then
                thief2.pos.x = thief2.pos.x + 10
            end
            unstuck_counter = 0
        end
    end

-- This timer counts up all the time.
-- If it ever reaches 5 frames with no collision between any poops and thieves, it resets the unstuck_counter to zero.
-- This prevents a bug where after every 7 collisions between thieves and poop, they get teleported 10 pixels
-- (this bug was introduced with the upper part of the emergency_poop_jump function.)
-- (previously, the unstuck timer would only be set back to 0 when a thief made the emergency jump)
    if not collision_detected then
        no_collision_frames = no_collision_frames + 1
        if no_collision_frames > 5 then
            unstuck_counter = 0
            no_collision_frames = 0
        end
    else
        no_collision_frames = 0
    end
end



function poop_announce()
    poop_flash_timer = poop_flash_timer + 1

    if poop_flash_timer % 9 == 0 then
        show_poop_text = not show_poop_text
    end

    if (time_left < 62 and poop_announcement == 1) or (time_left < 32 and poop_announcement == 2) then
        if show_poop_text then
            print("poop change!", 40, 0, 7)
        end
    else
        show_poop_text = false -- Ensure text is not displayed after the intended duration
    end
end


-->8
-- collision functions

-- main collision function {#0f0}
function checkcollision(obj1, obj2)
    if (obj1.pos.x > (obj2.pos.x + obj2.width)) then return false end
    if (obj1.pos.y > (obj2.pos.y + obj2.height)) then return false end
    if ((obj1.pos.x + obj1.width) < obj2.pos.x) then return false end
    if ((obj1.pos.y + obj1.height) < obj2.pos.y) then return false end
    return true
end

--Check collision between thieves and bonk {#c0c}
function collision_bonk_thief1()
    if checkcollision(bonk, thief1) then
            sfx(03)
            if not invincible then
            life = life - 1
            invincible = true
            end
    end
end



function collision_bonk_thief2()
    if checkcollision(bonk, thief2) then
            sfx(03)
            if not invincible then
            life = life - 1
            invincible = true
            end
    end
end

function invincibility()
    if invincible then
        invincibility_timer = invincibility_timer - 1
        if invincibility_timer < 1 then
            invincible = false
            invincibility_timer = 20
        end
    end
end

function invincibility_flash()
    if invincible then
        invincibility_flash_timer = invincibility_flash_timer + 1
    end 
    
    if invincibility_flash_timer % 3 == 0 then
        show_bonk = not show_bonk
    end

    if invincibility_flash_timer > 19 then
        show_bonk = true -- Ensure text is not displayed after the intended duration
    end
    invincibility_flash_timer = 1
end


-- check collision between bonk and bones
function collision_bonk_bone()
    if #bones > 0 then
        for i = 1, #bones do
            if bones[i] and bones[i].active and checkcollision(bonk, bones[i]) then
                sfx(04)
                score = score + 1
                deli(bones, i)
            end
        end
    end
end

-- check collision between thieves and poop
-- statt -1 könnte es ein random-wert sein, von -0,8 bis 1,2
function collision_thief1_poop()
    if checkcollision(thief1, poop1) then
        thief1.direction = {x = thief1.direction.x * -1, y = thief1.direction.y * -1}
    end

    if checkcollision(thief1, poop2) then
        thief1.direction = {x = thief1.direction.x * -1, y = thief1.direction.y * -1}
    end
end
function collision_thief2_poop()
    if checkcollision(thief2, poop1) then
        thief2.direction = {x = thief2.direction.x * -1, y = thief2.direction.y * -1}
    end

    if checkcollision(thief2, poop2) then
        thief2.direction = {x = thief2.direction.x * -1, y = thief2.direction.y * -1}
    end
end


-- check collision between thieves and bones
function collision_thief1_bone()
    if #bones > 0 then
        for i = 1, #bones do
            if bones[i] and bones[i].active and checkcollision(thief1, bones[i]) then
                sfx(02)
                deli(bones, i)
            end
        end
    end
end

function collision_thief2_bone()
    if #bones > 0 then
        for i = 1, #bones do
            if bones[i] and bones[i].active and checkcollision(thief2, bones[i]) then
                sfx(02)
                deli(bones, i)
            end
        end
    end
end

-->8
-- Other functions

-- Increase overall timer {#fff}
function bone_timer()
    elapsed_bone_time = elapsed_bone_time + 1  -- Increment elapsed time every 1 frame
end

function poop_timer()
    elapsed_poop_time = elapsed_poop_time + 1  -- Increment elapsed time every 1 frame
end


function countdown()
    time_left = time_left - 1/30
end

--Print HUD on screen
function hud()
    if not ((time_left >= 27 and time_left <= 30) or (time_left >= 57 and time_left <= 60)) then
        print(flr(time_left), 59, 0, 7)
    end
    
    --if time_left > 58 then
    --    print(flr(time_left),59,0,7)
    --if time_left > 30 and < 58 then
    --    print(flr(time_left),59,0,7)
    --else if time_left < 28 then
    --    print(flr(time_left),59,0,7)
    --end

-- Remaining life
    print(life,1,0,7)
    spr(54,6,0)
    spr(38,11,0)

-- Bone score
    if score < 10 then
        print(score,109,0,7)
    else
        print(score,105,0,7)
    end
    spr(54,114,0)
    spr(36,119,0)
    
    


    --print(flr(invincibility_timer),20,0,7)
    --print(invincible)
    --print(time(),50,10,7)
    --print("# of bones: " ..#bones,50,20,7)
end

function end_game()
    if time_left < 0 or life == 0 then
        cls(1)
        print("score: " ..score,46,60,7)
        spr(16,58,70)

        if score > 20 and score_sound_played == false then
            sfx(7)
            score_sound_played = true
        elseif score < 20 and score_sound_played == false then
            sfx(8)
            score_sound_played = true
        end

        
    end
end


-->8
--update

function _update()
    if time_left > 0 or life > 1 then
        bone_timer()
        poop_timer()
        countdown()

        bonk_movement()

        thief1_movement()
        thief2_movement()
        ensure_thief1_diagonal()
        ensure_thief2_diagonal()
        thief1_animation()
        thief2_animation()
        
        collision_bonk_bone()
        collision_bonk_thief1()
        collision_bonk_thief2()
        collision_thief1_poop()
        collision_thief2_poop()
        collision_thief1_bone()
        collision_thief2_bone()
        
        invincibility()

        spawn_new_bone()
        bone_animation()

        poop_change()
        emergency_poop_jump()
    end

end



-->8
--draw

function _draw()
    cls(0)
    map(0, 0, 0, 0, 16, 16)
    rectfill(0, 0, 127, 5, 0)  -- Draws a black rectangle at the top of the screen (128x4)
    draw_poop()
    hud()

    poop_announce()

    draw_bones()
    if show_bonk == true then
        drawBonk()
    end
    invincibility_flash()
    draw_thief1()
    draw_thief2()
    end_game()

end

-- map(screen_x, screen_y, map_x, map_y, width, height)

-- screen_x: The x-coordinate on the screen where the map drawing starts
-- screen_y: The y-coordinate on the screen where the map drawing starts
-- map_x: The x-coordinate in the map data where drawing starts
-- map_y: The y-coordinate in the map data where drawing starts
-- width: The width (in tiles) of the map area to draw
-- height: The height (in tiles) of the map area to draw