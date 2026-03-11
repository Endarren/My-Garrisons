MyGarrisons = LibStub("AceAddon-3.0"):NewAddon("MyGarrisons", "AceConsole-3.0","AceComm-3.0", "AceEvent-3.0", "AceTimer-3.0","AceHook-3.0");

local TimerFilterItems = {TimerType = {Missions = true, Shipments = true}} --TODO
local SortItems = {}--TODO
-- =================================================================================================
-- Characters
-- =================================================================================================

function MyGarrisons:AddCharacter(characterID, realmID)
local classDisplayName, class, classID = UnitClass("player");
local	factionGroup, factionName = UnitFactionGroup("player") 
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID] = {
		Settings = {	Colors =  {}, 
						Filters = {}, 
						Alpha = 1,
						ShowOnLogIn = true,
						Sorting =	{	
										Buildings = {
														Direction = 1,
														Weights = {}
													}, 
										Missions = {
														Direction = 1,
														Weights = {}
													}
									}
					},
		Garrison = {
						Class = classID,
						HasGarrison = false,
						GarrisonLevel = 0,
						Cache = {LastCheck = 0, Amount = 0},
						Buildings = {},
						Followers = {},
		},
		Missions = {},
		AvaliableMissions = {},
		Faction = factionGroup
	
	
	
	}
	MyGarrisons:QUEST_FINISHED()
end
function MyGarrisons:RemoveCharacter(characterID, realmID)

end


-- =================================================================================================
-- Buildings
-- =================================================================================================
local BuildingIDSets = {}
BuildingIDSets["mining"] = 			{61, 62, 63}

BuildingIDSets["herb"] = 			{29, 136, 137}--, NextCrop = ""

BuildingIDSets["enchanting"] = 		{93, 125, 126}

BuildingIDSets["tailoring"] = 		{94, 127, 128}

BuildingIDSets["engineering"] = 	{91, 123, 124}

BuildingIDSets["leatherworking"] =	{90, 121, 122}

BuildingIDSets["inscription"] = 	{95, 129, 130}

BuildingIDSets["jewelcrafting"] = 	{96, 131, 132}

BuildingIDSets["blacksmith"] = 		{60, 117, 118}

BuildingIDSets["alchemy"] = 		{76, 119, 120}

BuildingIDSets["fishing"] = 		{64, 134, 135}

BuildingIDSets["stable"] = 			{65, 66, 67}

BuildingIDSets["salvage"] = 		{52, 140, 141}

BuildingIDSets["storage"] = 		{51, 142, 143}

BuildingIDSets["barn"] = 			{24, 25, 133}

BuildingIDSets["pet"] = 			{42, 167, 168}

BuildingIDSets["lumber"] = 			{40, 41, 138}

BuildingIDSets["tech"] = 			{162, 163, 164}

BuildingIDSets["war"] = 			{8, 9, 10}

BuildingIDSets["barracks"] = 		{26,27,28}

BuildingIDSets["inn"] = 			{34, 35, 36}

BuildingIDSets["portal"] = 			{37, 38, 39}

BuildingIDSets["arena"] = 			{159, 160, 161}

BuildingIDSets["trade"] = 			{111, 144, 145}


local BuildingSpecialDatas = {}

--Stables
--{65, 66, 67}
--Mounts:  
--171831		Trained Silverpelt
--171617		Trained Icehoof
--171637		Trained Rocktusk
--171638		Trained Riverwallow
--171841		Trained Snarler
--171623		Trained Meadowstomper

BuildingSpecialDatas[65] = {Mounts = {}}
--171831		Trained Silverpelt
BuildingSpecialDatas[65].Mounts[171831] = {	
	{Quests = {36911,36917}, Completed = false},
	{Quests = {36971,37093}, Completed = false},	
	{Quests = {36972,37094}, Completed = false},
	{Quests = {36973,37095}, Completed = false},
	{Quests = {36974,37096}, Completed = false},
	{Quests = {36975,37097}, Completed = false},
	{Quests = {36976,37098}, Completed = false},
	{Quests = {36977,37099}, Completed = false},
	{Quests = {36978,37100}, Completed = false},
	{Quests = {36979,37101}, Completed = false},
	{Quests = {36980,37102}, Completed = false},
	{Quests = {36981,37103}, Completed = false},
	{Quests = {36982,37104}, Completed = false}
}
--171617		Trained Icehoof
BuildingSpecialDatas[65].Mounts[171617] = {	
	{Quests = {36916,36912}, Completed = false},
	{Quests = {36983,37048}, Completed = false},	
	{Quests = {36984,37049}, Completed = false},
	{Quests = {36985,37050}, Completed = false},
	{Quests = {36986,37051}, Completed = false},
	{Quests = {36987,37052}, Completed = false},
	{Quests = {36988,37053}, Completed = false},
	{Quests = {36989,37054}, Completed = false},
	{Quests = {36990,37055}, Completed = false},
	{Quests = {36991,37056}, Completed = false},
	{Quests = {36992,37057}, Completed = false},
	{Quests = {36993,37058}, Completed = false},
	{Quests = {36994,37059}, Completed = false}
}
--171637		Trained Rocktusk
BuildingSpecialDatas[65].Mounts[171637] = {	
	{Quests = {36913,36944}, Completed = false},
	{Quests = {36995,37032}, Completed = false},
	{Quests = {36996,37033}, Completed = false},
	{Quests = {36997,37034}, Completed = false},
	{Quests = {36998,37035}, Completed = false},
	{Quests = {36999,37036}, Completed = false},
	{Quests = {37000,37037}, Completed = false},
	{Quests = {37001,37038}, Completed = false},
	{Quests = {37002,37039}, Completed = false},
	{Quests = {37003,37040}, Completed = false},
	{Quests = {37004,37041}, Completed = false}
}

--171638		Trained Riverwallow
BuildingSpecialDatas[65].Mounts[171638] = {	
	{Quests = {36918,36945}, Completed = false},
	{Quests = {37005,37071}, Completed = false},
	{Quests = {37006,37072}, Completed = false},
	{Quests = {37007,37073}, Completed = false},
	{Quests = {37008,37074}, Completed = false},
	{Quests = {37009,37075}, Completed = false},
	{Quests = {37010,37076}, Completed = false},
	{Quests = {37011,37077}, Completed = false},
	{Quests = {37012,37078}, Completed = false},
	{Quests = {37013,37079}, Completed = false}
}
--171841		Trained Snarler
BuildingSpecialDatas[65].Mounts[171841] = {	
	{Quests = {36914,36950}, Completed = false},
	{Quests = {37022,37105}, Completed = false},
	{Quests = {37023,37106}, Completed = false},
	{Quests = {37024,37107}, Completed = false},
	{Quests = {37025,37108}, Completed = false},
	{Quests = {37026,37109}, Completed = false},
	{Quests = {37027,37110}, Completed = false},
	{Quests = {37028,37111}, Completed = false}
}

--171623		Trained Meadowstomper
BuildingSpecialDatas[65].Mounts[171623] = {	
	{Quests = {36915,36946}, Completed = false},
	{Quests = {37015,37063}, Completed = false},
	{Quests = {37016,37064}, Completed = false},
	{Quests = {37017,37065}, Completed = false},
	{Quests = {37018,37066}, Completed = false},
	{Quests = {37019,37067}, Completed = false},
	{Quests = {37020,37068}, Completed = false},
	{Quests = {37021,37069}, Completed = false}
}
--{65, 66, 67}
BuildingSpecialDatas[66] = {Mounts = {}}
--171831		Trained Silverpelt
BuildingSpecialDatas[66].Mounts[171831] = {	
	{Quests = {36911,36917}, Completed = false},
	{Quests = {36971,37093}, Completed = false},	
	{Quests = {36972,37094}, Completed = false},
	{Quests = {36973,37095}, Completed = false},
	{Quests = {36974,37096}, Completed = false},
	{Quests = {36975,37097}, Completed = false},
	{Quests = {36976,37098}, Completed = false},
	{Quests = {36977,37099}, Completed = false},
	{Quests = {36978,37100}, Completed = false},
	{Quests = {36979,37101}, Completed = false},
	{Quests = {36980,37102}, Completed = false},
	{Quests = {36981,37103}, Completed = false},
	{Quests = {36982,37104}, Completed = false}
}
--171617		Trained Icehoof
BuildingSpecialDatas[66].Mounts[171617] = {	
	{Quests = {36916,36912}, Completed = false},
	{Quests = {36983,37048}, Completed = false},	
	{Quests = {36984,37049}, Completed = false},
	{Quests = {36985,37050}, Completed = false},
	{Quests = {36986,37051}, Completed = false},
	{Quests = {36987,37052}, Completed = false},
	{Quests = {36988,37053}, Completed = false},
	{Quests = {36989,37054}, Completed = false},
	{Quests = {36990,37055}, Completed = false},
	{Quests = {36991,37056}, Completed = false},
	{Quests = {36992,37057}, Completed = false},
	{Quests = {36993,37058}, Completed = false},
	{Quests = {36994,37059}, Completed = false}
}
--171637		Trained Rocktusk
BuildingSpecialDatas[66].Mounts[171637] = {	
	{Quests = {36913,36944}, Completed = false},
	{Quests = {36995,37032}, Completed = false},
	{Quests = {36996,37033}, Completed = false},
	{Quests = {36997,37034}, Completed = false},
	{Quests = {36998,37035}, Completed = false},
	{Quests = {36999,37036}, Completed = false},
	{Quests = {37000,37037}, Completed = false},
	{Quests = {37001,37038}, Completed = false},
	{Quests = {37002,37039}, Completed = false},
	{Quests = {37003,37040}, Completed = false},
	{Quests = {37004,37041}, Completed = false}
}

--171638		Trained Riverwallow
BuildingSpecialDatas[66].Mounts[171638] = {	
	{Quests = {36918,36945}, Completed = false},
	{Quests = {37005,37071}, Completed = false},
	{Quests = {37006,37072}, Completed = false},
	{Quests = {37007,37073}, Completed = false},
	{Quests = {37008,37074}, Completed = false},
	{Quests = {37009,37075}, Completed = false},
	{Quests = {37010,37076}, Completed = false},
	{Quests = {37011,37077}, Completed = false},
	{Quests = {37012,37078}, Completed = false},
	{Quests = {37013,37079}, Completed = false}
}
--171841		Trained Snarler
BuildingSpecialDatas[66].Mounts[171841] = {	
	{Quests = {36914,36950}, Completed = false},
	{Quests = {37022,37105}, Completed = false},
	{Quests = {37023,37106}, Completed = false},
	{Quests = {37024,37107}, Completed = false},
	{Quests = {37025,37108}, Completed = false},
	{Quests = {37026,37109}, Completed = false},
	{Quests = {37027,37110}, Completed = false},
	{Quests = {37028,37111}, Completed = false}
}

