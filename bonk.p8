pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function _init()
    score = 0
    life = 5
    time_left = 91
    stolen_bones = 0


    invincible = false
    invincibility_timer = 20
    invincibility_flash_timer = 1
    show_bonk = true
    bonk_onscreen = true


    transformation_in_progress = false
    transformation_end_counter = 0
    transformation_animation_threshold_1 = 5
    transformation_animation_threshold_2 = 10
    transformation_animation_counter = 0
    draw_new_form = true
    transformation_sound_played = false

    input_cooldown_timer = 0

    square_counter = 0
    bonking_in_progress = false
    death_state = 0
    bonk_sfx_1 = false
    bonk_sfx_2 = false
    bonk_sfx_3 = false
    bonk_sfx_4 = false
    bonk_sfx_5 = false

    elapsed_bone_time = 0
    elapsed_poop_time = 0




    poop_announcement = 0



    super_bonk_active = false

    old_bonk_restored = false

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

super_bonk = {
    pos = {x = 200, y = 200}, -- super_bonk starts off offscreen
    sprites = {
        head = { -- Head sprite data for different frames
            {id = 3, width = 8, height = 8},
            {id = 10, width = 8, height = 8},
        },
        torso = {id = 19, width = 8, height = 8},
        club = {id = 20, width = 8, height = 8},
        legs = { -- Legs sprite data for different frames
            {id = 35, width = 8, height = 8}, -- Frame 1
            {id = 18, width = 8, height = 8}, -- Frame 2
            {id = 34, width = 8, height = 8}, -- Frame 3
        }

    },
    current_legs_frame = 1, -- Current frame for the limb animation
    current_head_frame = 1, -- Current frame for the head animation
    width = 8,
    height = 24,
    currentFrame = 1,
    anim_counter = 0,
    anim_speed = 5,
    speed = 3,
    flip = false,
}



