pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

-- CTRL+SHIFT+B runs the game

#include bonk_code.lua

__gfx__
0009009000000090000900000090009000000400cccccccccccccccc88cccccc00008ccc0000000000900090cccccccccccccccccccccccc0000000000000000
0009999000099990000999900959995900004440c555555cc555555c8875575c0008855c0000000009599959c555555cc555555cc575575c0000000000000000
0099d9d90099d9d90099d9d99995959900044440c575555cc555575c8875575c0088575c0000000099889889c575555cc555575cc575575c0000000000000000
0099999900999999009999999989998900455544c555555cc555555c8575575c0075575c0000000c99889889c555555cc555555cc575575c0000000000000000
0099959900999599009995999999999904444444cccccccccccccccc8ccccccc087ccccc00000ccc99999999cccccccccccccccccccccccc0000000000000000
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
404440404040404040404040404062634c4c4c4c4c4c4c4c4c4c4c4c4c4c6d6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040405940404050404040404062634c4c4c4c4c4c4c4c4b4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c4c4c4c5b4c4c4c4c4c4c4c4c6c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404340404040404c4c4c4b4c4c4c4c4c4a4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040504040594040404040404050404c6c4c4c5c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c4c4c4c4c4b4c4c4c4c6c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c4c4b4c4c4c4c4c4c4c4c4a4c5c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404340404040404040404040404044404c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040444040404040404061404040404c4c4c4c6c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404040404c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404340404440405040404c4c4a4c4b4c4c4c4c4c4b4c4a4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404050404040404040404040404040404c4c4c4c4c5c4c4a4a4c4c4c5c4c6c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