--171623		Trained Meadowstomper
BuildingSpecialDatas[66].Mounts[171623] = {	
	{Quests = {36915,36946}, Completed = false},
	{Quests = {37015,37063}, Completed = false},
	{Quests = {37016,37064}, Completed = false},
	{Quests = {37017,37065}, Completed = false},
	{Quests = {37018,37066}, Completed = false},
	{Quests = {37019,37067}, Completed = false},
	{Quests = {37020,37068}, Completed = false},
	{Quests = {37021,37069}, Completed = false}
}
----{65, 66, 67}
BuildingSpecialDatas[67] = {Mounts = {}}
--171831		Trained Silverpelt
BuildingSpecialDatas[67].Mounts[171831] = {	
	{Quests = {36911,36917}, Completed = false},
	{Quests = {36971,37093}, Completed = false},	
	{Quests = {36972,37094}, Completed = false},
	{Quests = {36973,37095}, Completed = false},
	{Quests = {36974,37096}, Completed = false},
	{Quests = {36975,37097}, Completed = false},
	{Quests = {36976,37098}, Completed = false},
	{Quests = {36977,37099}, Completed = false},
	{Quests = {36978,37100}, Completed = false},
	{Quests = {36979,37101}, Completed = false},
	{Quests = {36980,37102}, Completed = false},
	{Quests = {36981,37103}, Completed = false},
	{Quests = {36982,37104}, Completed = false}
}
--171617		Trained Icehoof
BuildingSpecialDatas[67].Mounts[171617] = {	
	{Quests = {36916,36912}, Completed = false},
	{Quests = {36983,37048}, Completed = false},	
	{Quests = {36984,37049}, Completed = false},
	{Quests = {36985,37050}, Completed = false},
	{Quests = {36986,37051}, Completed = false},
	{Quests = {36987,37052}, Completed = false},
	{Quests = {36988,37053}, Completed = false},
	{Quests = {36989,37054}, Completed = false},
	{Quests = {36990,37055}, Completed = false},
	{Quests = {36991,37056}, Completed = false},
	{Quests = {36992,37057}, Completed = false},
	{Quests = {36993,37058}, Completed = false},
	{Quests = {36994,37059}, Completed = false}
}
--171637		Trained Rocktusk
BuildingSpecialDatas[67].Mounts[171637] = {	
	{Quests = {36913,36944}, Completed = false},
	{Quests = {36995,37032}, Completed = false},
	{Quests = {36996,37033}, Completed = false},
	{Quests = {36997,37034}, Completed = false},
	{Quests = {36998,37035}, Completed = false},
	{Quests = {36999,37036}, Completed = false},
	{Quests = {37000,37037}, Completed = false},
	{Quests = {37001,37038}, Completed = false},
	{Quests = {37002,37039}, Completed = false},
	{Quests = {37003,37040}, Completed = false},
	{Quests = {37004,37041}, Completed = false}
}

--171638		Trained Riverwallow
BuildingSpecialDatas[67].Mounts[171638] = {	
	{Quests = {36918,36945}, Completed = false},
	{Quests = {37005,37071}, Completed = false},
	{Quests = {37006,37072}, Completed = false},
	{Quests = {37007,37073}, Completed = false},
	{Quests = {37008,37074}, Completed = false},
	{Quests = {37009,37075}, Completed = false},
	{Quests = {37010,37076}, Completed = false},
	{Quests = {37011,37077}, Completed = false},
	{Quests = {37012,37078}, Completed = false},
	{Quests = {37013,37079}, Completed = false}
}
--171841		Trained Snarler
BuildingSpecialDatas[67].Mounts[171841] = {	
	{Quests = {36914,36950}, Completed = false},
	{Quests = {37022,37105}, Completed = false},
	{Quests = {37023,37106}, Completed = false},
	{Quests = {37024,37107}, Completed = false},
	{Quests = {37025,37108}, Completed = false},
	{Quests = {37026,37109}, Completed = false},
	{Quests = {37027,37110}, Completed = false},
	{Quests = {37028,37111}, Completed = false}
}

--171623		Trained Meadowstomper
BuildingSpecialDatas[67].Mounts[171623] = {	
	{Quests = {36915,36946}, Completed = false},
	{Quests = {37015,37063}, Completed = false},
	{Quests = {37016,37064}, Completed = false},
	{Quests = {37017,37065}, Completed = false},
	{Quests = {37018,37066}, Completed = false},
	{Quests = {37019,37067}, Completed = false},
	{Quests = {37020,37068}, Completed = false},
	{Quests = {37021,37069}, Completed = false}
}
--Barracks

BuildingSpecialDatas[26] = {}

BuildingSpecialDatas[27] = {}
BuildingSpecialDatas[27][173660] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[27][173661] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[27][173976] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[27][173658] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[27][173659] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[27][173657] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[27][173649] = {TimeStarted = 0, IsDefeated = false, icon = ""}

BuildingSpecialDatas[28] = {}
BuildingSpecialDatas[28][173660] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[28][173661] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[28][173976] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[28][173658] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[28][173659] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[28][173657] = {TimeStarted = 0, IsDefeated = false, icon = ""}
BuildingSpecialDatas[28][173649] = {TimeStarted = 0, IsDefeated = false, icon = ""}
--Mine
BuildingSpecialDatas[61] = {UsedNodes = 0, MaxNodes = 8, ResetsAt = 0}
BuildingSpecialDatas[62] = {UsedNodes = 0, MaxNodes = 13, ResetsAt = 0}
BuildingSpecialDatas[63] = {UsedNodes = 0, MaxNodes = 18, ResetsAt = 0} --TODO verify max nodes
--Herb
--29, 136, 137
BuildingSpecialDatas[29] = {UsedNodes = 0, MaxNodes = 10, ResetsAt = 0, NextCrop = ""}
BuildingSpecialDatas[136] = {UsedNodes = 0, MaxNodes = 13, ResetsAt = 0, NextCrop = ""}
BuildingSpecialDatas[137] = {UsedNodes = 0, MaxNodes = 15, ResetsAt = 0, NextCrop = ""} --TODO verify max nodes
--Fishing
----HaveDaily, ResetsAt

--Pet
--{42, 167, 168}

	BuildingSpecialDatas[42] = {Quests ={}, ResetsAt =0, Completed = false}
BuildingSpecialDatas[42].Quests[36662] = 1
BuildingSpecialDatas[42].Quests[36483] = 1
BuildingSpecialDatas[167] = {Quests= {}, ResetsAt =0, Completed = false}
BuildingSpecialDatas[167].Quests[36662] = 1
BuildingSpecialDatas[167].Quests[36483] = 1
BuildingSpecialDatas[168] = {Quests= {}, ResetsAt =0, Completed = false}
BuildingSpecialDatas[168].Quests[37645] = 1
BuildingSpecialDatas[168].Quests[37644] = 1
--[[{Dailies = {Quests = {36469,36483

{IDs = {36662,36483}, Completed = false}
}, Amount = 1}, ResetsAt = 0}]]--

BuildingSpecialDatas[167] = {Dailies = {Quests = {

{IDs = {36662}, Completed = false}
}, Amount = 1}, ResetsAt = 0}

BuildingSpecialDatas[168] = {Dailies = {Quests = {

{IDs = {36483}, Completed = false}
}, Amount = 1}, ResetsAt = 0}
----HaveDaily1, HaveDaily2, ResetsAt

--36662  or  36483

--Mastering 37645  37644
--Portal
--{37, 38, 39}
BuildingSpecialDatas[37] = {Location1 = ""}
BuildingSpecialDatas[38] = {Location1 = "", Location2 = ""}
BuildingSpecialDatas[39] = {Location1 = "", Location2 = "", Location3 = ""}

--Tech
--{162, 163, 164}
----Gadets_Picked_Up = 0, MaxGadgets = #, Tank = false, ResetsAt
BuildingSpecialDatas[162] = {Items = {IDs = {}, Daily = 2}, ResetsAt = 0}

BuildingSpecialDatas[163] = {Items = {IDs = {}, Daily = 4}, ResetsAt = 0}

BuildingSpecialDatas[164] = {Items = {IDs = {}, Daily = 4}, Tank = false, ResetsAt = 0}


-- jewelcrafting
--{96, 131, 132}
BuildingSpecialDatas[96] = {}
BuildingSpecialDatas[131] = {Quests ={}, ResetsAt =0, Completed = false}
BuildingSpecialDatas[131].Quests[37320] = 1
BuildingSpecialDatas[131].Quests[37321] = 1
BuildingSpecialDatas[131].Quests[37323] = 1
BuildingSpecialDatas[131].Quests[37324] = 1
BuildingSpecialDatas[132] = {Quests= {}, ResetsAt =0, Completed = false}
BuildingSpecialDatas[132].Quests[37320] = 1
BuildingSpecialDatas[132].Quests[37321] = 1
BuildingSpecialDatas[132].Quests[37323] = 1
BuildingSpecialDatas[132].Quests[37324] = 1

--Fishing

--{64, 134, 135}
BuildingSpecialDatas[64] = {Quests = {IDs = {}, Daily = 1, ResetsAt = 0, Completed = false}}
BuildingSpecialDatas[134] = {Quests = {IDs = {}, Daily = 1, ResetsAt = 0, Completed = false}}
BuildingSpecialDatas[135] = {Quests = {IDs = {}, Daily = 1, ResetsAt = 0, Completed = false}}

BuildingSpecialDatas[64].Quests.IDs = {	35075,
										35074,
										35073, 
										35072, 
										35071, 
										35066, 
										36517, 
										36511,
										36515,
										36514,
										36513,
										36510}
BuildingSpecialDatas[134].Quests.IDs = {35075,
										35074,
										35073, 
										35072, 
										35071, 
										35066, 
										36517, 
										36511,
										36515,
										36514,
										36513,
										36510}
BuildingSpecialDatas[135].Quests.IDs = {35075,
										35074,
										35073, 
										35072, 
										35071, 
										35066, 
										36517, 
										36511,
										36515,
										36514,
										36513,
										36510}
function MyGarrisons:GetBuildingSpecialData(buildingID)
	return BuildingSpecialDatas[buildingID]

end
--[[
QuestsToWatchFor[35075] = {BuildingType = "fishing"}
QuestsToWatchFor[35074] = {BuildingType = "fishing"}
QuestsToWatchFor[35073] = {BuildingType = "fishing"}
QuestsToWatchFor[35072] = {BuildingType = "fishing"}
QuestsToWatchFor[35066] = {BuildingType = "fishing"}
QuestsToWatchFor[35071] = {BuildingType = "fishing"}

QuestsToWatchFor[36517] = {BuildingType = "fishing"}
QuestsToWatchFor[36511] = {BuildingType = "fishing"}
QuestsToWatchFor[36515] = {BuildingType = "fishing"}
QuestsToWatchFor[36514] = {BuildingType = "fishing"}
QuestsToWatchFor[36513] = {BuildingType = "fishing"}
QuestsToWatchFor[36510] = {BuildingType = "fishing"}
]]--


local QuestsToWatchFor = {}
-- =================================================================================
-- Pet Quests
QuestsToWatchFor[36662] = {BuildingType = "pet"}
QuestsToWatchFor[36483] = {BuildingType = "pet"}
QuestsToWatchFor[37645] = {BuildingType = "pet"}
QuestsToWatchFor[37644] = {BuildingType = "pet"}