thief1 = {
    pos = {x = flr(rnd((24)+8)), y = flr(rnd(90) + 8)}, -- Initial position of the character
    sprites = {
        {5, 21}, -- First animation frame
        {6, 22} -- Second animation frame
    },
    alive = true,
    death_sentence = false,
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
    alive = true,
    death_sentence = false,
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

super_bone = {
            pos = {x = 140, y = 140},
            width = 16,
            height = 8,
            spawned = false,
            collected = false,
            sprites = {   
                {40, 41},
                {56, 57},
            },
            currentFrame = 1,
            anim_counter = 0,
            anim_speed = 20, --every 20 frames the animation updates to next frame

}

poop1 = {
    pos = {x = 40, y = flr(rnd(91)) + 20}, -- Initial position of poop
    width = 8,
    height = 8,
}

poop2 = {
    pos = {x = 85, y = flr(rnd(91)) + 20}, -- Initial position of poop
    width = 8,
    height = 8,
}

-->8
-- bonk functions


-- Function for drawing bonk {#c81}
function draw_bonk()
    if bonk.flip then
        spr(bonk.sprites[bonk.currentFrame], bonk.pos.x, bonk.pos.y, 1, 1, true, false)
    else
        spr(bonk.sprites[bonk.currentFrame], bonk.pos.x, bonk.pos.y)
    end
end

function draw_super_bonk()

    -- Draw torso
    if super_bonk.flip == false then
        spr(super_bonk.sprites.torso.id, super_bonk.pos.x, super_bonk.pos.y + super_bonk.sprites.head[1].height, 1, 1, false, false)
    else
        spr(super_bonk.sprites.torso.id, super_bonk.pos.x, super_bonk.pos.y + super_bonk.sprites.head[1].height, 1, 1, true, false)
    end
    
    -- Draw club (the position does not change, only what's drawn)
    if super_bonk.flip == false then
       spr(super_bonk.sprites.club.id, super_bonk.pos.x + super_bonk.sprites.head[1].width, super_bonk.pos.y + super_bonk.sprites.head[1].height, 1, 1, false, false)
    else
        spr(super_bonk.sprites.club.id, super_bonk.pos.x - super_bonk.sprites.head[1].width, super_bonk.pos.y + super_bonk.sprites.head[1].height, 1, 1, true, false)
    end

    -- Find current legs frame
    current_legs = super_bonk.sprites.legs[super_bonk.current_legs_frame]
    
    if super_bonk.flip == false then
        spr(super_bonk.sprites.legs[super_bonk.current_legs_frame].id, super_bonk.pos.x, super_bonk.pos.y + super_bonk.sprites.head[1].height + super_bonk.sprites.torso.height, 1, 1, false, false) -- Draw legs
    else
        spr(super_bonk.sprites.legs[super_bonk.current_legs_frame].id, super_bonk.pos.x, super_bonk.pos.y + super_bonk.sprites.head[1].height + super_bonk.sprites.torso.height, 1, 1, true, false) -- Draw legs flipped
    end

    -- Find current head frame
    current_head = super_bonk.sprites.head[super_bonk.current_head_frame]

    -- Draw head
    if super_bonk.flip == false then
        spr(super_bonk.sprites.head[super_bonk.current_head_frame].id, super_bonk.pos.x, super_bonk.pos.y, 1, 1, false, false) -- Draw head
    else
        spr(super_bonk.sprites.head[super_bonk.current_head_frame].id, super_bonk.pos.x, super_bonk.pos.y, 1, 1, true, false) -- Draw head flipped
    end
end

-- movement for bonk AND super_bonk {#c81}
function bonk_movement()
    if super_bonk_active == false then

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

        if bonk_onscreen == true then    
            if bonk.pos.x < -4 then bonk.pos.x = 124
            elseif bonk.pos.x > 124 then bonk.pos.x = -4
            elseif bonk.pos.y < 6 then bonk.pos.y = 124
            elseif bonk.pos.y > 124 then bonk.pos.y = 6
            end
        end
    
    else
        p_moved = false
        if btn(0) then 
            super_bonk.pos.x = super_bonk.pos.x - super_bonk.speed
            super_bonk.flip = true
            p_moved = true
            super_bonk.anim_counter = super_bonk.anim_counter + 1
        end
        if btn(1) then
            super_bonk.pos.x = super_bonk.pos.x + super_bonk.speed
            super_bonk.flip = false
            p_moved = true
            super_bonk.anim_counter = super_bonk.anim_counter + 1
        end
        if btn(2) then
            super_bonk.pos.y = super_bonk.pos.y - super_bonk.speed
            p_moved = true
            super_bonk.anim_counter = super_bonk.anim_counter + 1
        end
        if btn(3) then
            super_bonk.pos.y = super_bonk.pos.y + super_bonk.speed
            p_moved = true
            super_bonk.anim_counter = super_bonk.anim_counter + 1
        end
        if p_moved then
            if super_bonk.anim_counter >= 8 then
                super_bonk_animation()
                super_bonk.anim_counter = 0
            end
        end

        -- respawning from other side {#c81}

            if super_bonk.pos.x < -4 then super_bonk.pos.x = 124
            elseif super_bonk.pos.x > 124 then super_bonk.pos.x = -4
            elseif super_bonk.pos.y < -24 then super_bonk.pos.y = 124
            elseif super_bonk.pos.y > 128 then super_bonk.pos.y = 6
            end
    
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

-- Super Bonk change frame function {#c81,6}
function super_bonk_animation()

    -- Check if it's time to update the frame
    if super_bonk.anim_counter > super_bonk.anim_speed then
        super_bonk.anim_counter = 0

        -- Cycle through the leg and head frames
        super_bonk.current_legs_frame = super_bonk.current_legs_frame + 1
        super_bonk.current_head_frame = super_bonk.current_head_frame + 1

        -- Reset to the first frame if it exceeds the number of frames
        if super_bonk.current_legs_frame > #super_bonk.sprites.legs then
            super_bonk.current_legs_frame = 1
        end

        if super_bonk.current_head_frame > #super_bonk.sprites.head then
            super_bonk.current_head_frame = 1
        end
    end
end


-->8
-- thief functions

-- Move thief1 randomly {#c0c}
function thief1_movement()
   
    if super_bonk_active == true then 
    
        thief1.pos.x = thief1.pos.x + 3
        if thief1.pos.x < -4 then thief1.pos.x = 124
        elseif thief1.pos.x > 124 then thief1.pos.x = -4
        end
    

    else
        -- Move thief1 (regular)
        thief1.pos.x = thief1.pos.x + thief1.direction.x * thief1.speed
        thief1.pos.y = thief1.pos.y + thief1.direction.y * thief1.speed


            -- Bounce off the walls (regular)
            if thief1.pos.x <= 0 or thief1.pos.x >= 120 then
                thief1.direction.x = thief1.direction.x * -1 -- Reverse horizontal direction
            end

            if thief1.pos.y <= 7 or thief1.pos.y >= 112 then
                thief1.direction.y = thief1.direction.y * -1 -- Reverse vertical direction
            end
    end


        --Prevent standstill {#c0c}
        -- Check if both direction components are zero, and if so, set a default direction
        if thief1.direction.x == 0 and thief1.direction.y == 0 then
            thief1.direction = {x = 1, y = 1} -- If both are zero, default to (1, 1)
        end
end


-- Move thief2 randomly {#c0c}
function thief2_movement()
   
    if super_bonk_active == true then 
    
        thief2.pos.x = thief2.pos.x - 3
        if thief2.pos.x < -4 then thief2.pos.x = 124
        elseif thief2.pos.x > 124 then thief2.pos.x = -4
        end
    

    else
        -- Move thief2 (regular)
        thief2.pos.x = thief2.pos.x + thief2.direction.x * thief2.speed
        thief2.pos.y = thief2.pos.y + thief2.direction.y * thief2.speed



            -- Bounce off the walls (regular)
            if thief2.pos.x <= 0 or thief2.pos.x >= 120 then
                thief2.direction.x = thief2.direction.x * -1 -- Reverse horizontal direction
            end

            if thief2.pos.y <= 7 or thief2.pos.y >= 112 then
                thief2.direction.y = thief2.direction.y * -1 -- Reverse vertical direction
            end

        --Prevent standstill {#c0c}
        -- Check if both direction components are zero, and if so, set a default direction
        if thief2.direction.x == 0 and thief2.direction.y == 0 then
            thief2.direction = {x = 1, y = 1} -- If both are zero, default to (1, 1)
        end
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

function update_thief_face1()
    
    if super_bonk_active == true then
    
        if thief1.death_sentence == true then 
            
            thief1.sprites = {
                {13, 21}, -- First animation frame
                {13, 22} -- Second animation frame
            }

        else thief1.sprites = {
            {11, 21}, -- First animation frame
            {12, 22} -- Second animation frame
        }

        end
    
    else thief1.sprites = {
        {5, 21}, -- First animation frame
        {6, 22} -- Second animation frame
    }

    end

end

function update_thief_face2()
    
    if super_bonk_active == true then

        if thief2.death_sentence == true then 
            
            thief2.sprites = {
                {13, 21}, -- First animation frame
                {13, 22} -- Second animation frame
            }

        else thief2.sprites = {
            {11, 21}, -- First animation frame
            {12, 22} -- Second animation frame
        }

        end
    
    else thief2.sprites = {
        {5, 21}, -- First animation frame
        {6, 22} -- Second animation frame
    }

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
            pos = {x = rnd(120), y = rnd(110) + 6}, -- random spawn position
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

function draw_super_bone()
    if super_bone.spawned == true and super_bone.collected == false then
        if super_bone.currentFrame == 1 then
            spr(40, super_bone.pos.x, super_bone.pos.y)
            spr(41, super_bone.pos.x + 8, super_bone.pos.y)
        elseif super_bone.currentFrame == 2 then
            spr(56, super_bone.pos.x, super_bone.pos.y)
            spr(57, super_bone.pos.x + 8, super_bone.pos.y)
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


-- Update super_bone animation {#fff}
function super_bone_animation()
        super_bone.anim_counter = super_bone.anim_counter + 1
        if super_bone.anim_counter % super_bone.anim_speed == 0 then
            super_bone.currentFrame = 3 - super_bone.currentFrame -- Toggle between 1 and 2 frames
        end
end

function spawn_super_bone()
    if super_bone.spawned == false then
        if stolen_bones == 7 then
            super_bone.pos.x = 60
            super_bone.pos.y = 62
            super_bone.spawned = true
        end
    end
end

-->8
-- poop

function draw_poop()
    spr(4, poop1.pos.x, poop1.pos.y)
    spr(4, poop2.pos.x, poop2.pos.y)
end


function poop_change()
    if time_left < 89 and poop_announcement == 0 then
        --poop1.pos = {x = 40, y = rnd((60 + 40))}
        --poop2.pos = {x = 85, y = rnd((60 + 40))}
        poop_announcement = 1
    elseif time_left < 60 and poop_announcement == 1 then
        poop1.pos = {x = 40, y = rnd(91) + 20}
        poop2.pos = {x = 85, y = rnd(91) + 20}
        poop_announcement = 2
    elseif time_left < 30 and poop_announcement == 2 then
        poop1.pos = {x = 40, y = rnd(91) + 20}
        poop2.pos = {x = 85, y = rnd(91) + 20}
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
    
    if invincibility_flash_timer % 2 == 0 then
        show_bonk = false
    end

    if invincibility_flash_timer > 19 then
        show_bonk = true
        invincibility_flash_timer = 1
    end

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



function collision_bonk_super_bone()
    if checkcollision(bonk, super_bone) then
        super_bone.pos.x = 150
        super_bone.pos.y = 150
        
        sfx(04)
        
        super_bonk_active = true
        
        super_bonk.pos.x = bonk.pos.x
        super_bonk.pos.y = bonk.pos.y
        super_bone.collected = true
        thief1.pos = {x = 3, y = 8}
        thief2.pos = {x = 118, y = 8}
        transformation_in_progress = true

            if transformation_sound_played == false then
                sfx(13)
                transformation_sound_played = true
            end

    end
end

-- check collision between thieves and poop
-- statt -1 kれへnnte es ein random-wert sein, von -0,8 bis 1,2
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
                stolen_bones = stolen_bones + 1
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
                stolen_bones = stolen_bones + 1
            end
        end
    end
end



-->8
-- Murder functions

function collision_super_bonk_thief1()
    if checkcollision(super_bonk, thief1) then
        sfx(16)

        bonking_in_progress = true
        thief1.pos = {x = 64, y = 64}
        super_bonk.pos = {x = 50, y = 56}
        super_bonk.flip = false
        thief1.death_sentence = true
        bonking_thief1()
    end
end

function collision_super_bonk_thief2()
    if checkcollision(super_bonk, thief2) then
        sfx(16)

        bonking_in_progress = true
        thief2.pos = {x = 64, y = 64}
        super_bonk.pos = {x = 50, y = 56}
        super_bonk.flip = false
        thief2.death_sentence = true
        bonking_thief2()
    end
end

function bonking_thief1()
    if death_state < 6 then
        if input_cooldown_timer == 0 then
            if btnp(5) then
                    input_cooldown_timer = 20
                    thief1.alive = false
                    death_state = death_state + 1
            end
        end
    else
        if input_cooldown_timer == 0 then
            super_bonk_active = false
            bonking_in_progress = false
            thief1.pos = {x = -300, y = -300}
            thief1.alive = false
            get_rid_of_super_bonk()
        end
    end
end

function bonking_thief2()
    if death_state < 6 then
        if input_cooldown_timer == 0 then
            if btnp(5) then
                input_cooldown_timer = 20
                thief2.alive = false
                death_state = death_state + 1
            end
        end
    else
        if input_cooldown_timer == 0 then
            super_bonk_active = false
            bonking_in_progress = false
            thief2.pos = {x = -400, y = -400}
            thief2.alive = false
            get_rid_of_super_bonk()
        end
    end
end

function death_states_thief1()
    if death_state == 1 then
        spr(7,64,64)
        spr(23,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 17}
        end


    if death_state == 2 then

        spr(8,64,64)
        spr(24,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 20}
        end


    if death_state == 3 then
        spr(9,64,64)
        spr(25,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 17}
        end


    if death_state == 4 then
        spr(26,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 20}
        end


    if death_state == 5 then
        spr(27,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 17}
        end
end

function death_states_thief2()

    if death_state == 1 then
        spr(7,64,64)
        spr(23,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 17}
        end

    if death_state == 2 then
        spr(8,64,64)
        spr(24,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 20}
        end

    if death_state == 3 then
        spr(9,64,64)
        spr(25,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 17}
        end

    if death_state == 4 then

        spr(26,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 20}
        end

    if death_state == 5 then
        spr(27,64,72)
        bonk_sound()
        super_bonk.sprites.club = {id = 17}
        end

end

function bonk_sound()

    function bonk_sound_1()
        if bonk_sfx_1 == false then
            sfx(15)
            bonk_sfx_1 = true
        end
    end

    function bonk_sound_2()
        if bonk_sfx_2 == false then
            sfx(15)
            bonk_sfx_2 = true
        end
    end    
    
    function bonk_sound_3()
        if bonk_sfx_3 == false then
            sfx(15)
            bonk_sfx_3 = true
        end
    end    
    
    function bonk_sound_4()
        if bonk_sfx_4 == false then
            sfx(15)
            bonk_sfx_4 = true
        end
    end
    
    function bonk_sound_5()
        if bonk_sfx_5 == false then
            sfx(15)
            bonk_sfx_5 = true
        end
    end

    if death_state == 1 then
        bonk_sound_1()
    elseif death_state == 2 then
        bonk_sound_2()
    elseif death_state == 3 then
        bonk_sound_3()
    elseif death_state == 4 then
        bonk_sound_4()
    elseif death_state == 5 then
        bonk_sound_5()
    end
end

-->8
-- Timer functions

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

function input_cooldown()
    if input_cooldown_timer > 0 then
        input_cooldown_timer = input_cooldown_timer - 1
    end
end



--Print HUD on screen
function hud()
    if (time_left > 0 and time_left < 30) or (time_left > 32 and time_left < 60) or (time_left > 62 and time_left < 91) then
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


    --print("thief2 x" ..thief1.pos.x, 70,20,0)
    --print("thief2 y" ..thief1.pos.y, 70,30,0)

    --print("super_bone" ..super_bone.pos.x, 70,50,0)
    --print("super_bone" ..super_bone.pos.y, 70,60,0)

    --print("bonk" ..bonk.pos.x, 70,80,0)
    --print("bonk" ..bonk.pos.y, 70,90,0)

    --print("super_bonk" ..super_bonk.pos.x, 70,100,0)
    --print("super_bonk" ..super_bonk.pos.y, 70,110,0)
    --print("death state: " ..death_state, 15,20,0)
    --print("cooldown: " ..input_cooldown_timer, 50,30,0)
    --print(btnp(5))
    --print(flr(invincibility_timer),20,0,7)
    --print(invincible)
    --print(time(),50,10,7)
    --print("# of bones: " ..#bones,50,20,7)
end


-->8
--Transformation event


function transform_bonk_animation()
    if transformation_in_progress then
        transformation_animation_counter = transformation_animation_counter + 1

        if transformation_animation_counter > transformation_animation_threshold_1 then
            draw_new_form = true
        end

        if transformation_animation_counter > transformation_animation_threshold_2 then
            draw_new_form = false
            transformation_animation_counter = 0
        end
        bonk_onscreen = false

    end
end


function end_transformation_process()
    if transformation_in_progress == true then 
        transformation_end_counter = transformation_end_counter + 1

        if transformation_end_counter > 73 then
            transformation_in_progress = false
            bonk.pos.x = -20
            bonk.pos.y = -20

        end
    end
end


function get_rid_of_super_bonk()
    super_bonk_active = false
    super_bonk.pos = {x = 200, y = 200}
    if old_bonk_restored == false then
    bonk.pos = {x = 64, y = 64}
    old_bonk_restored = true
    bonk_onscreen = true
    end
end

-->8
--Other functions

function end_game()
    if time_left < 0 or life == 0 then
        cls(1)
        print("score: " ..score,46,60,7)
        spr(16,58,70)

        if score >= 20 and score_sound_played == false then
            sfx(7)
            score_sound_played = true
        elseif score < 20 and score_sound_played == false then
            sfx(8)
            score_sound_played = true
        end

        
    end
end








function negative_life_debug()
    if life == -1 then
        life = 0
    end
end

-->8
--update

function _update()




    if life > 0 then
        if time_left > 0 then
            end_transformation_process()
            transform_bonk_animation()
                
            if thief1.alive == true then 
                update_thief_face1()
            end
                
            
            if thief2.alive == true then 
                update_thief_face2()
            end

            input_cooldown()

            if thief1.death_sentence == true then
                bonking_thief1()
            end

            if thief2.death_sentence == true then
                bonking_thief2()
            end
            
            if not transformation_in_progress then
                    if not bonking_in_progress then




                            bone_timer()
                            poop_timer()
                            countdown()

                            bonk_movement()
                            
                            if thief1.alive == true then 
                                thief1_movement()
                                ensure_thief1_diagonal()
                                thief1_animation()
                            end



                            if thief2.alive == true then
                                thief2_movement()
                                ensure_thief2_diagonal()
                                thief2_animation()
                            end

                            collision_bonk_bone()
                            collision_bonk_super_bone()

                            collision_bonk_thief1()
                            collision_bonk_thief2()
                            collision_thief1_poop()
                            collision_thief2_poop()
                            collision_thief1_bone()
                            collision_thief2_bone()
                            
                            collision_super_bonk_thief1()
                            collision_super_bonk_thief2()
                            
                            invincibility()
                            invincibility_flash()

                            spawn_new_bone()
                            bone_animation()

                            spawn_super_bone()
                            super_bone_animation()

                            poop_change()
                            emergency_poop_jump()

                            negative_life_debug()

                    end
                end
        end
    end
end



-->8
--draw

function _draw()
    cls(0)

    if super_bonk_active == false then
        map(0, 0, 0, 0, 16, 16)

    else
        map(16, 0)
    end

    rectfill(0, 0, 127, 5, 0)  -- Draws a black rectangle at the top of the screen (128x4)
    draw_poop()



    hud()

    poop_announce()

    draw_bones()

    if bonking_in_progress == true then
        rectfill(40, 50, 80, 90, 0)
        rectfill(23, 95, 100, 110, 0)
        print("press x to bonk", 33, 100, 7)
    end

    draw_super_bone()

    death_states_thief1()
    death_states_thief2()

    if super_bonk_active == true then
        if transformation_in_progress then
            if draw_new_form == true then
                draw_super_bonk()
            else
                draw_bonk()
            end
        else
            draw_super_bonk()
        end
    elseif show_bonk == true then
            draw_bonk()
    end
    
    
    -- I'm calling this funciton here again to increase flashing speed
    invincibility_flash()

    if thief1.alive == true then
        draw_thief1()
    end
    
    if thief2.alive == true then
        draw_thief2()
    end

    
    end_game()

end

-- map(screen_x, screen_y, map_x, map_y, width, height)
-- screen_x: The x-coordinate on the screen where the map drawing starts
-- screen_y: The y-coordinate on the screen where the map drawing starts
-- map_x: The x-coordinate in the map data where drawing starts
-- map_y: The y-coordinate in the map data where drawing starts
-- width: The width (in tiles) of the map area to draw
-- height: The height (in tiles) of the map area to draw

__gfx__
0009009000000090000900000090009000004000cccccccccccccccc88cccccc00008ccc0000000000900090cccccccccccccccccccccccc0000000000000000
0009999000099990000999900959995900044400c555555cc555555c8875575c0008855c0000000009599959c555555cc555555cc575575c0000000000000000
0099d9d90099d9d90099d9d99995959900444400c575555cc555575c8875575c0088575c0000000099889889c575555cc555575cc575575c0000000000000000
0099999900999999009999999989998900555540c555555cc555555c8575575c0075575c0000000c99889889c555555cc555555cc575575c0000000000000000
0099959900999599009995999999999904444440cccccccccccccccc8ccccccc087ccccc00000ccc99999999cccccccccccccccccccccccc0000000000000000
a099595900995959009959599999559904555555ccfccfccccfccfcc8ccccccc088ccccc0000cccc99995599cccffccccccffccccccccccc0000000000000000
99999999a9999999999999999995995944444444cccffccccccffccccccffccc08cffccc00007cc799959959ccfccfccccfccfcccccffccc0000000000000000
0099000900090909a09090090999999944444444ccccccccccccccccccccccccccfccfcc000cffcc09999999cccccccccccccccccccccccc0000000000000000
009009000000000000599950009999990000848000cccc0000cccc0000cccc00008ccc00008c8c00000000000000000033333430000000000000000000000000
00999900000000000009009000559555000844400c5555c00cccccc00cccccc00cccccc00ccc8cc000000cc00000000030334443000000000000000000000000
0999999000080808000900900059999500844480fccccccffc5555cffc5555cffc5855cffc5888c0000088c00000000033344443000000000000000000000000
09d99d9099444444000900900999999990444800fc5555cffccccccffccccccffccccccffcccc888000887880000000033455544000000000000000000000000
a999999044448484000900909055955509448000fccccccffc5555cffc5555cffc5555cf0c5558c8005858c80000080034444444000000000000000000000000
99999990000808080009009000599995044000000c5555c00cccccc00cccccc00c8cccc00c88ccc00c88c8880088880034555555000000000000000000000000
099999900000000000090090a0999999040000000cccccc00cccccc00cccccc00cccccc00cccc8c00888c8c80088788044444444000000000000000000000000
090000900000000000099099995595554000000000f00f00000f00f0000f00f0000f00f0000f0080888c80880888888844444444000000000000000000000000
00000000000000900059995000599950770000777700007788088000007777007770000000000777770000770000000000000000000000000000000000000000
0000000000099990000909000090009077777777772c3b7788888000070000707770000000000777077777700000000000000000000000000000000000000000
000999999999d9d9000909000090009077666677778e9a7788888000707000077778e9ab31cf4777076666700000000000000000000000000000000000000000
00999999999999990009090000900090660000776600007708880000700700077778e9ab31cf4777660000770000000000000000000000000000000000000000
00999999999990990009090000900090000000000000000000800000700070077778e9ab31cf4777000000000000000000000000000000000000000000000000
a0999999999909090009090000900090000000000000000000000000700070077778e9ab31cf4777000000000000000000000000000000000000000000000000
99999999999999990009090000900090000000000000000000000000070000706660000000000777000000000000000000000000000000000000000000000000
00909000000900090009999000990099000000000000000000000000007777006660000000000777000000000000000000000000000000000000000000000000
00000000000900900000000000090000007007000070070000000000000000000000000000000000077007700000000000000000000000000000000000000000
00000000000999900000000000099990000770000008a00070700000000000000000077007700000077777700000000000000000000000000000000000000000
000999999999d9d9000999999999d9d900067000000cb00007000000000000000000077cf7700000007777000000000000000000000000000000000000000000
009999999999999900999999999999990060070000700700707000000000000000000008c0000000077667700000000000000000000000000000000000000000
00999999999990990099999999999099000000000000000000000000000000000000000a10000000066007700000000000000000000000000000000000000000
a099999999990909a099999999990909000000000000000000000000000000000000077b37700000000000000000000000000000000000000000000000000000
99999999999999999999999999999999000000000000000000000000000000000000077007700000000000000000000000000000000000000000000000000000
00900090000009090009009000900900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333333333333333333333333333333333333333333bbbbbb33333333333666633333300900900488888888888888888888888008880800888000800000000
333333333333333333333333333bb33333333333333bbbbbbbbbb333333336655663333300999900844888888848844888888888008880008000088800000000
333333333333333333333333333b33333b333b3333bbb333333bbb33333366555566333309999990888888888888884888888888800888008000888800000000
3333333333333333bbbbb3333b3b3b333bb3bb333bbb3bbbbbb3bbb3333665555556633309d99d90888844888888888888888888008008808808808800000000
333333333333333bbbbbbbb333bbb33333b3b3333bb3bbbbbbbb3bb3336655955955663309999990884888888848888888888888888808008808808800000000
333333333bbbbbbb3b33bbbb333b3333333b3333bb3bbb3333bbb3bb366555999955566399999990884888888888884888888888000008080008800000000000
33333333bbb3bbbbbb3bbb3b33333333333b3333bb3bb3bbbb3bb3bb665555d9d955556609999990888844888488488888888888008800000888008800000000
33333333bbb3bb3bbbbbbbbb3333333333333333bb3bb3bbbb3bb3bb65555599999a555609000090888884888488888488888888088800000000088000000000
33333333bbbbbb3b3bbb3bbb0000000033aaaa33bb3bb3bbbb3bb3bb655555555555555633373333888884888866668888844888880000000088880000000000
33333733b33bb33bb3bbb3bb000000003a55aca3bb3bb3bbbb3bb3bb6555555665555556337a7333888844488677776888444948800800800000000800000000
33737873bbbbb3bbbbb3b3bb00000000a5a5cacabb3bbb3333bbb3bb655555600655555633373333888444486770707688499448008008800008000800000000
37873733bbb33bbb3bb3bbbb00000000a55a5caa3bb3bbbbbbbb3bb36555560000655556333b3733884555446777777684948884888008800008880000000000
33733b333bbbbbb33bbbbbb300000000aac5a55a3bbb3bbbbbb3bbb36555560000655556333b7a73844444446777077684444484888008000000000000000000
33b33b3333bbbbbbbbbbbb3300000000acac5a5a33bbb333333bbb336555560000655556333b3b33845555558677076889984498888088000088808800000000
33b33b333333333333333333000000003aca55a3333bbbbbbbbbb3336555560000655556333b3b33444444448867768888884988888080000008888800000000
33b33b3333333333333333330000000033aaaa3333333bbbbbb33333666666666666666633333333444444448886688888888888880880000008888800000000
333333333b3333333333345554433333000000000000000000000000000000000000000000000000000000000000000088884888888888000088888800000000
33b3333b3bb333333333354544433333000000000000000000000000000000000000000000000000000000000000000084448948888888000088888800000000
33bbb3bb33b33b33333334444443333300000000000000000000000000000000000000000000000000000000000000008848a448888888000888888800000000
3333bbb333b3bb3333333545544333330000000000000000000000000000000000000000000000000000000000000000848aa884888880000888888800000000
33333bb333bbb33333333444444333330000000000000000000000000000000000000000000000000000000000000000848aa484888880000088888800000000
bb3b33b333bb33b33333355554433333000000000000000000000000000000000000000000000000000000000000000089aa8498888888000088888800000000
3bbb33b333bb3bb33333344444433333000000000000000000000000000000000000000000000000000000000000000088884988888888000088888800000000
33bb33b333bb3bb33333345545433333000000000000000000000000000000000000000000000000000000000000000088888888888880000008888800000000
__map__
404040404040404040404040404045464c4c4c4c4c4c4c4c4c4c4c4c4c4c4d4e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404055564c4c4c4c4c4c4c4c4c4c4c4c4c4c5d5e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404440404040404040404040404062634c4c5c4c4c4c4c4c4c4c4c4c4c4c6d6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040405940404050404040404062634c4c4c4c4c4c4c4c4b4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c4c4c4c4c4c4c4c4c4c4c4c4c6c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404340404040404c4c4c4c4a4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040504040594040404040404050404c6c4c4c4c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c4c4c4c4c4b4c4c5c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c4c5c4c4c4c4c4c4c4c4c4a4c5c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404340404040404040404040404044404c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040444040404040404061404040404c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c5b4c5c4c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404340404440405040404c4c4c4c4c4c4c4c4c4c4b4c4a4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404050404040404040404040404040404c4c4c4c6c4c4c4a4c4c4c4c4c4c6c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c4c4c4c4c4c4c4c4c4c5b4c4c4b4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c4c4b4c4c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011100141b0521d0521f0521f0522205222052220521f0521f0521d0521d0521b0521b0521d0521d0521b0521b0521b0520000200002000020000200002000020000200002000020000200002000020000200002
010f00002210027100291002b1002b1002b1002910027100221001b1001b1001b10024100291002b1002e1002e1002b10027100271002710024100291002e1002e100241001d1001d100221001f1001f10022100
010300001e2541825411254182501f2500c2002f2000c2000a2000a2000720007200072000a20007200052000a2000c2000c2000a200072000a2000f2000f2000c2000a2000c2000f2000f2000f2001120016200
0003000029050220501d05007100071000c1003100007100051000310003100071000a1000c1000a100071000710007100071000a1000a1000a10005100071000a10007100071000710007100071000510003100
010500003115435154381540a1000c1000f1000f1000f1000c1000a1001310016100161000a100071000310003100001000c1000c1001d1001f1002210016100131000010003100071000f100161001310011100
0017002027050300502e0502b050330502e0502e0502e050330502e0502b050270502b0502e050300502e0502905027050290502e05030050300502e0502e05030050300502e050300502e050300502e05030050
111700201015410154151541b100151001415412154001000f10014154121540e154101540e1001415414100151540e1000c10010154151541b100151001415412154001000f10014154121540e1540415701157
0009000011050160501b0501f0501d0501f050270502e0503505037050370503705015000180001500015000270002b000330003a0003f0000000000000000000000000000000000000000000000000000000000
000a0000215501d5501a55015550105500c55006550025500155000550015500c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500003055033550005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01240000194541d45221452254521f4522245228452294560d4000f4000f400024000140001400014000140001400004000040000400004000040000400004000040000400004000040000400000000000000000
011e00000445003450034500345003450024500245001450014500145001450014500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000600002865031650376502b65000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001700003a2503a2503a2503a25000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
00100000096500f6501565018650136500d650086500b65014650196501c650126500a65005650096500f650176501b650176500d6500a650076500a6501065016650166500a6500265001650006500065000650
__music__
01 01424344
02 43454344
00 41424344
04 05464744
00 06424344
00 07424344

