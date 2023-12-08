pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

-- Init function {#fff,2}
function _init()
end


-->8
-- bonk data

--Bonk data table  {#0f0}
bonk = {
    position = {x = 20, y = 20}, -- Initial position of the character
    sprites = {0, 1, 2},
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

-- Thief variables table {#c0c}
thief = {
    position = {x = 40, y = 20}, -- Initial position of the character
    largerSprite = {
        {5},
        {21},
    },
    currentFrame = 0,
    spd = 1
}

-- Function for drawing thief {#c0c}
function drawthief()
    if thief.flip then
        spr(thief.sprites[thief.currentFrame], thief.position.x, thief.position.y, 1, 1, true, false)
    else
        spr(thief.sprites[thief.currentFrame], thief.position.x, thief.position.y)
    end
end

-->8
--bone data


-- Initialize variables for bones {#fff}
bones = {}
maxBones = 10
spawnInterval = 120  -- Adjust this value for spawn interval

-- bone logic {#fff}
function spawnBone()
    for i = 1, maxBones do
        if not bones[i] or not bones[i].active then
            bones[i] = {
                x = rnd(120),
                y = rnd(120),
                active = true,
                spawnTimer = 0,
            }
            break  -- Exit the loop after spawning a bone
        end
    end
end



-->8
--code

-- update function
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

-- Increase spawnTimer for active bones {#fff}
    for i = 1, #bones do
        if bones[i].active then
            bones[i].spawnTimer += 1
            if bones[i].spawnTimer >= spawnInterval then
                bones[i].spawnTimer = 0
                bones[i].active = false -- Reset the active state after the interval
            end
        end
    end

-- Check the number of active bones {#fff}
    local activeBones = 0
    for i = 1, #bones do
        if bones[i].active then
            activeBones += 1
        end
    end

-- Spawn a new bone if there are fewer than the maximum allowed and not currently spawning  {#fff}
    if activeBones < maxBones then
        local spawning = false
        for i = 1, #bones do
            if bones[i].active and bones[i].spawnTimer > 0 then
                spawning = true
                break
            end
        end
        if not spawning then
            spawnBone()
        end
    end

    -- Handle other game logic, interactions, etc. HERE
end

-->8
--draw

-- Draw function {#0f0}
function _draw()
    -- Draw Bonk
    cls(12)
    drawBonk()

    -- Draw Bones {#fff}
    for i = 1, #bones do
        if bones[i] and bones[i].active then
            spr(4, bones[i].x, bones[i].y)
        end
    end



end


__gfx__
00090090000000900009000000900090000000006666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00099990000999900009999009599959000000006555555665555556000000000000000000000000000000000000000000000000000000000000000000000000
0099d9d90099d9d90099d9d909959599770000776575575665755756000000000000000000000000000000000000000000000000000000000000000000000000
00999999009999990099999909899989077777706555555665555556000000000000000000000000000000000000000000000000000000000000000000000000
00999599009995990099959909999999076666706666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
a0995959009959590099595909995599660000776656656666566566000000000000000000000000000000000000000000000000000000000000000000000000
99999999a99999999999999900959959000000006665566666655666000000000000000000000000000000000000000000000000000000000000000000000000
0099000900090909a090900900999999000000006666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00900900000000000000000000999999000084800066660000666600000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000559555000844400655556006555560000000000000000000000000000000000000000000000000000000000000000000000000
09999990000000000000000000599995008444805666666556666665000000000000000000000000000000000000000000000000000000000000000000000000
09d99d90000000000000000009999999904448005655556556555565000000000000000000000000000000000000000000000000000000000000000000000000
09999990000000000000000090559555094480005666666556666665000000000000000000000000000000000000000000000000000000000000000000000000
99999990000000000000000000599995044000000655556006555560000000000000000000000000000000000000000000000000000000000000000000000000
099999900000000000000000a0999999040000000666666006666660000000000000000000000000000000000000000000000000000000000000000000000000
09000090000000000000000099559555400000000060060000060060000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000900000000000599950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999900000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000999999999d9d90000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999999999999990000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999999999990990000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0999999999909090000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999990000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00909000000900090000000000990099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000900900000000000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999900000000000099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000999999999d9d9000999999999d9d9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999999999999990099999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999999999990990099999999999099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a099999999990909a099999999990909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00900090000009090009009000900900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011100141b0521d0521f0521f0522205222052220521f0521f0521d0521d0521b0521b0521d0521d0521b0521b0521b0520000200002000020000200002000020000200002000020000200002000020000200002
010f000013050180521b05018050160520f0500f0520f05011050130551605018050180551b0501b0551805016050130521305016052180501605513050160521805518050160521605016055180501b0521b050
010f00001f7501b7521f7502475024752247552275022750227501d7521b7551b7501b7501b7551b750247502b7522975024755227501f7551f7501f750297522b7502e7522b7502b7552975027750297552b750
010f000005552055500755007552075500c5520a55007550055550355003552075500a5500c5520a555075500755207555075500a5500a5520a55505550075500a55207555075500755007552075550555003552
000f00001f7501b7521f75024750247522475527750277502775027752247552b7503375035755307502b750337523a7503a755377502e7553375035750377523a7503a75237750357552e750307503075530750
011700001505015050180541505015050150501505018054150501505015050180541705015050150541505015050150541505418054150501505015050150501805415050150501505018054170501505015054
011700001805017050150501505015050150501505021000150001500015000180000c0000e0000e0000e0000e0000e0000c0000c000210001800009000090000900000000000000000000000000000000000000
0117000015054150541505418054180501a0541a0501a0541a0501a05518054180501505418050150501505015000150001b00019000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 01020344
02 01040344
00 41424344
04 05464744
00 06424344
00 07424344