-- =================================================================================
-- Fishing Quests

-- =================================================================================
-- jewelcrafting Quests
QuestsToWatchFor[37320] = {BuildingType = "jewelcrafting"}
QuestsToWatchFor[37321] = {BuildingType = "jewelcrafting"}
QuestsToWatchFor[37324] = {BuildingType = "jewelcrafting"}
QuestsToWatchFor[37323] = {BuildingType = "jewelcrafting"}
-- =================================================================================
-- Inn Quests
QuestsToWatchFor[37167] = {BuildingType = "inn"}
QuestsToWatchFor[37148] = {BuildingType = "inn"}
QuestsToWatchFor[37149] = {BuildingType = "inn"}
QuestsToWatchFor[37150] = {BuildingType = "inn"}
QuestsToWatchFor[37151] = {BuildingType = "inn"}
QuestsToWatchFor[37152] = {BuildingType = "inn"}
QuestsToWatchFor[37153] = {BuildingType = "inn"}
QuestsToWatchFor[37154] = {BuildingType = "inn"}
QuestsToWatchFor[37155] = {BuildingType = "inn"}
QuestsToWatchFor[37156] = {BuildingType = "inn"}
QuestsToWatchFor[37157] = {BuildingType = "inn"}
QuestsToWatchFor[37158] = {BuildingType = "inn"}
QuestsToWatchFor[37159] = {BuildingType = "inn"}
QuestsToWatchFor[37160] = {BuildingType = "inn"}
QuestsToWatchFor[37161] = {BuildingType = "inn"}
QuestsToWatchFor[37162] = {BuildingType = "inn"}
QuestsToWatchFor[37163] = {BuildingType = "inn"}
QuestsToWatchFor[37164] = {BuildingType = "inn"}
QuestsToWatchFor[37165] = {BuildingType = "inn"}
QuestsToWatchFor[37166] = {BuildingType = "inn"}
QuestsToWatchFor[36813] = {BuildingType = "inn"}
QuestsToWatchFor[37179] = {BuildingType = "inn"}

QuestsToWatchFor[37228] = {BuildingType = "inn"}
QuestsToWatchFor[37243] = {BuildingType = "inn"}
QuestsToWatchFor[37230] = {BuildingType = "inn"}
QuestsToWatchFor[37235] = {BuildingType = "inn"}
QuestsToWatchFor[37239] = {BuildingType = "inn"}
QuestsToWatchFor[37241] = {BuildingType = "inn"}
QuestsToWatchFor[37242] = {BuildingType = "inn"}
QuestsToWatchFor[37229] = {BuildingType = "inn"}
QuestsToWatchFor[37238] = {BuildingType = "inn"}
QuestsToWatchFor[37232] = {BuildingType = "inn"}
QuestsToWatchFor[37234] = {BuildingType = "inn"}
QuestsToWatchFor[37233] = {BuildingType = "inn"}
QuestsToWatchFor[37240] = {BuildingType = "inn"}
QuestsToWatchFor[37231] = {BuildingType = "inn"}
QuestsToWatchFor[37237] = {BuildingType = "inn"}
QuestsToWatchFor[37236] = {BuildingType = "inn"}
QuestsToWatchFor[37244] = {BuildingType = "inn"}
QuestsToWatchFor[37146] = {BuildingType = "inn"}
QuestsToWatchFor[37227] = {BuildingType = "inn"}
QuestsToWatchFor[37142] = {BuildingType = "inn"}
QuestsToWatchFor[37147] = {BuildingType = "inn"}
QuestsToWatchFor[37245] = {BuildingType = "inn"}

-- =================================================================================
--Stables  171831		Trained Silverpelt
QuestsToWatchFor[36911] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36971] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36972] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36973] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36974] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36975] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36976] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36977] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36978] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36979] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36980] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36981] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[36982] = {BuildingType = "stable", Mount = 171831}

QuestsToWatchFor[36917] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37093] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37094] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37095] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37096] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37097] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37098] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37099] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37100] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37101] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37102] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37103] = {BuildingType = "stable", Mount = 171831}
QuestsToWatchFor[37104] = {BuildingType = "stable", Mount = 171831}
-- =================================================================================
--Stables  171617		Trained Icehoof
QuestsToWatchFor[36916] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36983] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36984] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36985] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36986] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36987] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36988] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36989] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36990] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36991] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36992] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36993] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[36994] = {BuildingType = "stable", Mount = 171617}

QuestsToWatchFor[36912] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37048] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37049] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37050] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37051] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37052] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37053] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37054] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37055] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37056] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37057] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37058] = {BuildingType = "stable", Mount = 171617}
QuestsToWatchFor[37059] = {BuildingType = "stable", Mount = 171617}

-- =================================================================================
--Stables  171637		Trained Rocktusk
QuestsToWatchFor[36913] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[36995] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[36996] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[36997] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[36998] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[36999] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37000] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37001] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37002] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37003] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37004] = {BuildingType = "stable", Mount = 171637}

QuestsToWatchFor[36944] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37032] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37033] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37034] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37035] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37036] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37037] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37038] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37039] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37040] = {BuildingType = "stable", Mount = 171637}
QuestsToWatchFor[37041] = {BuildingType = "stable", Mount = 171637}

-- =================================================================================
--Stables 171638		Trained Riverwallow
QuestsToWatchFor[36918] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37005] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37006] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37007] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37008] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37009] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37010] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37011] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37012] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37013] = {BuildingType = "stable", Mount = 171638}

QuestsToWatchFor[36945] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37071] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37072] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37073] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37074] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37075] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37076] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37077] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37078] = {BuildingType = "stable", Mount = 171638}
QuestsToWatchFor[37079] = {BuildingType = "stable", Mount = 171638}

-- =================================================================================
--Stables 171841		Trained Snarler
QuestsToWatchFor[36914] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37022] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37023] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37024] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37025] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37026] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37027] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37028] = {BuildingType = "stable", Mount = 171841}

QuestsToWatchFor[36950] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37105] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37106] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37107] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37108] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37109] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37110] = {BuildingType = "stable", Mount = 171841}
QuestsToWatchFor[37111] = {BuildingType = "stable", Mount = 171841}
-- =================================================================================
--Stables 171623		Trained Meadowstomper
QuestsToWatchFor[36915] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37015] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37016] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37017] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37018] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37019] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37020] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37021] = {BuildingType = "stable", Mount = 171623}

QuestsToWatchFor[36946] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37063] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37064] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37065] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37066] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37067] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37068] = {BuildingType = "stable", Mount = 171623}
QuestsToWatchFor[37069] = {BuildingType = "stable", Mount = 171623}
-- =================================================================================
--Fishing Dailies
--fishing
QuestsToWatchFor[35075] = {BuildingType = "fishing"}
QuestsToWatchFor[35074] = {BuildingType = "fishing"}
QuestsToWatchFor[35073] = {BuildingType = "fishing"}
QuestsToWatchFor[35072] = {BuildingType = "fishing"}
QuestsToWatchFor[35066] = {BuildingType = "fishing"}
QuestsToWatchFor[35071] = {BuildingType = "fishing"}

QuestsToWatchFor[36517] = {BuildingType = "fishing"}
QuestsToWatchFor[36511] = {BuildingType = "fishing"}
QuestsToWatchFor[36515] = {BuildingType = "fishing"}
QuestsToWatchFor[36514] = {BuildingType = "fishing"}
QuestsToWatchFor[36513] = {BuildingType = "fishing"}
QuestsToWatchFor[36510] = {BuildingType = "fishing"}

local BuildingShipmentSpells = {}


BuildingShipmentSpells[172859]  = {Item = 111556, Details = ""}--Tailoring
--{64, 134, 135}

function MyGarrisons:AddBuildingToCharacter(characterID, realmID, buildingID, Plot)

--TODO check to see if the player has a lower level version of this building.

--TODO If the player does have a lower level version, do Update.
--TODO Else add new building.

	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID] = 
	{
		PlotID = Plot,
		WorkOrderQueue = {},
		FinishedWorkOrders = {},
		MaxWorkOrders = 0,
		WorkOrderStartTime = 0,
		SpecialData = {},
		AssignedFollower = 0,
		UnderConstruction = false,
		ConstructionStartTime = 0,

	}
	--BuildingSpecialDatas
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData = BuildingSpecialDatas[buildingID];
--TODO Add special data for the building.

end
function MyGarrisons:UpgradeBuildingTo(characterID, realmID, buildingID1, buildingID2)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1] ~= nil then
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID2] = 
	{
		PlotID = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].PlotID,
		WorkOrderQueue = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].WorkOrderQueue,
		FinishedWorkOrders = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].FinishedWorkOrders,
		MaxWorkOrders = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].MaxWorkOrders,
		WorkOrderStartTime = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].WorkOrderStartTime,
		SpecialData = BuildingSpecialDatas[buildingID2],
		AssignedFollower = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].AssignedFollower,
		UnderConstruction = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].UnderConstruction,
		ConstructionStartTime = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].ConstructionStartTime
	}
		--TODO update work order max and times.
		 MyGarrisons:UpgradeSpecialData(characterID, realmID, buildingID1, buildingID2)
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1] = nil
	else
		
	
	end
end

function MyGarrisons:UpgradeSpecialData(characterID, realmID, buildingID1, buildingID2)
	--TODO
	--Mine Upgrade


	--Herb Farm upgrade

	--Barn Upgrade

	--Inn

	--Arena

	--Stables 

	--Portal
	if buildingID2 == 37 or buildingID2 == 38 then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID2].SpecialData = BuildingSpecialDatas[buildingID2]
		for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].SpecialData) do
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID2].SpecialData[k] = v
		end
	end
	--Pet
	if buildingID2 == 42 or buildingID2 == 167 then
	
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID2].SpecialData = BuildingSpecialDatas[buildingID2]
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID2].SpecialData.Dailies.Quests.Completed = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].SpecialData.Dailies.Quests.Completed
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID2].SpecialData.ResetsAt = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].SpecialData.ResetsAt
	end
	if buildingID2 == 66 or buildingID2 == 67 then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID2].SpecialData =MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID1].SpecialData
	end
end
local BuildingDetectedTable = {}
function MyGarrisons:ScanQuests()
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName ()

	for k,v in pairs (QuestsToWatchFor) do
		if IsQuestFlaggedCompleted(k) then
			--{64, 134, 135}
			--Fishing
			if v.BuildingType == "fishing" then
				if	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[64] ~= nil then
						MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[64].SpecialData.Quests.Completed = true
				end
				if	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[134] ~= nil then
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[134].SpecialData.Quests.Completed = true
				end
				if	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[135] ~= nil then
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[135].SpecialData.Quests.Completed = true
				end
			end
			--{65, 66, 67}
	--stables
			if v.BuildingType == "stable" then
				if	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[65] ~= nil then
					local mountspell = v.Mount
					if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[65].SpecialData == nil then
						MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[65].SpecialData =BuildingSpecialDatas[65]
					end
					for k2, v2 in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[65].SpecialData.Mounts[mountspell]) do
						if v2.Quests[1] == k or v2.Quests[2] == k then
							v2.Completed = true
						end
					end
				end
				if	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[66] ~= nil then
