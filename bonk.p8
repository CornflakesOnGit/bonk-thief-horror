pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function _init()
    pflp = false
    bonk_spd = 1
    bonk_x = 20
    bonk_y = 20
    e_x = 40
    e_y = 40
    anim_counter = 0
end


--This table contains the sprite info for bonk
bonk = {
    sprites = {0, 1, 2},
    currentFrame = 0
}

--This animation functions looks to see if the bonk.currentFrame value is more than the number of sprites for Bonk. If so, it resets the current frame to zero.
function updateAnimation()
    bonk.currentFrame = bonk.currentFrame + 1
    if bonk.currentFrame > #bonk.sprites then
        bonk.currentFrame = 0
    end
end

function _update()

    p_moved = false

    if btn(0) then 
        bonk_x = bonk_x - bonk_spd
        pflp = true
        p_moved = true
        anim_counter = anim_counter + 1
    end

    if btn(1) then
        bonk_x = bonk_x + bonk_spd
        pflp = false
        p_moved = true
        anim_counter = anim_counter + 1
    end

    if btn(2) then
        bonk_y = bonk_y - bonk_spd
        p_moved = true
        anim_counter = anim_counter + 1
    end

    if btn(3) then
        bonk_y = bonk_y + bonk_spd
        p_moved = true
        anim_counter = anim_counter + 1
    end

    if p_moved then
        if anim_counter >= 5 then
            updateAnimation()
            anim_counter = 0
        end
    end

    if bonk_x < -4 then bonk_x = 124
    elseif bonk_x > 124 then bonk_x = -4
    elseif bonk_y < -4 then bonk_y = 124
    elseif bonk_y > 124 then bonk_y = -4
    end
end

function drawBonk()
    if pflp then
        spr(bonk.sprites[bonk.currentFrame], bonk_x, bonk_y, 1, 1, true, false)
    else
        spr(bonk.sprites[bonk.currentFrame], bonk_x, bonk_y)
    end
end

function _draw()
    cls()
    drawBonk()
end



-->8
page 1 for animation stuff
-->8
page2 for enemy stuff
__gfx__
00090090000000900009000000900090000000006666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00099990000999900009999009599959000000006555555665555556000000000000000000000000000000000000000000000000000000000000000000000000
00995959009959590099595909959599770000776575575665755756000000000000000000000000000000000000000000000000000000000000000000000000
00999999009999990099999909899989077777706555555665555556000000000000000000000000000000000000000000000000000000000000000000000000
00999099009990990099909909999999076666706666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
a0990909009909090099090909990099660000776606606666066066000000000000000000000000000000000000000000000000000000000000000000000000
99999999a99999999999999900909909000000006660066666600666000000000000000000000000000000000000000000000000000000000000000000000000
0099000900090909a090900900999999000000006666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00900900000000000000000000999999000084800066660000666600000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000559555000844400600006006000060000000000000000000000000000000000000000000000000000000000000000000000000
09999990000000000000000000599995008444805666666556666665000000000000000000000000000000000000000000000000000000000000000000000000
09099090000000000000000009999999904448005600006556000065000000000000000000000000000000000000000000000000000000000000000000000000
09999990000000000000000090559555094480005666666556666665000000000000000000000000000000000000000000000000000000000000000000000000
99999990000000000000000000599995044000000600006006000060000000000000000000000000000000000000000000000000000000000000000000000000
099999900000000000000000a0999999040000000666666006666660000000000000000000000000000000000000000000000000000000000000000000000000
09000090000000000000000099559555400000000060060000600600000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000900000000000599950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999900000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099999999959590000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999999999999990000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999999999990990000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0999999999909090000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999990000000000900090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00909000000900090000000000990099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000900900000000000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999900000000000099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099999999959590009999999995959000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
__music__
01 01020344
02 01040344
00 41424344
00 05464744
00 06424344
00 07424344

