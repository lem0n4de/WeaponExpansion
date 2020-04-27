local MasteryData = Ext.Require("Shared/Data/MasteryData_Classes.lua")

---@class TranslatedString
local TranslatedString = LeaderLib.Classes["TranslatedString"]

WeaponExpansion.Masteries = {
["LLWEAPONEX_Axe"] = MasteryData:Create("LLWEAPONEX_Axe", TranslatedString:Create("h99253a1dgaaf7g49bbga37fgf2c25b70073f", "<font color='#F5785A'>Axe Mastery</font>"), {
	[0] = TranslatedString:Create("h4b6dfd40g1a10g4ba5ga77cg19caee1b9fdb", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("he67981aegee37g4467g8f82g1009a1a9c2be", "<font color='#FFAAAA'>Novice</font>"),
	[2] = TranslatedString:Create("h1c713c7ag8952g44d1g8703g6609b75b29a7", "<font color='#D46A6A'>Journeyman Axefighter</font>"),
	[3] = TranslatedString:Create("h0f70049cgf59ag40ecgb093ga1c8db520da0", "<font color='#DD3939'>Expert Axefighter</font>"),
	[4] = TranslatedString:Create("hcaf035f6g0202g4d15gbe00g9b1121fe7569", "<font color='#FF1515'>Warmaster, Axe of Legend</font>"),
}),
["LLWEAPONEX_Banner"] = MasteryData:Create("LLWEAPONEX_Banner", TranslatedString:Create("hbe8ca1e2g4683g4a93g8e20g984992e30d22", "<font color='#F8FF2D'>Banner Mastery</font>"), {
	[0] = TranslatedString:Create("h2e5ab189g901dg4c86ga74cgca3bf1dcba15", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h156cb0ffg52f4g43ceg9b65g4c72ad9cbd9f", "<font color='#DDFFB3'>Novice</font>"),
	[2] = TranslatedString:Create("h6e07e534gbaedg481dgb66ag0d845a2302cd", "<font color='#94E963'>Journeyman Bannerman</font>"),
	[3] = TranslatedString:Create("h6ee30aaegaff6g4751gab87gbb71b9fe0292", "<font color='#52D43A'>Expert Bannerkeeper</font>"),
	[4] = TranslatedString:Create("h181d68fbge496g4c43gab95g26a4fcaee046", "<font color='#28FF00'>Banner Lord</font>"),
}),
["LLWEAPONEX_BattleBook"] = MasteryData:Create("LLWEAPONEX_BattleBook", TranslatedString:Create("he053a3abge5d8g4d14g9333ga18d6eba3df1", "<font color='#22AADD'>Battle Book Mastery</font>"), {
	[0] = TranslatedString:Create("h3b6db1dfgdda3g4a2dgadffg6904133abdd3", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("hb128a361g31ebg48ceg8364gc999706020fa", "<font color='#DDFFB3'>Novice</font>"),
	[2] = TranslatedString:Create("h226ccab8gb20cg421bg8d4ag20b90872d15c", "<font color='#94E9FF'>Journeyman Bookkeeper</font>"),
	[3] = TranslatedString:Create("h3c662307g8ee5g4ca2g8426ge56fbb8d6ac2", "<font color='#52D4FF'>Expert Bookkeeper</font>"),
	[4] = TranslatedString:Create("hb171a4c2g5d8dg4653gb8afg728d998c63f6", "<font color='#28FFFF'>Pagemaster</font>"),
}),
["LLWEAPONEX_Bludgeon"] = MasteryData:Create("LLWEAPONEX_Bludgeon", TranslatedString:Create("h448753f3g7785g4681gb639ga0e9d58bfadd", "<font color='#FFE7AA'>Bludgeon Mastery</font>"), {
	[0] = TranslatedString:Create("hc4c5019bg0fafg482cg8ad7gf2655e33393d", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h0574c86eg4e97g4faegb7e3g6d56465a1e12", "<font color='#FFE7AA'>Novice</font>"),
	[2] = TranslatedString:Create("hb7cb3860gfe3ag453fg83f7g285a04613e44", "<font color='#D4B76A'>Journeyman Smasher</font>"),
	[3] = TranslatedString:Create("h9ccd54f8g82adg4abag84a8g4455602ee601", "<font color='#AA8B39'>Expert Smasher</font>"),
	[4] = TranslatedString:Create("ha51571ffg655ag45eagb78ag379c98e7e0b2", "<font color='#A57C5B'>Master of Smashing</font>"),
}),
["LLWEAPONEX_Bow"] = MasteryData:Create("LLWEAPONEX_Bow", TranslatedString:Create("h54e7afe8geee9g4aeeg97f5g5ab8421d0329", "<font color='#72EE34'>Bow Mastery</font>"), {
	[0] = TranslatedString:Create("h732fb684g376eg420eg9978ga0d9a6953f82", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h43e00fc3g0ac6g4ddag9864g161340dd5a62", "<font color='#CAEA9C'>Novice</font>"),
	[2] = TranslatedString:Create("h7cac4eb1g0d7ag475cgaa87g7df51a7e6d19", "<font color='#9BC362'>Journeyman Archer</font>"),
	[3] = TranslatedString:Create("hbdcd3719ga57ag42a3gae9eg6362d988921f", "<font color='#AAFF14'>Expert Archer</font>"),
	[4] = TranslatedString:Create("hc581e09eg3478g457cg93d1g40a6ad4070dc", "<font color='#4DFF14'>Eagle Eye, Master Archer</font>"),
}),
["LLWEAPONEX_Crossbow"] = MasteryData:Create("LLWEAPONEX_Crossbow", TranslatedString:Create("hcaabd40cg42fag4646g896dg471c77946ed8", "<font color='#81E500'>Crossbow Mastery</font>"), {
	[0] = TranslatedString:Create("h4b2627dege20cg4b9agaff7ga3f748e04904", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h398feef7g53a2g490dg8a3egf22488dacc7c", "<font color='#B5D48D'>Novice</font>"),
	[2] = TranslatedString:Create("h43b022fdg8c40g4dc2gadceg33269acfd0a9", "<font color='#A6D569'>Journeyman Crossbowman</font>"),
	[3] = TranslatedString:Create("h71cd4b64gc0c6g4cf7gaaa8g54b13eb8c40c", "<font color='#95D83F'>Expert Crossbowman</font>"),
	[4] = TranslatedString:Create("h78ac89e4gcfeeg4e19gaaa7g9b0ac3098aff", "<font color='#88E213'>Master Marksman of Crossbows</font>"),
}),
["LLWEAPONEX_Dagger"] = MasteryData:Create("LLWEAPONEX_Dagger", TranslatedString:Create("h697f3261gc083g4152g84cdgbe559a5e0388", "<font color='#5B40FF'>Dagger Mastery</font>"), {
	[0] = TranslatedString:Create("hcbdc584cg6a24g4c8bg957cg099db027fc2e", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("ha9215cd6g7074g41b2ga826g99c3ba415c4c", "<font color='#CDBCF0'>Novice</font>"),
	[2] = TranslatedString:Create("h0e70e249g7e55g4b9cga6c7g19ecd5fca8fe", "<font color='#A17EE8'>Journeyman Thief</font>"),
	[3] = TranslatedString:Create("h2f7c6f84g2961g489ag95b0gd6b5eb28b974", "<font color='#8756EB'>Expert Rogue</font>"),
	[4] = TranslatedString:Create("h3c4adc5agfe20g4feega282gd5ff0bf85bdf", "<font color='#6827EC'>Master Shadowdancer</font>"),
}),
["LLWEAPONEX_DualShields"] = MasteryData:Create("LLWEAPONEX_DualShields", TranslatedString:Create("h00157a58g9ae0g4119gba1ag3f1e9f11db14", "<font color='#D9D9D9'>Dual Shields Mastery</font>"), {
	[0] = TranslatedString:Create("h2b57436cg4a2cg4220g94f0gf59ca7e03784", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("heb1c4f4eg6e9dg45b7gbfdcg1439c6c4380d", "<font color='#FFDA9E'>Novice</font>"),
	[2] = TranslatedString:Create("h3c8a080cgb3b1g4e8fg8c49g13fdffdf5c49", "<font color='#FFC973'>Journeyman Dual Shieldsman</font>"),
	[3] = TranslatedString:Create("h41d7d648geb74g4711gb607g374e572df966", "<font color='#FFB94A'>Expert Dual Shieldsman</font>"),
	[4] = TranslatedString:Create("h46afecdbgf889g427ega96fge3e1d5c6a566", "<font color='#FF9E03'>Dual Shieldmaster</font>"),
}),
["LLWEAPONEX_Firearm"] = MasteryData:Create("LLWEAPONEX_Firearm", TranslatedString:Create("h8d02e345ged4ag4d60g9be9g68a46dda623b", "<font color='#FD8826'>Firearm Mastery</font>"), {
	[0] = TranslatedString:Create("hde1bc355g000fg4bccg8cbege66943e3dd31", "<font color='#FDC89B'>Beginner</font>"),
	[1] = TranslatedString:Create("h0d5e3434gf8c9g4e64gae3fg8cdb6336bac0", "<font color='#FBBC7F'>Novice</font>"),
	[2] = TranslatedString:Create("hf1dfb1ecg4148g45dfgaac1gc11a8066436b", "<font color='#F5A36C'>Journeyman Firearm Enthusiast</font>"),
	[3] = TranslatedString:Create("h24058293g1818g4389ga2d2ga7119b2c585e", "<font color='#F49C4E'>Expert Firearm Lunatic</font>"),
	[4] = TranslatedString:Create("h81807eedg4a5cg4f2bg89bcgf6aa16f9deff", "<font color='#FF9D33'>Master of Firearms, Destruction Supreme</font>"),
}),
["LLWEAPONEX_Greatbow"] = MasteryData:Create("LLWEAPONEX_Greatbow", TranslatedString:Create("h52a81f92g3549g4cb4g9b18g066ba15399c0", "<font color='#00FF7F'>Greatbow Mastery</font>"), {
	[0] = TranslatedString:Create("he5f7f5fdge9c2g43d8gbc58g2f9009fe7553", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h29fb09ddg1428g4ee7g94efg9aceb4989436", "<font color='#DDFFB3'>Novice</font>"),
	[2] = TranslatedString:Create("h0f68040ag5fa7g4d96g8303gc3c2a8f64576", "<font color='#94E963'>Journeyman Slayer</font>"),
	[3] = TranslatedString:Create("h8747de57g3defg41d3gad6aged40bb3e9540", "<font color='#52D43A'>Expert Slayer</font>"),
	[4] = TranslatedString:Create("hc075921ag911ag4564gad10geecdd11ba4bd", "<font color='#28FF00'>Master Dragonslayer</font>"),
}),
["LLWEAPONEX_HandCrossbow"] = MasteryData:Create("LLWEAPONEX_HandCrossbow", TranslatedString:Create("hd8d02aa1g5c35g48b5gbde6ga76293ef2798", "<font color='#FF33FF'>Hand Crossbow Mastery</font>"), {
	[0] = TranslatedString:Create("hfaf23f40g0fa5g4da7g9ae2g7a2a9300ada0", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h76b72fe7gf6cag4953gba27ga7c886669f2f", "<font color='#FFDA9E'>Novice</font>"),
	[2] = TranslatedString:Create("hbd546d70g55c4g4d8dgb9b1gda8d054bdb08", "<font color='#FFC973'>Journeyman Spy</font>"),
	[3] = TranslatedString:Create("hb557309eg71fag4858gb5d2ga4c8dc93dee8", "<font color='#FFB94A'>Expert Spy</font>"),
	[4] = TranslatedString:Create("he81a1a2bgac20g4625ga1f7ge8cf7ff78a86", "<font color='#FF9E03'>Spymaster, Elite Assassin</font>"),
}),
["LLWEAPONEX_Katana"] = MasteryData:Create("LLWEAPONEX_Katana", TranslatedString:Create("he467f39fg8b65g4136g828fg949f9f3aef15", "<font color='#FF2D2D'>Katana Mastery</font>"), {
	[0] = TranslatedString:Create("h0d05cb68gaa21g46eega70ag8ec9962dfc72", "<font color='#FFEAEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h213017b8g518ag468eg8564g1657f73eef09", "<font color='#FF9D9D'>Novice</font>"),
	[2] = TranslatedString:Create("h4a5670c7g1f24g42f8g93acg5f3b107eb433", "<font color='#F56C6C'>Journeyman Bladesman</font>"),
	[3] = TranslatedString:Create("h88f412b9gf5e2g4182gbc13g474ac8480690", "<font color='#F44E4E'>Expert Blademaster</font>"),
	[4] = TranslatedString:Create("h6426796bgbbd4g4af3g94d3g01ee834f3cad", "<font color='#FF3333'>Blademaster</font>"),
}),
["LLWEAPONEX_Pistol"] = MasteryData:Create("LLWEAPONEX_Pistol", TranslatedString:Create("h9ead3ee9g63e6g4fdbg987dg87f8c9f5220c", "<font color='#FF337F'>Pistol Mastery</font>"), {
	[0] = TranslatedString:Create("ha3b93455g807fg42b3gb922ga411505d0d1c", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h4305abb5g75b4g41e7g9351ge3a0405cc957", "<font color='#DDFFB3'>Novice</font>"),
	[2] = TranslatedString:Create("h1459cf28g0041g46e4gb2e8g6c3f86c272ba", "<font color='#94E963'>Journeyman Gunslinger</font>"),
	[3] = TranslatedString:Create("h491f8119g2303g4b83g8a74g2ec7881ba4c9", "<font color='#52D43A'>Expert Gunslinger</font>"),
	[4] = TranslatedString:Create("h3b2089bdgfaefg42b4gbf74g2fb7f027df6a", "<font color='#4CFF00'>Master Gunslinger</font>"),
}),
["LLWEAPONEX_Polearm"] = MasteryData:Create("LLWEAPONEX_Polearm", TranslatedString:Create("hd61320b6ge4e6g4f51g8841g132159d6b282", "<font color='#FFCF29'>Polearm Mastery</font>"), {
	[0] = TranslatedString:Create("ha8c8931cge34dg45bfg9d4fg77c1a25462bc", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h6e76ccd9gbe3eg47e7g905bg5c15031949e3", "<font color='#FFF2C6'>Novice</font>"),
	[2] = TranslatedString:Create("h91785cbag2ef3g43f6ga44bg5bdcfc8caea2", "<font color='#FFE899'>Journeyman Polearmsman</font>"),
	[3] = TranslatedString:Create("h7971be6dg17efg4c8cg8e77g9d57ac62578c", "<font color='#FFE178'>Expert Polearmsman</font>"),
	[4] = TranslatedString:Create("ha7fd7be2gd67fg419ag89fbg7bc4ece52727", "<font color='#FFC154'>Polearm Master</font>"),
}),
["LLWEAPONEX_Quarterstaff"] = MasteryData:Create("LLWEAPONEX_Quarterstaff", TranslatedString:Create("h8d11d8efg0bb8g4130g9393geb30841eaea5", "<font color='#FD8826'>Quarterstaff Mastery</font>"), {
	[0] = TranslatedString:Create("h22f563acgfc6fg4cddg9022g872a8fc0340c", "<font color='#FDC89B'>Beginner</font>"),
	[1] = TranslatedString:Create("hab43ee73ge916g4136gaf83g5d5c5a47384a", "<font color='#FBBC7F'>Novice</font>"),
	[2] = TranslatedString:Create("h5d911119g2364g4baeg9f5dg74a095d048ce", "<font color='#F5A36C'>Journeyman Staff Monk</font>"),
	[3] = TranslatedString:Create("h16505df4g2c73g42ddg81b6gbc9788be5134", "<font color='#F49C4E'>Expert Staff Monk</font>"),
	[4] = TranslatedString:Create("h2ebfd90ag137eg4e96gbd08g2346f41f6d90", "<font color='#FF9D33'>Master Monk of Staves</font>"),
}),
["LLWEAPONEX_Rapier"] = MasteryData:Create("LLWEAPONEX_Rapier", TranslatedString:Create("h84b2d805gff5ag44a5g9f81g416aaf5abf18", "<font color='#00FF7F'>Rapier Mastery</font>"), {
	[0] = TranslatedString:Create("h290c10edge191g4322g9234g8c8e840a30ad", "<font color='#FEFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h3572bd9bg1350g4de5g92c9gb192f1f7a927", "<font color='#FFF59D'>Novice</font>"),
	[2] = TranslatedString:Create("hebde993cgd7a6g4fc0ga40ag764f189c02c9", "<font color='#F5F06C'>Journeyman Fencer</font>"),
	[3] = TranslatedString:Create("h7418eca3g9edcg41d4gbb06g46b1d5684d35", "<font color='#F5E06C'>Expert Fencer</font>"),
	[4] = TranslatedString:Create("h1eade98bgf8a1g4bb9g91f9gd964789a61d8", "<font color='#FFE933'>Master Fencer</font>"),
}),
["LLWEAPONEX_Runeblade"] = MasteryData:Create("LLWEAPONEX_Runeblade", TranslatedString:Create("hb66213fdg1a98g4127ga55fg429f9cde9c6a", "<font color='#40E0D0'>Runeblade Mastery</font>"), {
	[0] = TranslatedString:Create("h0e7d1237g1fa7g493bga730g75ba4247533b", "<font color='#EAFFFE'>Beginner</font>"),
	[1] = TranslatedString:Create("h81ad53d2g707ag468ag92b9g64df4f01fce4", "<font color='#9DFCFF'>Novice</font>"),
	[2] = TranslatedString:Create("h9a91f4a8g8630g4db3g88c5ge15b73d5f5d3", "<font color='#6CE3F5'>Journeyman Runekeeper</font>"),
	[3] = TranslatedString:Create("h0e9b4f32g273dg452bga51dgd984f003882a", "<font color='#6CF5E9'>Expert Runekeeper</font>"),
	[4] = TranslatedString:Create("h9af72e9eg6922g4ddcg84a2ga1190d352f11", "<font color='#33FFB8'>Runemaster</font>"),
}),
["LLWEAPONEX_Scythe"] = MasteryData:Create("LLWEAPONEX_Scythe", TranslatedString:Create("h1e98bd0bg867dg4a57gb2d4g6d820b4e7dfa", "<font color='#AA11CC'>Scythe Mastery</font>"), {
	[0] = TranslatedString:Create("h7277340dgb5a1g456cgb92agb687000a31cb", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("h98918309g3e13g449dga904gca8263e76077", "<font color='#CCDA9E'>Novice</font>"),
	[2] = TranslatedString:Create("h4e16f727gb7ceg4c04gac4ag25307029297a", "<font color='#C8FBFF'>Journeyman Reaper</font>"),
	[3] = TranslatedString:Create("h5d62b911g9204g4b88ga279gf899e1290b73", "<font color='#96F8FF'>Expert Reaper</font>"),
	[4] = TranslatedString:Create("h414c2944gf959g41bcgb30fg311454127738", "<font color='#73FFCC'>Reaper of Souls</font>"),
}),
["LLWEAPONEX_Shield"] = MasteryData:Create("LLWEAPONEX_Shield", TranslatedString:Create("h9ffd7826g03eeg4597gad11g03c6b56e547c", "<font color='#AE9F95'>Shield Mastery</font>"), {
	[0] = TranslatedString:Create("h107780b5g9816g4eeag923egf088d7d8e242", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("hbf033931gc683g4730gb293g5b65501d0d06", "<font color='#CCDA9E'>Novice</font>"),
	[2] = TranslatedString:Create("h96519d70gf99cg45f3g9108gc02e00ba27ae", "<font color='#CCC973'>Journeyman Shieldsman</font>"),
	[3] = TranslatedString:Create("h00d6bd55ga775g45c7ga2c3ga181ec3f950c", "<font color='#CCB94A'>Expert Shieldsman</font>"),
	[4] = TranslatedString:Create("h2c65600bg0fe8g4898g9a07g6d75f4e8f37d", "<font color='#CC9E03'>Shieldmaster</font>"),
}),
["LLWEAPONEX_Staff"] = MasteryData:Create("LLWEAPONEX_Staff", TranslatedString:Create("h1f41efdegb2b0g4f80gab7cg28b15d2c0039", "<font color='#2EFFE9'>Arcane Staff Mastery</font>"), {
	[0] = TranslatedString:Create("h58711edbg90e3g4c5bgada2g8453b1e7554f", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("he041dc61g19acg4056g9482geb3302da7927", "<font color='#D1F8FF'>Novice</font>"),
	[2] = TranslatedString:Create("hc8394097g41d6g4841gb16ag20c57c59c3cb", "<font color='#9BF0FF'>Journeyman Staff Acolyte</font>"),
	[3] = TranslatedString:Create("h48e0e878g1bd3g465dg8fc5g14a50291ffd3", "<font color='#77E9FE'>Expert Staffmeister</font>"),
	[4] = TranslatedString:Create("h0c5f4242g43beg4425g99b4ge609bc89d9cc", "<font color='#5EDBFF'>Sage of Staves</font>"),
}),
["LLWEAPONEX_Sword"] = MasteryData:Create("LLWEAPONEX_Sword", TranslatedString:Create("hd7347120gcb02g4fdcgaddcg282a83a42d58", "<font color='#FF3E2A'>Sword Mastery</font>"), {
	[0] = TranslatedString:Create("h0a993e92g6c54g4951ga8abg59cdd28cd14d", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("hf64fac40g06e6g4e41gb191g0aaf9cbc8d8b", "<font color='#FFAC99'>Novice</font>"),
	[2] = TranslatedString:Create("hab688a4ag277dg45ffgaa09g4bedd5d2bf27", "<font color='#FF9178'>Journeyman Swordsman</font>"),
	[3] = TranslatedString:Create("h5f43361agb604g44beg8cdegf1e06dd14fb0", "<font color='#FF7251'>Expert Swordsman</font>"),
	[4] = TranslatedString:Create("h485b2ba6g6da5g4d12gbbdag54371429702b", "<font color='#FF662A'>Swordmaster</font>"),
}),
["LLWEAPONEX_ThrowingAbility"] = MasteryData:Create("LLWEAPONEX_ThrowingAbility", TranslatedString:Create("hc4bf9383ga9b2g48fcgb253gcc7546987b56", "<font color='#40E0D0'>Throwing Ability Mastery</font>"), {
	[0] = TranslatedString:Create("h2effed72g3fcag4620gb39dg6faf68f3ae6f", "<font color='#FFEAEA'>Beginner</font>"),
	[1] = TranslatedString:Create("hcb68c45bg3711g4cccg9094gd6c81f6aa000", "<font color='#FF9D9D'>Novice</font>"),
	[2] = TranslatedString:Create("h450704d2g528dg4032g9da7g77a6ad86beea", "<font color='#F56CA3'>Journeyman Thrower</font>"),
	[3] = TranslatedString:Create("h9ed6820agdf93g47f1g9da6ge9a4552d014c", "<font color='#F56C8C'>Expert Thrower</font>"),
	[4] = TranslatedString:Create("h5f751ba5g27deg4581gb1b2gf59ab659113f", "<font color='#FF3376'>Master Thrower</font>"),
}),
["LLWEAPONEX_Unarmed"] = MasteryData:Create("LLWEAPONEX_Unarmed", TranslatedString:Create("h1e98bcebg2e42g4699gba2bg6f647d428699", "<font color='#FF44FF'>Unarmed Mastery</font>"), {
	[0] = TranslatedString:Create("h8b4ca477gf0e1g4375ga6c3g3b20035d337c", "<font color='#EAFFFE'>Beginner</font>"),
	[1] = TranslatedString:Create("h772c1170geb23g42c0gba32gb27e108379a6", "<font color='#9DFCFF'>Novice</font>"),
	[2] = TranslatedString:Create("h18a5ea22gd8b0g423bga26fg4a2941611cf3", "<font color='#6CE3F5'>Scrapper</font>"),
	[3] = TranslatedString:Create("hd5cefba2g5104g48d2gb6a5g10eb32769d79", "<font color='#6CF5E9'>Elite Brawler</font>"),
	[4] = TranslatedString:Create("h81cd05aag77afg4898g87d6g6ae61536a4bf", "<font color='#33FFB8'>Master Pugilist</font>"),
}),
["LLWEAPONEX_Wand"] = MasteryData:Create("LLWEAPONEX_Wand", TranslatedString:Create("h8bf31994gb4a2g4423g949dg8102095a66ea", "<font color='#B658FF'>Wand Mastery</font>"), {
	[0] = TranslatedString:Create("he9479d69g5b24g4f51gb944g6e59f5f5ec2b", "<font color='#FDFFEA'>Beginner</font>"),
	[1] = TranslatedString:Create("hbcc9ce2bg78fcg431dgabe6g1c3951ada646", "<font color='#D8BAFD'>Novice</font>"),
	[2] = TranslatedString:Create("h0b69be34ge862g4a82gaea2g87abee3e57b4", "<font color='#C596FE'>Journeyman of Wands</font>"),
	[3] = TranslatedString:Create("h649f61ffg8842g40f4g8272gbfd109a337a9", "<font color='#B274FF'>Expert of Wands</font>"),
	[4] = TranslatedString:Create("ha70b98fbg18f9g48eegbc7dge24d718e21be", "<font color='#D258FF'>Master Wandweaver</font>"),
}),
}