local mountspell = v.Mount
					if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[66].SpecialData == nil then
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[66].SpecialData =BuildingSpecialDatas[66]
					end
					for k2, v2 in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[66].SpecialData.Mounts[mountspell]) do
						if v2.Quests[1] == k or v2.Quests[2] == k then
							v2.Completed = true
						end
					end
				end
				if	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[67] ~= nil then
	local mountspell = v.Mount
					if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[67].SpecialData == nil then
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[67].SpecialData =BuildingSpecialDatas[67]
					end
					for k2, v2 in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[67].SpecialData.Mounts[mountspell]) do
						if v2.Quests[1] == k or v2.Quests[2] == k then
							v2.Completed = true
						end
					end
	
				end
			end
		end
	end
	
end
function MyGarrisons:ScanGarrison()
BuildingDetectedTable = {}
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName ()
	
	for k,v in pairs (C_Garrison.GetBuildings()) do 
		
		local buildInfo = {C_Garrison.GetBuildingInfo(v.buildingID)}
		BuildingDetectedTable[v.buildingID] = true
		--print(v.buildingID)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v.buildingID] == nil then
			MyGarrisons:AddBuildingToCharacter(characterID, realmID, v.buildingID, v.plotID)
		end

			--[[local foll = MyGarrisons:GetFollowersForBuilding(nam, GetRealmName(), v.buildingID)
			

			local buildInfo = {C_Garrison.GetBuildingInfo(v.buildingID)}
			MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Buildings[k] = {PlotID = v.plotID, 
			ID = v.buildingID, 
			BuildingName = buildInfo[2],
			Icon = buildInfo[4],
			Level = buildInfo[6],
			Follower = foll,
			SpecialData = {}}]]--
											--C_Garrison.GetFollowerInfoForBuilding

		--123
	end
	for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings) do
		if BuildingDetectedTable[k] == nil then
		--	print("Building "..k.." not detected")
			--Finding the possible upgrade.
			local key = nil
			for k2, v2 in pairs (BuildingIDSets) do
				for k3, v3 in pairs (v2) do
					if v3 == k then
						key = k2
					end
				end
			end
			if BuildingIDSets[key] ~= nil then
				for k2, v2 in pairs (BuildingIDSets[key]) do --TODO unknown error
					if BuildingDetectedTable[v2] ~= nil then
					--	print("Building was upgraded to "..v2)
						MyGarrisons:UpgradeBuildingTo(characterID, realmID, k, v2)
						MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[k] = nil
					end
				end
			else
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[k] = nil
			end
			if key == nil then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[k] = nil
			end
		end
	
	end


--TODO update stable special data

--[[

	BuildingDetectedTable = nil
	BuildingDetectedTable = {}
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName()
	for k,v in pairs (C_Garrison.GetBuildings()) do 
		BuildingDetectedTable[v.buildingID] = true
			--local foll = MyGarrisons:GetFollowersForBuilding(characterID, GetRealmName(), v.buildingID)
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v.buildingID] == nil then

				local buildInfo = {C_Garrison.GetBuildingInfo(v.buildingID)}
				MyGarrisons:AddBuildingToCharacter(characterID, realmID, v.buildingID, v.plotID)
				print("Adding "..v.buildingID)
											--C_Garrison.GetFollowerInfoForBuilding
			else
				print("Already have building "..v.buildingID)
			end
		--123
	end
	for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings) do
		if BuildingDetectedTable[k] == nil then
			print("Building "..k.." not detected")
			--Finding the possible upgrade.
			local key = nil
			for k2, v2 in pairs (BuildingIDSets) do
				for k3, v3 in pairs (v2) do
					if v3 == k then
						key = k2
					end
				end
			end
			for k2, v2 in pairs (BuildingIDSets[key]) do
				if BuildingDetectedTable[v2] ~= nil then
					print("Building was upgraded to "..v2)
				end
			end
		end
	
	end]]--
end
function MyGarrisons:FollowerToBuilding(plotInstanceID,followerID)
	local nam, realmi = UnitName("player")
	MyGarrisons:AddFollowerToBuilding(nam, GetRealmName(), plotInstanceID, followerID)
end
function MyGarrisons:AddFollowerToBuilding(characterID, realmID, plotID, followerID)
	for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings) do
		if v.PlotID == plotID then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[k].AssignedFollower = followerID
		end
	end
	
end
local upgradesDetected = {}
function MyGarrisons:GetPlotsBuilding(plotID)
	local nam, realmi = UnitName("player")
	for k,v in pairs(MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Constructions)do
		if MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Constructions[k].PlotID == plotID then
			return k
		end
	end

end
function MyGarrisons:FindLowerLevelOfBuilding(buildingID, characterID, realmID)

	local buildingType = ""
	local buildingIndex = 0
	for k,v in pairs (BuildingIDSets) do

		for k2, v2 in pairs (v) do
			if v2 == buildingID then
				buildingIndex = k2
				buildingType = k
			end
		end
	end

	return BuildingIDSets[buildingType][buildingIndex], BuildingIDSets[buildingType][buildingIndex+1]
	
	--MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings

end
function MyGarrisons:UpgradeBuildingInDatabase(oldID, newID)

--TODO
end
function MyGarrisons:UpgradeBuilding(plotID)
	--MyGarrisons:ScanGarrison()
	upgradesDetected[plotID] = true
	local buildingID =  0
	for k,v in pairs(C_Garrison.GetBuildings()) do
		if v.plotID == plotID then
			buildingID = v.buildingID
		end
	end

	local buildingInfo			= {C_Garrison.GetBuildingInfo(buildingID)};
	local timeStrEnd = buildingInfo[10];

	local endTime = MyGarrisons:buildingTimeToSeconds(timeStrEnd)
	
	local timeStr				= buildingInfo[9];
	local characterID, realmi	= UnitName("player")
	local realmID				= GetRealmName()
	local oldBuildingID, neoBuildingID	= MyGarrisons:FindLowerLevelOfBuilding(buildingID, characterID, realmID)

	--print("Upgrading "..oldBuildingID.." to "..neoBuildingID)

	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[neoBuildingID] = {

		PlotID					= MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[oldBuildingID].PlotID,
		WorkOrderQueue			= MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[oldBuildingID].WorkOrderQueue,
		FinishedWorkOrders		= MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[oldBuildingID].FinishedWorkOrders,
		MaxWorkOrders			= MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[oldBuildingID].MaxWorkOrders,--TODO update Max
		WorkOrderStartTime		= MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[oldBuildingID].WorkOrderStartTime,
		SpecialData				= MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[oldBuildingID].SpecialData,
		AssignedFollower		= MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[oldBuildingID].AssignedFollower,
		UnderConstruction		= true,
		ConstructionStartTime	= time(),
		ConstructionDoneTime = endTime  --TODO

	}
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[oldBuildingID] = nil
--	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID] = 
--	{
--		PlotID = Plot,
--		WorkOrderQueue = {},
--		FinishedWorkOrders = {},
--		MaxWorkOrders = 0,
--		WorkOrderStartTime = 0,
--		SpecialData = {},
--		AssignedFollower = 0,
--		UnderConstruction = false,
--		ConstructionStartTime = 0
--	}
	
	--TODO  Update Building Timer UI
end

function MyGarrisons:GetPlotsBuilding(plotID)
	local characterID, realmi = UnitName("player")
	for k,v in pairs(MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings)do
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[k].PlotID == plotID then
			return k
		end
	end

end
function MyGarrisons:FollowerFromBuilding(plotInstanceID,followerID)
	local nam, realmi = UnitName("player")
	MyGarrisons:RemoveFollowerToBuilding(nam, GetRealmName(), plotInstanceID)
end
function MyGarrisons:RemoveFollowerToBuilding(characterID, realmID, plotID)
	for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings) do
		if v.PlotID == plotID then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[k].AssignedFollower = 0
		end
	end
	
end
function MyGarrisons:RemoveBuildingFromCharacter(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID] ~= nil then
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID] ~= nil then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID] = nil
		end
	end
	--TODO Update UI
end
---- =================================================================================
----	Construction 
---- =================================================================================
function MyGarrisons:AddConstruction(characterID, realmID, plotInstanceID, buildingID)
	local buildingInfo = {C_Garrison.GetBuildingInfo(buildingID)}
	
	
	local buildingInfo = {C_Garrison.GetBuildingInfo(buildingID)};
	local timeStr = buildingInfo[10];
	
		--local missionTimeString = C_Garrison.GetMissionTimes(missionID)
		--print(strfind(C_Garrison.GetMissionTimes(missionID),missionTimeStringPattern))
		--print(strfind(C_Garrison.GetMissionTimes(missionID),"%d*%s?%l*%s?%d*%s?%l* (%d+) %l* %d*%s?%l*%s?%d*%s?%l* (%d+) %l*"))
		--local start, endS, num1, num2 = strfind(missionTimeString, missionTimeStringPattern)
	--	local a = {C_Garrison.GetMissionTimes(missionID)}
	--	local totalSeconds = tonumber(a[2]) + tonumber(a[5])
	--	d2.second = d2.second + totalSeconds
	
	--TODO compute end time.
	--[[	MyGarrisons.db.global.Garrisons[name.."-"..realm].Constructions[buildingID] = {
			PlotID = plotInstanceID,
			BuildingID = buildingID,
			StartTime = Meta.__tostring(caldate:parse(date("%m_%d_%y/%H:%M:%S"))),
			EndTimer  = Meta.__tostring(d2),
			BuildingName = buildingInfo[2]
		
		}]]--
end


---- =================================================================================
----	Building Special Data
---- =================================================================================
function MyGarrisons:SetupBuildingSpecialData(building, buildingID)
	--TODO building Type ID


end
------ =================================================================================
------		Building Special Data Nodes
------ =================================================================================
function MyGarrisons:UseBuildingNode(characterID, realmID, buildingID)

	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes + 1
end
function MyGarrisons:ResetBuildingNodes(characterID, realmID, buildingID)
	--TODO check if time to reset
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes = 0
end


------ =================================================================================
------		Building Special Data Gadgets
------ =================================================================================
local GadgetItemIDs = {}
GadgetItemIDs[119158] = true
GadgetItemIDs[114974] = true
GadgetItemIDs[114246] = true
GadgetItemIDs[114744] = true
GadgetItemIDs[115530] = true
GadgetItemIDs[114983] = true
GadgetItemIDs[114924] = true
GadgetItemIDs[114244] = true
GadgetItemIDs[114633] = true

function MyGarrisons:PickedUpGadget(characterID, realmID, itemID)
	--TODO
	--MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData

end
---- =================================================================================
----	Search
---- =================================================================================
function MyGarrisons:CharacterHasBuildingofType(characterID, realmID, buildingType)
	--TODO check to see if any of the building ID as in the character's buildings, if so return true.
	return false
end
-- =================================================================================================
-- Work Orders
-- =================================================================================================
function MyGarrisons:AddWorkOrderToBuilding(characterID, realmID, buildingID, orderType)
	--print("Order started "..buildingID)
	tinsert(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue,orderType)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime == 0 then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime = time()
	end
	--TODO add orderType and startTime and/or endtime to end of WorkOrderQueue.
	--[[if #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue == 0 then
		tinsert(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue,orderType)
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime = time()
	else
		tinsert(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue,orderType)
	end]]--

end
function MyGarrisons:FinishWorkOrder(characterID, realmID, buildingID)
	--TODO Put finished order at the end of FinishedWorkOrders.
	--TODO Remove the order from the beginning of WorkOrderQueue.
	local computedEndTime = MyGarrisons.db.global.MGRealms[realmID].Garrisons[characterID][buildingID].WorkOrderStartTime
	tinsert(MyGarrisons.db.global.MGRealms[realmID].Garrisons[characterID][buildingID].FinishedWorkOrders,MyGarrisons.db.global.MGRealms[realmID].Garrisons[characterID][buildingID].WorkOrderQueue[1])
	tremove(MyGarrisons.db.global.MGRealms[realmID].Garrisons[characterID][buildingID].WorkOrderQueue, 1)

	if #MyGarrisons.db.global.MGRealms[realmID].Garrisons[characterID][buildingID].WorkOrderQueue == 0 then
		--WorkOrderStartTime = -1
		
	else
		--WorkOrderStartTime
	end

end
function MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
--	C_Garrison.RequestLandingPageShipmentInfo()
	local CurrentStartTime = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime
	local queuedOrders = #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
	local duration =MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration

	if duration ~= nil then
		while CurrentStartTime + duration < time() and CurrentStartTime ~= 0 do
	
			tinsert(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders,
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue[1])
			tremove(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue, 1)
			if #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue ~= 0 then
				CurrentStartTime = CurrentStartTime + duration
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime=CurrentStartTime
			else
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime = 0
				CurrentStartTime = 0
			end
		end
	end

end
function MyGarrisons:AddFinishedShipment(characterID, realmID, buildingID)

	--tinsert(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders,
end
function MyGarrisons:CheckBuildingWorkOrders(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Garrisons[characterID][buildingID].UnderConstruction == false then
	
	end
end

function MyGarrisons:ShipmentScan()
	--TODO
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName()
	local shipmentIndex = 1;
    local buildings = C_Garrison.GetBuildings();
    for i = 1, #buildings do
        local buildingID = buildings[i].buildingID;
        if ( buildingID ) then
            local name, texture, MaxShipments, ReadyShipments, pendings, StartTime, Duration, TimeLeftString, itemIcon, itemQuality, itemID = C_Garrison.GetLandingPageShipmentInfo(buildingID);
           if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID] == nil then
			MyGarrisons:AddBuildingToCharacter(characterID, realmID, buildingID,  buildings[i].plotID)
		   end
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration == nil then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration = Duration
			   
		   end
			
            if ( name and pendings ~= nil ) then
		--		print(StartTime)
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration = 	Duration	
				
				if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration == nil then
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration = Duration
			   
				end
				MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders = MaxShipments
			--	print("Ready: "..ReadyShipments.."\ Pending: "..pendings.."\ duration: "..Duration)
			--	print()
				if pendings ~= #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue or ReadyShipments ~= #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders then
				--	print(pendings)
				--	print(ReadyShipments)
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue = {}
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders = {}
					for i = 1, ReadyShipments do
						tinsert(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders, {Item =0})
					end
					for i = 1, pendings do
						tinsert(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue, {Item =0})
					end
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime = StartTime
				end
				--if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime == 0 then
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime = StartTime
				--end
				--local namei, linki, qualityi, iLeveli, reqLeveli, classi, subclassi, maxStacki, equipSloti, texturei, vendorPricei = GetItemInfo(itemID) 
				--print(name.."  "..ReadyShipments.." "..(pendings - ReadyShipments).."/"..MaxShipments.."  of "..itemIcon)
				-- MyGarrisons.db.global.MGRealms[realmID].Garrisons[characterID][buildingID]
			--	if StartTime ~= nil and Duration ~= nil then
		
				--StartTime = caldate:parse( date("%m_%d_%y/%H:%M:%S"))
				--StartTime  = caldate:parse( date("%m_%d_%y/%H:%M:%S")).second +(Duration - MyGarrisons:buildingTimeToSeconds(TimeLeftString))
				--	print(StartTime )
					--:new( year, month, day, hour, minute, second )
				
				--print("SCANNER "..name.." "..shipmentsReady.." "..shipmentsTotal.."  "..pendings.."  "..  duration.."  "..timeleftString)
				--MyGarrisons:AddShipment(name, MaxShipments, pendings, ReadyShipments,  caldate:parse( date("%m_%d_%y/%H:%M:%S")), Duration, TimeLeftString)
				--else
				
				--
			end
		end
	end
end

-- =================================================================================================
-- Missions
-- =================================================================================================


local followersOnMission = {};
local MissionDataTable = {}
local MissionRecordTable = {}
function MyGarrisons:CheckMissionRecords()
--TODO add check for avaliable missions.
	for k,v in pairs (C_Garrison.GetInProgressMissions()) do
											
												MissionRecordTable[v.missionID] = true
											for k2, v2 in pairs (v) do

												if v2 ~= nil then
												--	print("    "..k2.." : "..tostring(v2))
												end

											end

										end
	local nam, realmi = UnitName("player")

	for x,y in pairs(MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Missions) do

		if MissionRecordTable[x] == nil then
			--print("Mission "..x.." is not active")
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Missions[x] = nil
		end
	end
	for k,v in pairs (C_Garrison.GetInProgressMissions()) do
		local missionID = v.missionID;
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Missions[missionID] == nil then
		--	print("missing mission")
			local durationSeconds = v.durationSeconds;
			local timeLeftSeconds = MyGarrisons:buildingTimeToSeconds(v.timeLeft)

			local missionEndTime = time() + timeLeftSeconds
			local missionStartTime = missionEndTime - durationSeconds
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Missions[missionID] = {
				StartTime = missionStartTime
				,EndTime =   missionEndTime
				,Followers = v.followers
			}
			MyGarrisons:AddMissionTimer(nam, GetRealmName(), missionID)
			for k2,v2 in pairs (v.followers) do
			--	print("   Follower "..k2.." "..v2)
			
			end

		end
	
	end
	MissionRecordTable = {}
end
function MyGarrisons:FollowerToMission(missionID, followerID)

	followersOnMission[tostring(followerID)] = missionID
	--print(followerID)
end
function MyGarrisons:RemoveFollowerMission(missionID, followerID)

	followersOnMission[tostring(followerID)] = nil

end
function MyGarrisons:StartMission(missionID)
	local nam, realmi = UnitName("player")
	--print("Mission started")
	--MyGarrisons:AddMission(nam, GetRealmName(), missionID, followersOnMission)
end

function MyGarrisons:AddMission(characterID, realmID, missionID, followersOnMission)
	MissionDataTable = {C_Garrison.GetMissionTimes(missionID)}
	local Atlas = ""
	local followes = {}
	local isRar = false;
	for k,v in pairs (C_Garrison.GetInProgressMissions()) do
		if v.missionID == missionID then
			Atlas = v.typeAtlas
			followes = v.followers
			isRar = v.isRare
		end
	
	end
	for k,v in pairs (followes) do
	--print(k.."  "..tostring(v))
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID] == nil then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID] = {
			StartTime = time()
			,EndTime =   time() + tonumber(MissionDataTable[2]) + (tonumber(MissionDataTable[5]))
			,Followers = followersOnMission,
			MissionAtlas = Atlas,
			Rare = isRar
		}
		
	--print(time() + tonumber(MissionDataTable[2]) + (tonumber(MissionDataTable[5])))
	end
	MissionDataTable = {}

	MyGarrisons:AddMissionTimer(characterID, realmID, missionID)
end
function MyGarrisons:RemoveMission(characterID, realmID, missionID)
	if MyGarrisons.db.global.MGRealms[realmID] ~= nil then
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID] ~= nil then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID] = nil;
		end
	end

end
function MyGarrisons:ScanActiveMissions()


end
local folls = {}
function MyGarrisons:StartGMission(missionID)

	--find all followers assigned to that mission

	folls = {}
	for k,v in pairs (followersOnMission) do
		if v == missionID then
			
			tinsert(folls,C_Garrison.GetFollowerInfo(tostring(k)).name)
		end
	end
	--print("Followers going on "..C_Garrison.GetMissionName(missionID))
	--for k,v in pairs(folls) do
	--	print(v)
	--end
	--Save the mission
	local nam, realmi = UnitName("player")
	--MyGarrisons:AddMission(nam, GetRealmName(),missionID, followersOnMission)
	--MyGarrisons:ProgressCheck()
end

function MyGarrisons:CANCELCONS(plotID)
	local nam, realmi = UnitName("player")

	--MyGarrisons:ScanGarrison()
	local bid = MyGarrisons:GetPlotsBuilding(plotID)


	local key = nil

	local buildingLevel = 0
	local tempTab = nil
			for k2, v2 in pairs (BuildingIDSets) do
				for k3, v3 in pairs (v2) do
					if v3 == bid then
						key = k2
						
						buildingLevel = k3

					end
				end
			end
	
	if buildingLevel > 1 then
		MyGarrisons:UpgradeBuildingTo(nam, GetRealmName(), bid, key[buildingLevel-1])
		print("Cancel upgrade")
	else
		print("Cancel construction")
		
		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[bid] = nil
	end
	--TODO
		--		MyGarrisons:UnuseCharacterTimer(nam.."-"..GetRealmName(), "Building", bid)
		--		MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Constructions[ bid] = nil
				
	
end
local buildingInfo = {}
function MyGarrisons:PLACEBUILD(plotInstanceID, buildingID)

	--upgradesDetected[plotInstanceID] = true
	--TO GET TIME STRING
	buildingInfo = {C_Garrison.GetBuildingInfo(buildingID)};
	for i =1, MyGarrisons:TableSize(buildingInfo) do
	--	print(i.."  "..buildingInfo[i])
	end
	local timeStr = buildingInfo[10];
	--print(MyGarrisons:buildingTimeToSeconds(timeStr))
	local endTime = MyGarrisons:buildingTimeToSeconds(timeStr)
	
	local nam, realmi = UnitName("player")
	MyGarrisons:AddBuildingToCharacter(nam, GetRealmName(), buildingID, plotInstanceID)
	MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[buildingID].UnderConstruction = true
	MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[buildingID].ConstructionStartTime = time()
	MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[buildingID].ConstructionDoneTime = endTime
	--print("Building...")
	--MyGarrisons:AddConstruction(nam, GetRealmName(), plotInstanceID, buildingID)
	--MyGarrisons:AddCharacterTimer(nam.."-"..GetRealmName(), "Building", buildingID)
	--MyGarrisons:ScanGarrison()

end
-- =================================================================================================
-- Followers
-- =================================================================================================
function MyGarrisons:ScanFollowers()
--MyGarrisons.db.global.MGRealms[GetRealmName()].].Characters[characterID].Garrison
	local characterID, realmi = UnitName("player")
	--/run for k,v in pairs(C_Garrison.GetFollowers())do if v.garrFollowerID ~= nil then strs = "" for k2,v2 in pairs (v) do  strs = strs .. (k2 .." = " ..tostring(v2).." | ")   end print (strs) end end
	for k,v in pairs(C_Garrison.GetFollowers())do 
		if v.garrFollowerID ~= nil then
			 MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Followers[v.followerID] = {
				Class = v.className,
				iLevel = v.iLevel,
				Name = v.name,
				DisplayID = v.displayID,
				Level = v.level,
				XP = v.xp,
				LevelXP = v.levelXP,
				Quality = v.quality,
				Abilities = {},
				Traits = {}, 
				Activated = true --TODO
			 }
			MyGarrisons:GetFollowersAbilities(v.followerID)

		end
	end
	

end
function MyGarrisons:GetFollowersAbilities(followerID)
	local characterID, realmi = UnitName("player")
	local counter = 1
	local tcounter = 1
	for x2,y2 in pairs (C_Garrison.GetFollowerAbilities(followerID)) do

		if y2.isTrait == false then
			-- MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Followers[v.followerID]
		 MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Followers[followerID].Abilities[counter] ={
																								Icon = y2.icon,
																								Name = y2.name,
																								Desc = y2.description,
																								ID = y2.id,
																								IsTrait = y2.isTrait
		 }
		 counter = counter + 1
		 else
		  MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Followers[followerID].Traits[tcounter] ={
																								Icon = y2.icon,
																								Name = y2.name,
																								Desc = y2.description,
																								ID = y2.id,
																								IsTrait = y2.isTrait
		 }
		 tcounter = tcounter + 1
		end
	 end
end
-- =================================================================================================
-- Cache
-- =================================================================================================
function MyGarrisons:ComputeCache(characterID, realmID)
	if MyGarrisons.db.global.MGRealms[realmID] ~= nil then
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID] ~= nil then
			local d2 = time()
			local endTim = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Cache.LastCheck
			local remaining = difftime(time(), endTim)
			if (remaining/60)*0.1 < 500 then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Cache.Amount =floor( (remaining/60)*0.1)
				return floor((remaining/60)*0.1)
			else
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Cache.Amount = 500
				return 500
			end
		end
	end
end

function MyGarrisons:GarrisonCacheLoot(self, itemLink, quantity, rollType, roll, specID, isCurrency, showFactionBG, lootSource)
	if lootSource == 10 then
		local characterID, realmID = UnitName("player")
		if realmID == nil then
			realmID = GetRealmName()
		end
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Cache == nil then
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Cache = {LastCheck = time(), Amount = 0}
		end
		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Cache.Amount = 0
		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Cache.LastCheck = time()
	end
end

-- =================================================================================================
-- Set up
-- =================================================================================================

local inputTable = {};
local NeooptionTable = {
		name	= "MyGarrisons",
		handler = MyGarrisons,
		type	= 'group',
		args = {
--MyGarrisons:ScanGarrison()
			
				timers = {
				
				
							name = "Show/Hide Timers",
							type = "execute",
							func =	function ()
										if MyGarrisonTimers:IsShown() then
											MyGarrisonTimers:Hide()
										else
											MyGarrisonTimers:Show()
										end
									end
							},
				delete = {	name = "Delete character",
							type = "input",
							get = function () end,
							set = function(e1,e2,e3)--
										local s1, namerealm = MyGarrisons:splitAtFirst(tostring(e1["input"]), " ")
										local characterID, realmID = MyGarrisons:splitAtFirst(namerealm, " ")
										if MyGarrisons.db.global.MGRealms[realmID] ~= nil then
											if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID] ~= nil then
												MyGarrisons.db.global.MGRealms[realmID].Characters[characterID] = nil
												print("Deleting "..characterID.." "..realmID)
											else
												print ("The character name \"" ..characterID.."\" is not in the database.  You may have mistyped it.")
											end	
										else
											print ("The realm name \"" ..realmID.."\" is not in the database.  You may have mistyped it.")
										end
									end
						},
				alpha = {
							name ="Timer frame alpha",
							type = "range",
							min = 0,
							max = 1,
							step = 0.01,
							get = function ()
											local characterID, realmi = UnitName("player")
											local realmID = GetRealmName()
											return MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alpha
									end,
							set = function (info, val) 
										local characterID, realmi = UnitName("player")
										local realmID = GetRealmName()
										MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alpha = val
									end
						},
			resetpos = {
							name = "Reset Timer Frame Position",
							type = "execute",
							func =	function () 
										MyGarrisonTimers:ClearAllPoints()
										MyGarrisonTimers:SetPoint("CENTER",UIParent, "CENTER")
									end
			},
			portal = {
							name = "Set Mage Tower Portals",
							type = "execute",
							func =	function ()
										MyGarrisonsPortalSetter:Show()
									end
						},
			options = {
							name = "Show Options",
							type = "execute",
							func = function () 
									--TODO
										print("WARNING: Options are not complete")
										MyGarrisonsOptionFrame:Show() 
									end
						},
			scang = {
							name = "Scan garrison",
							type = "execute",
							func = function () 
										MyGarrisons:ScanGarrison()
									end
			
			},
			scanm = 	{
							name = "Scan active missions",
							type = "execute",
							func =	function ()
										for k,v in pairs (C_Garrison.GetInProgressMissions()) do
											--print("Mission "..k)
											for k2, v2 in pairs (v) do
												if v2 ~= nil then
													--print("    "..k2.." : "..tostring(v2))
												end

											end

										end
										MyGarrisons:CheckMissionRecords()
									end
						},
						
						
			clear = {
							name = "Clear Database",
							type = "execute",
							func =	function ()
										MyGarrisons.db.global.MGRealms = {}
										local characterID, realmi = UnitName("player")
										MyGarrisons:AddRealm()
										MyGarrisons:AddCharacter(characterID, GetRealmName())
									end
						},
						
						
						
						--MyGarrisons:buildingTimeToSeconds(buildsr)
				cache = {
					
							name = "CACHE",
							desc = "CACHE",
							type = "execute",
							func =	function () 
										local nam, realmi = UnitName("player")
										print(MyGarrisons:ComputeCache(nam,GetRealmName()))
											
									end

						},
				trade = {
							name = "Enable/Disable Trade chat in garrison",
							desc = "Sets whether Trade chat will be on when in your garrison.  Applies to all characters.",
							type = "execute",
							func = function ()  
								--MyGarrisons.db.global.Settings.GarrisonTradeOff = MyGarrisons.db.global.Settings.GarrisonTradeOff == false
								--if MyGarrisons.db.global.Settings.GarrisonTradeOff then
								--	print("My Garrisons: Trade chat enabled in Garrison")
								--else
								--	print("My Garrisons: Trade chat disabled in Garrison")
								--end
							--	MyGarrisons:GarrisonTradeImplement()
							end
						
							}
						
						
						}

				}
			

LibStub("AceConfig-3.0"):RegisterOptionsTable("MyGarrisons", NeooptionTable, {"gar"})


local defaults = {
	
	global = {MGRealms = {}
	}
}
	
function MyGarrisons:AddRealm()
	MyGarrisons.db.global.MGRealms[GetRealmName()] = {Characters = {}}
end
local MGNewCharacter = false
function MyGarrisons:OnInitialize()
		-- Called when the addon is loaded

		-- Print a message to the chat frame
	self.db = LibStub("AceDB-3.0"):New("GAR2", defaults)

	--Hooks
	self:SecureHook("SelectGossipOption", "Herb_Crop")
	self:SecureHook("LootWonAlertFrame_SetUp","GarrisonCacheLoot")					--DONE
	self:SecureHook(C_Garrison,"AddFollowerToMission","FollowerToMission")			--DONE
	self:SecureHook(C_Garrison,"AssignFollowerToBuilding","FollowerToBuilding")		--DONE
	self:SecureHook(C_Garrison,"RemoveFollowerFromBuilding","FollowerFromBuilding")	--DONE
	self:SecureHook(C_Garrison,"UpgradeBuilding","UpgradeBuilding")
	self:SecureHook(C_Garrison,"CancelConstruction","CANCELCONS")
	self:SecureHook(C_Garrison,"PlaceBuilding","PLACEBUILD")
	self:SecureHook(C_Garrison,"RemoveFollowerFromMission","RemoveFollowerMission") --DONE
	self:SecureHook(C_Garrison,"StartMission","StartGMission")
	self:SecureHook(C_Garrison,"MarkMissionComplete","MarkMissionCompleteHandler")

	if MyGarrisons.db.global.MGRealms[GetRealmName()] == nil then
		MyGarrisons:AddRealm()
	end
	local characterID, realmi = UnitName("player")
	if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID] == nil then
		C_Garrison.RequestLandingPageShipmentInfo();


		MyGarrisons:AddCharacter(characterID, GetRealmName())

		--MGNewCharacter = true
	end
	local classDisplayName, class, classID = UnitClass("player");
	if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Class ~= classID then
		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Class = classID
	end
	if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Faction == nil then
		local	factionGroup, factionName = UnitFactionGroup("player") 
		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Faction = factionGroup
	end

	--Register event 
	self:RegisterEvent("CHAT_MSG_CURRENCY")
	self:RegisterEvent("CHAT_MSG_LOOT")
	self:RegisterEvent("GARRISON_BUILDING_ACTIVATED")
	self:RegisterEvent("GARRISON_BUILDING_REMOVED")
	self:RegisterEvent("GARRISON_BUILDING_UPDATE")
	self:RegisterEvent("GARRISON_BUILDINGS_SWAPPED")
	self:RegisterEvent("GARRISON_LANDINGPAGE_SHIPMENTS")
	self:RegisterEvent("GARRISON_MISSION_COMPLETED")
	self:RegisterEvent("GARRISON_MISSION_NPC_OPENED")
	self:RegisterEvent("GARRISON_MISSION_STARTED")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("QUEST_FINISHED")
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	
	--GARRISON_BUILDING_PLACED
	--SHIPMENT_CRAFTER_INFO
	--self:RegisterEvent("SHIPMENT_UPDATE")
	--self:RegisterEvent("SHIPMENT_CRAFTER_INFO")
	
	--self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	--self:RegisterEvent("ZONE_CHANGED")
	

	--self:RegisterEvent("PLAYER_ENTERING_WORLD")

	

	if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Settings.Alpha == nil then
		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Settings.Alpha = 1
	end
	if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Settings.ShowOnLogIn == nil then
		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Settings.ShowOnLogIn = true
	end
	local timerDelayed= MyGarrisons:ScheduleTimer("DelayedUpdate", 5)	

	
	if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Settings.ShowOnLogIn == false then
		MyGarrisonTimers:Hide()
	end
end
local repeater = 0
function MyGarrisons:DelayedUpdate()
	local characterID, realmi = UnitName("player")
	--TODO fine tune
	if #C_Garrison.GetBuildings() ~= 0 then
		MyGarrisons:ScanGarrison()
		MyGarrisons:ScanFollowers()
		MyGarrisons:CheckMissionRecords()
		MyGarrisons:ShipmentScan()
		MyGarrisons:ScanQuests()
		
		MyGarrisons:QUEST_FINISHED()
		if MGNewCharacter == true then
				--MyGarrisons:AddCharacterTimer(characterID, GetRealmName())
		end
		MyGarrisons:SetUpTimerFrame()
		MyGarrisons:MakeSureTimerScrollAnchored()
	else
		if repeater < 10 then
			local timerDelayed= MyGarrisons:ScheduleTimer("DelayedUpdate", 5)
			repeater = repeater+1
		else
			MyGarrisons:ScanGarrison()
			MyGarrisons:ScanFollowers()
			MyGarrisons:CheckMissionRecords()
			MyGarrisons:ShipmentScan()
			MyGarrisons:ScanQuests()
			MyGarrisons:SetUpTimerFrame()
			MyGarrisons:MakeSureTimerScrollAnchored()
			MyGarrisons:QUEST_FINISHED()
			if MGNewCharacter == true then
			
			end

		end
	end
end
local CropStrings = {}
function MyGarrisons:Herb_Crop(index ,thetext, other)
	local characterID, realmi = UnitName("player")
	

	local unit = UnitGUID('npc')
	local id = unit and tonumber(select(6, strsplit('-', unit)), nil)

	if id == 85344 then
	--print(CropStrings[index])
		--BuildingIDSets["herb"] = 			{29, 136, 137}--, NextCrop = ""
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[29] ~= nil then
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[29].SpecialData.NextCrop = CropStrings[index]
		end
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[136] ~= nil then
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[136].SpecialData.NextCrop = CropStrings[index]
		end
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[137] ~= nil then
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[137].SpecialData.NextCrop = CropStrings[index]
		end
	end
	--TODO
	--/run print(GetGossipOptions())
	
end
function MyGarrisons:GOSSIP_SHOW()
	local unit = UnitGUID('npc')
	local id = unit and tonumber(select(6, strsplit('-', unit)), nil)
	if id == 85344 then
		CropStrings = {}
		for k,v in pairs ({GetGossipOptions()}) do
			if v ~= "gossip" then
				tinsert(CropStrings,v);
			end
		end
	end
end
function MyGarrisons:PLAYER_LOGIN()

end
function MyGarrisons:GARRISON_MISSION_STARTED(ev, missionID, p2, p3)

	local Atlas = ""
	local followes = {}
	local isRar = false;
	for k,v in pairs (C_Garrison.GetInProgressMissions()) do
		if v.missionID == missionID then
			Atlas = v.typeAtlas
			followes = v.followers
			isRar = v.isRare
		end
	
	end
	local characterID, realmi = UnitName("player")
	MyGarrisons:AddMission(characterID, GetRealmName(), missionID, followes)
end
-- =================================================================================================
-- Events
-- =================================================================================================
local DeadBodyGuardDebuffs = {}
DeadBodyGuardDebuffs[173660] = true
DeadBodyGuardDebuffs[173661] = true
DeadBodyGuardDebuffs[173976] = true
DeadBodyGuardDebuffs[173658] = true
DeadBodyGuardDebuffs[173659] = true
DeadBodyGuardDebuffs[173657] = true

--{26,27,28}
function MyGarrisons:EnterFallenBodyguard(characterID, realmID, spellID, timeLeft)
	for k,v in pairs (BuildingIDSets["barracks"]) do
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v] ~= nil then
			if  MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v].SpecialData == nil then
				 MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v].SpecialData = BuildingSpecialDatas[v]
			end
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v].SpecialData[spellID].IsDefeated == false then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v].SpecialData[spellID].IsDefeated = true
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v].SpecialData[spellID].TimeStarted =  timeLeft
			end
		end
	end
end
function MyGarrisons:CHAT_MSG_CURRENCY(eve, er, we)
	if C_Garrison.IsOnGarrisonMap() then
		local characterID, realmi = UnitName("player")

		local realmID = GetRealmName ()
		for buidlingID, v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings) do
			C_Garrison.RequestLandingPageShipmentInfo();
			MyGarrisons:ShipmentScan()
		end
	end
end
function MyGarrisons:CHAT_MSG_LOOT(eve, er, we)
	if C_Garrison.IsOnGarrisonMap() then
		local characterID, realmi = UnitName("player")

		local realmID = GetRealmName ()
		for buidlingID, v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings) do
			C_Garrison.RequestLandingPageShipmentInfo();
			MyGarrisons:ShipmentScan()
		end
	end
end
--BuffID, TimeLeft, Icon
function MyGarrisons:UNIT_AURA(event, unitID)
	if unitID == "player" then
		for k = 1, 40 do
			local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3 = UnitDebuff(unitID, k)
			if spellID ~= nil then
				if DeadBodyGuardDebuffs[spellID] ~= nil then
					--print("Dead body guard")
					--print(expires -GetTime())
					local characterID, realmi = UnitName("player")
				MyGarrisons:EnterFallenBodyguard(characterID,GetRealmName(),spellID, time())

					--print(time() + (60*60))
				end
			end
		end
	end

end
--GARRISON_BUILDING_UPDATE
function MyGarrisons:MarkMissionCompleteHandler(par1, par2, par3, par4, par5)
	MyGarrisons:GARRISON_MISSION_COMPLETED("GARRISON_MISSION_COMPLETED", par1, "")

end
function MyGarrisons:GARRISON_MISSION_COMPLETED(eventName, missionID, bonus)
	
	local nam, realmi = UnitName("player")
	if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Missions[missionID] ~= nil then

		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Missions[missionID] = nil
		
	end
	--MyGarrisons:ScanFollowers()
	

end
function MyGarrisons:GARRISON_BUILDING_UPDATE(en, p1, p2, p3, p4)
	--print(p1)
	--print(p2)
	--print(p3)
	--print(p4)
end
function MyGarrisons:QUEST_FINISHED()
	local nam, realmi = UnitName("player")
	if IsQuestFlaggedCompleted(34586) or IsQuestFlaggedCompleted(34378) then
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.HasGarrison == false then
			--MyGarrisons:AddCharacterTimer(nam, GetRealmName())
		end
		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.HasGarrison = true
	end	
	if IsQuestFlaggedCompleted(36662) or IsQuestFlaggedCompleted(36483) then
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[42] ~= nil   then
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[42].SpecialData.Completed = true
		end
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[167] ~= nil then
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[167].SpecialData.Completed = true
		end
		
	end

	if IsQuestFlaggedCompleted(37645) or IsQuestFlaggedCompleted(37644) then
		if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[168] ~= nil   then
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[168].SpecialData.Completed = true
		end
	end
end
local PendingBuildingMoveChecks = {}
function MyGarrisons:GARRISON_BUILDING_REMOVED(en, plotID, num2)
	--MyGarrisons:ScanGarrison()
	if upgradesDetected[plotID] ~= true then
		local buildID = MyGarrisons:GetPlotsBuilding(plotID)
		local nam, realmi = UnitName("player")
		--[[if buildID ~= nil then
			if MyGarrisons.db.global.MGRealms[GetRealmName()] ~= nil then
				if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam] ~= nil then
					if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings ~= nil then
						MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[buildID] = nil
					end
				end
			end
		end]]--
		
		tinsert(PendingBuildingMoveChecks, buildID)
		if #PendingBuildingMoveChecks == 1 then
			local timerDelayed= MyGarrisons:ScheduleTimer("CheckForPlotSwitch", 0.1)	
		end
		
	--TODO Update Timer.
	end
	upgradesDetected[plotID] = false
end

function MyGarrisons:CheckForPlotSwitch()
	local nam, realmi = UnitName("player")
	local buildID = PendingBuildingMoveChecks[1]
	local itWasMoved = false;
	local neoPlotID = 0
		for k,v in pairs (C_Garrison.GetBuildings()) do 
		
			local buildInfo = {C_Garrison.GetBuildingInfo(v.buildingID)}
			if v.buildingID == buildID then
				neoPlotID = v.plotID
				itWasMoved = true
			end
		
		end
		if itWasMoved then
			--print("MOVED")
			MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[buildID].PlotID = neoPlotID
		else
			if MyGarrisons.db.global.MGRealms[GetRealmName()] ~= nil then
				if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam] ~= nil then
					if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings ~= nil then
						MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[buildID] = nil
					end
				end
			end
		end
	tremove(PendingBuildingMoveChecks,1)
	if #PendingBuildingMoveChecks ~= 0 then
		MyGarrisons:ScheduleTimer("CheckForPlotSwitch", 0.1)
	end
end
function MyGarrisons:GARRISON_BUILDING_ACTIVATED(en, plotID, num2)
	--MyGarrisons:ScanGarrison()
	local nam, realmi = UnitName("player")
	local buildID = MyGarrisons:GetPlotsBuilding(plotID)

	if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[buildID] ~= nil then
		MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[buildID].UnderConstruction = false
	else
		print ("Error:  building ID was not found.  Please notify developer.");
	end
	
	
end
function MyGarrisons:GARRISON_BUILDINGS_SWAPPED(eventname, p1, p2, p3, p4, p5, p6, p7)
--TODO what triggers this event?
	if p1 ~= nil then
	--	print("P1 "..p1)
	end
	if p2 ~= nil then
	--	print("p2 "..p2)
	end
	if p3 ~= nil then
	--	print("p3 "..p3)
	end
	if p4 ~= nil then
		--print("p4 "..p4)
	end
	if p5 ~= nil then
	--	print("p5 "..p5)
	end
	if p6 ~= nil then
	--	print("p6 "..p6)
	end
end
function MyGarrisons:SHIPMENT_UPDATE(eventName, par1, par2, par3)
	--TODO
	MyGarrisons:ShipmentScan()
end
function MyGarrisons:SHIPMENT_CRAFTER_CLOSED()
	--TODO
end
function MyGarrisons:GARRISON_LANDINGPAGE_SHIPMENTS ()
	MyGarrisons:ShipmentScan()

end
function MyGarrisons:GARRISON_MISSION_NPC_OPENED(event, ele1)
	--MyGarrisons:ScanFollowers()
end
function MyGarrisons:UNIT_SPELLCAST_SUCCEEDED(eve, unitID, spell, ran, lid, spellID)
local characterID, realmi = UnitName("player")
--TODO
	--Mining Alliance
	--170599

	if C_Garrison.IsOnGarrisonMap() then

		if spellID == 158754 or spellID == 170599 then
			
			local mineID = 0;
		
			--GetRealmName()
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[61] ~= nil then
				if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[61].SpecialData.ResetsAt < time() then
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[61].SpecialData.UsedNodes = 0
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[61].SpecialData.ResetsAt = time()+GetQuestResetTime()
				end
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[61].SpecialData.UsedNodes = MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[61].SpecialData.UsedNodes + 1
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[61].SpecialData.ResetsAt = time()+GetQuestResetTime()
				
			end
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[62] ~= nil then
				if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[62].SpecialData.ResetsAt < time() then
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[62].SpecialData.UsedNodes = 0
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[62].SpecialData.ResetsAt =time()+GetQuestResetTime()
				end
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[62].SpecialData.UsedNodes = MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[62].SpecialData.UsedNodes + 1
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[62].SpecialData.ResetsAt = time()+GetQuestResetTime()
			--	print(MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[62].SpecialData.UsedNodes.." of "..MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[62].SpecialData.MaxNodes)
			end
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[63] ~= nil then
				if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[63].SpecialData.ResetsAt < time() then
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[63].SpecialData.UsedNodes = 0
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[63].SpecialData.ResetsAt =time()+GetQuestResetTime()
				end
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[63].SpecialData.UsedNodes = MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[63].SpecialData.UsedNodes + 1
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[63].SpecialData.ResetsAt = time()+GetQuestResetTime()
				--print(MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[63].SpecialData.UsedNodes.." of "..MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[63].SpecialData.MaxNodes)
			end
			--print("Mined node in garrison")
			--{UsedNodes = 0, MaxNodes = 8, ResetsAt = 0}

			--{61, 62, 63}

--BuildingIDSets["herb"] = 			{29, 136, 137}
		end
		--Herb - 170691
		if spellID == 170691 then
		
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[29] ~= nil then
				if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[29].SpecialData.ResetsAt < time() then
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[29].SpecialData.UsedNodes = 0
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[29].SpecialData.ResetsAt = time()+GetQuestResetTime()
				end
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[29].SpecialData.UsedNodes = MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[29].SpecialData.UsedNodes + 1
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[29].SpecialData.ResetsAt = time()+GetQuestResetTime()
				
			end
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[136] ~= nil then
				if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[136].SpecialData.ResetsAt < time() then
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[136].SpecialData.UsedNodes = 0
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[136].SpecialData.ResetsAt =time()+GetQuestResetTime()
				end
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[136].SpecialData.UsedNodes = MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[136].SpecialData.UsedNodes + 1
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[136].SpecialData.ResetsAt = time()+GetQuestResetTime()
				
			end
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[137] ~= nil then
				if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[137].SpecialData.ResetsAt < time() then
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[137].SpecialData.UsedNodes = 0
					MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[137].SpecialData.ResetsAt =time()+GetQuestResetTime()
				end
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[137].SpecialData.UsedNodes = MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[137].SpecialData.UsedNodes + 1
				MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[137].SpecialData.ResetsAt = time()+GetQuestResetTime()
				
			end
		end
	end
	--Barn
	if spellID == 177829 then
	
	end

	if spellID == 177831 then
	
	end

	if spellID == 177832 then
	
	end

	if spellID == 177833 then
	
	end

	if spellID == 177827 then
	
	end

	if spellID == 177828 then
	
	end

	-- Tailoring
	if spellID == 172859 then
		local bid = 0
		for k,v in pairs (BuildingIDSets["tailoring"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	end
	--Enchanting

	if spellID == 172854 then
		local bid = 0
		for k,v in pairs (BuildingIDSets["enchanting"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end
	--Blacksmith
	if spellID == 171949 then
			local bid = 0
		for k,v in pairs (BuildingIDSets["blacksmith"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end

	--Engineering
	if spellID == 172855 then
		local bid = 0
		for k,v in pairs (BuildingIDSets["engineering"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end
	--Inscription
	if spellID == 172856 then
	--BuildingIDSets["inscription"] 
		local bid = 0
		for k,v in pairs (BuildingIDSets["inscription"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end

	--Jewelcrafting
	if spellID == 172857 then
	--jewelcrafting
	local bid = 0
		for k,v in pairs (BuildingIDSets["jewelcrafting"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end

	--Leatherworking
	if spellID == 172858 then
	--leatherworking
		local bid = 0
		for k,v in pairs (BuildingIDSets["leatherworking"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	

	end


	--Mine
	if spellID == 170696 then
	--mining
		local bid = 0
		for k,v in pairs (BuildingIDSets["mining"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end

	--Herb
	if spellID == 170693 then
	local bid = 0
		for k,v in pairs (BuildingIDSets["herb"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end
--Arena
	if spellID == 173348 then
		local bid = 0
		for k,v in pairs (BuildingIDSets["arena"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end

	--Lumber
	if spellID == 168507 then
	local bid = 0
		for k,v in pairs (BuildingIDSets["lumber"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end


	--tank
	if spellID == 177205 or spellID == 177208 then
		local bid = 0
		for k,v in pairs (BuildingIDSets["tech"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end

	--Armory
	if spellID == 178195 or spellID == 178196 then
		local bid = 0
		for k,v in pairs (BuildingIDSets["war"]) do
			if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Buildings[v] ~= nil then
				bid = v
			end
		end
		MyGarrisons:AddWorkOrderToBuilding(characterID, GetRealmName(), bid, {Item = 111556})
	
	end
--	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID] = 
--	{
--		PlotID = Plot,
--		WorkOrderQueue = {},
--		FinishedWorkOrders = {},
--		MaxWorkOrders = 0,
--		WorkOrderStartTime = 0,
--		SpecialData = {},
--		AssignedFollower = 0,
--		UnderConstruction = false,
--		ConstructionStartTime = 0
--	}
	--6478  Opening mine cart.
	-- 


	--Create Mining Work Order - 170696
	--Create Blacksmith shipment - 171949


	--Activating Waygate spells
	--173503
	if spellID == 173503 then
		--SetMapToCurrentZone();
		--local mapID = GetCurrentMapAreaID();
		--print("173503")--Gorgron
		MyGarrisons:AddPortalToTower(characterID, GetRealmName(), spellID)
		--949
	end
--173820	
	if spellID == 173820 then
	--print("173820")--Shadowmoon
		--947
		MyGarrisons:AddPortalToTower(characterID, GetRealmName(), spellID)
	end
--173553
	if spellID == 173553 then
	--print("173553") --Spire
		MyGarrisons:AddPortalToTower(characterID, GetRealmName(), spellID)
		--948
	end
--173808
	if spellID == 173808 then
	--print("173808")
		MyGarrisons:AddPortalToTower(characterID, GetRealmName(), spellID)
		--Nagrand
		--950
	end
--173816
	if spellID == 173816 then
	--print("173816") --Frostfire
		MyGarrisons:AddPortalToTower(characterID, GetRealmName(), spellID)
		--941
	end
--173797
	if spellID == 173797 then
	--print("173797") --Talador
		MyGarrisons:AddPortalToTower(characterID, GetRealmName(), spellID)
		--946
	end
	--Deactivating waygate spells.
--173810
	if spellID == 173810 then
	--print("173810")
		--Nagrand
		--/run print (GetMapNameByID(948))
	end
--172931
	if spellID == 172931 then
--	print("172931")--Gorgron
	end
--172937
	if spellID == 172937 then
--	print("172937") --spire
	end
	--173818
	if spellID == 173818 then
	--print("173818") --Shadowmoon
	end
	--173802
	if spellID == 173802 then
	--print("173802")--Talador
	end
	--173814
	if spellID == 173814 then
	--print("173814")  --Frostfire
	end


end
-- =================================================================================================
-- UI
-- =================================================================================================





function MyGarrisons:TimerFilterResults ()


end
local MGWayGateToZone = {}
MGWayGateToZone[173816] =  941
MGWayGateToZone[173797] =  946
MGWayGateToZone[173820] =  947
MGWayGateToZone[173553] =  948
MGWayGateToZone[173503] =  949
MGWayGateToZone[173808] =  950




function MyGarrisons:AddPortalToTower(characterID, realmID, spellID)
--TODO find the mage tower
	--BuildingIDSets["portal"] = 			{37, 38, 39}
	--[[
	BuildingSpecialDatas[37] = {Location1 = ""}
BuildingSpecialDatas[38] = {Location1 = "", Location2 = ""}
BuildingSpecialDatas[39] = {Location1 = "", Location2 = "", Location3 = ""}

	
	]]--
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37] then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37].SpecialData.Location1 = MGWayGateToZone[spellID]
	end


	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38] then
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location1 == "" then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location1 = MGWayGateToZone[spellID]
		else
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location2 == "" then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location2 = MGWayGateToZone[spellID]
			end
		end
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39] then
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location1 == "" then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location1 = MGWayGateToZone[spellID]
		else
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location2 == "" then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location2 = MGWayGateToZone[spellID]
			else
				if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location3 == "" then
					MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location3 = MGWayGateToZone[spellID]
				end
			end
		
		end
	end
end
function MyGarrisons:RemovePortalFromTower(characterID, realmID, spellID)
	if spellID == "" then
	
		return 0
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37] then
		local RemoveDone = false;
		if RemoveDone == false and MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37].SpecialData.Location1 == MGWayGateToZone[spellID] then
			RemoveDone = true
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37].SpecialData.Location1 = ""
		end
	end

	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38] then
		local RemoveDone = false;
		if RemoveDone == false and MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location1 == MGWayGateToZone[spellID] then
			RemoveDone = true
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location1 = ""
		end

		if RemoveDone == false and MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location2 == MGWayGateToZone[spellID] then
			RemoveDone = true
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location2 = ""
		end
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39] then
		local RemoveDone = false;
		if RemoveDone == false and MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location1 == MGWayGateToZone[spellID] then
			RemoveDone = true
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location1 = ""
		end

		if RemoveDone == false and MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location2 == MGWayGateToZone[spellID] then
			RemoveDone = true
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location2 = ""
		end
		if RemoveDone == false and MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location3 == MGWayGateToZone[spellID] then
			RemoveDone = true
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location3 = ""
		end
	end
end
-- =================================================================================================
-- Utilities
-- =================================================================================================
function MyGarrisons:splitAtFirst(str, pattern)

	local startIndex, endIndex = strfind(str,pattern)
	if startIndex ~= nil then
		return strsub(str,0,  startIndex-1), strsub(str, startIndex+strlen(pattern))
	end
	return str
end
--From SavedInstance
function MyGarrisons:GetNextDailyResetTime()
  local resettime = GetQuestResetTime()
  if not resettime or resettime <= 0 or -- ticket 43: can fail during startup
     -- also right after a daylight savings rollover, when it returns negative values >.<
		resettime > 24*3600+30 then -- can also be wrong near reset in an instance
    return nil
  end
  return time() + resettime
end
function MyGarrisons:TableSize(tab)
	count = 0
	for key, val in pairs (tab) do
		count = count +1
	end
	return count
end

function MyGarrisons:buildingTimeToSeconds(buildsr)
	if buildsr == nil then
		return 00
		end
	local secs = 0
	local splitted = {strsplit(" ",buildsr)}

	local unitWithAmount = {}
	if (#splitted)%2 == 0 then

		for ine = 1, (#splitted)/2 do
			if splitted[ine*2] == "hr" then
				secs = secs + (tonumber(splitted[ine*2 - 1]) * 3600)
			end
			if splitted[ine*2] == "min" then
				secs = secs + (tonumber(splitted[ine*2 - 1]) * 60)
			end
			if splitted[ine*2] == "sec" then
				secs = secs + (tonumber(splitted[ine*2 - 1]) )
			end

		end

	end
	return secs
end

