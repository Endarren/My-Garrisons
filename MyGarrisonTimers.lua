-- Author      : Endarren
-- Create Date : 7/22/2014 11:03:01 AM
local MGGarbageCounter = 0
local MGBodyguards = {Alliance = {}, Horde = {}}
MGBodyguards.Alliance[1] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\193N.tga", 
	SpellID =173649,
	Name = ""}
MGBodyguards.Alliance[2] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\218N.tga", SpellID =173659 }
MGBodyguards.Alliance[3] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\219N.tga", SpellID =173976 }
MGBodyguards.Alliance[4] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\216A.tga", SpellID =173658 }
MGBodyguards.Alliance[5] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\207A.tga", SpellID =173657 }

MGBodyguards.Horde[1] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\193N.tga", SpellID =173649 }
MGBodyguards.Horde[2] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\218N.tga", SpellID =173659 }
MGBodyguards.Horde[3] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\219N.tga", SpellID =173976 }
MGBodyguards.Horde[4] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\216H.tga", SpellID =173661 }
MGBodyguards.Horde[5] = {Image = "Interface\\AddOns\\MyGarrisons\\Images\\207H.tga", SpellID =173660 }
--Interface\\AddOns\\MyGarrisons\\Images\\193N.png

local HerbIcons = {}

HerbIcons["Frostweed."]							= "Interface\\ICONS\\INV_Misc_Herb_FrostWeed.blp"
HerbIcons["Fireweed."]							= "Interface\\ICONS\\INV_Misc_Herb_FireWeed.blp"
HerbIcons["Talador Orchid."]					= "Interface\\ICONS\\INV_Misc_Herb_TaladorOrchid.blp"
HerbIcons["Gorgrond Flytrap."]					= "Interface\\ICONS\\INV_Misc_Herb_Flytrap.blp"
HerbIcons["Nagrand Arrowbloom."]				= "Interface\\ICONS\\INV_Misc_Herb_Arrowbloom.blp"
HerbIcons["Starflower."]						= "Interface\\ICONS\\INV_Misc_Herb_Starflower.blp"
HerbIcons["Let's go with a random planting."]	= "Interface\\ICONS\\INV_Misc_QuestionMark.png"

--HerbIcons["Let's go with a random planting"] = "Interface\\ICONS\\INV_Misc_Herb_FrostWeed.blp"

local classTextureNames = {}

classTextureNames[1] = "GarrMission_ClassIcon-Warrior"
classTextureNames[2] = "GarrMission_ClassIcon-Paladin"
classTextureNames[3] = "GarrMission_ClassIcon-Hunter"
classTextureNames[4] = "GarrMission_ClassIcon-Rogue"
classTextureNames[5] = "GarrMission_ClassIcon-Priest"
classTextureNames[6] = "GarrMission_ClassIcon-DeathKnight"
classTextureNames[7] = "GarrMission_ClassIcon-Shaman"
classTextureNames[8] = "GarrMission_ClassIcon-Mage"
classTextureNames[9] = "GarrMission_ClassIcon-Warlock"
classTextureNames[10] = "GarrMission_ClassIcon-Monk"
classTextureNames[11] = "GarrMission_ClassIcon-Druid"
local factionTextureNames = {}
factionTextureNames["Alliance"] = "MountJournalIcons-Alliance"
factionTextureNames["Horde"] = "MountJournalIcons-Horde"


local MGPortalIcons = {}

local idfr, namefr, pointsfr, completedfr, monthfr, dayfr, yearfr, descriptionfr, flagsfr, iconfr, rewardTextfr, isGuildAchfr, wasEarnedByMefr, earnedByfr =  GetAchievementInfo(8937)

--8937

MGPortalIcons[941] = iconfr
local MGWayGateRegions = {}
--8939
local idgrg, namegrg, pointsgrg, completedgrg, monthgrg, daygrg, yeargrg, descriptiongrg, flagsgrg, icongrg, rewardTextgrg, isGuildAchgrg, wasEarnedByMegrg, earnedBygrg =  GetAchievementInfo(8939)
MGPortalIcons[949] = icongrg
--8942
local idngd, namengd, pointsngd, completedngd, monthngd, dayngd, yearngd, descriptionngd, flagsngd, iconngd, rewardTextngd, isGuildAchngd, wasEarnedByMengd, earnedByngd =  GetAchievementInfo(8942)
MGPortalIcons[950] = iconngd
--8938
local idsmv, namesmv, pointssmv, completedsmv, monthsmv, daysmv, yearsmv, descriptionsmv, flagssmv, iconsmv, rewardTextsmv, isGuildAchsmv, wasEarnedByMesmv, earnedBysmv =  GetAchievementInfo(8938)
MGPortalIcons[947] = iconsmv
--8941
local idsoa, namesoa, pointssoa, completedsoa, monthsoa, daysoa, yearsoa, descriptionsoa, flagssoa, iconsoa, rewardTextsoa, isGuildAchsoa, wasEarnedByMesoa, earnedBysoa =  GetAchievementInfo(8941)
MGPortalIcons[948] = iconsoa
--8940
local idtala, nametala, pointstala, completedtala, monthtala, daytala, yeartala, descriptiontala, flagstala, icontala, rewardTexttala, isGuildAchtala, wasEarnedByMetala, earnedBytala =  GetAchievementInfo(8940)
MGPortalIcons[946] = icontala
MGPortalIcons[""] = ""
function MyGarrisonTimers_OnLoad()
	
end
-- =================================================================================================
-- Timer Frame
-- =================================================================================================

function MyGarrisons:MakeSureTimerScrollAnchored()
	MyGarrisonTimers.timerscroll:ClearAllPoints()
	MyGarrisonTimers.timerscroll:SetParent(MyGarrisonTimers)
	MyGarrisonTimers.timerscroll:SetPoint("TOPLEFT",MyGarrisonTimers,"TOPLEFT", 2,-20)

end
function Frame1_OnLoad()
	
end
local GarrisonScrollContent  = nil
function MyGarrisons:SetUpTimerFrame()
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName()
	GarrisonScrollContent = CreateFrame("Frame", "GarrisonScroll", MyGarrisonTimers.timerscroll)
	GarrisonScrollContent:SetSize(128, 28)
	GarrisonScrollContent:SetPoint("TOPLEFT", MyGarrisonTimers.timerscroll,10,-60 )
	GarrisonScrollContent:Show()
		
	MyGarrisonTimers.timerscroll.GarrisonScrollContent = GarrisonScrollContent
 
	MyGarrisonTimers.timerscroll:SetScrollChild(GarrisonScrollContent)
	if MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Settings.ShowOnLogIn == false then
		MyGarrisonTimers:Hide()
	else
	MyGarrisonTimers:Show()
	end
	--MyGarrisons.db.global.MGRealms[GetRealmName()] = {Characters = {}}
	for k,v in pairs (MyGarrisons.db.global.MGRealms) do
		for k2, v2 in pairs (v.Characters) do
			if v2.Garrison.HasGarrison then
				MyGarrisons:AddCharacterTimer(k2, k)
			end
		end
	end
end

function TimerScroll_OnVerticalScroll()
	
end

function MinMaxButton_OnClick()
	
end
--[[
Garrison = {
						HasGarrison = false,
						GarrisonLevel = 0,
						Cache = {LastCheck = 0, Amount = 0},
						Buildings = {},
						Followers = {},
						]]--
-- =================================================================================================
-- Character Headers
-- =================================================================================================

local CharacterHeaders = {}
local CharacterHeaderCounter = 0
function MyGarrisons:UpdateCharacterHeader(ind)
	if CharacterHeaders[ind] ~= nil then 
		CharacterHeaders[ind].Frame.charname:SetText(CharacterHeaders[ind].CharacterID.." - "..CharacterHeaders[ind].RealmID)
		local charName = CharacterHeaders[ind].CharacterID
		if MyGarrisons.db.global.MGRealms[CharacterHeaders[ind].RealmID] == nil then
			CharacterHeaders[ind].Used = false
			CharacterHeaders[ind].Frame:Hide()
			return false
		else
			if MyGarrisons.db.global.MGRealms[CharacterHeaders[ind].RealmID].Characters[charName] ~= nil then
				if MyGarrisons.db.global.MGRealms[CharacterHeaders[ind].RealmID].Characters[charName].Garrison ~= nil then
					CharacterHeaders[ind].Frame.cache:SetText("Cache")
					CharacterHeaders[ind].Frame.cacheAmount:SetText(MyGarrisons.db.global.MGRealms[CharacterHeaders[ind].RealmID].Characters[CharacterHeaders[ind].CharacterID].Garrison.Cache.Amount)
				end
				CharacterHeaders[ind].Frame.factiontexture:SetAtlas(factionTextureNames[MyGarrisons.db.global.MGRealms[CharacterHeaders[ind].RealmID].Characters[CharacterHeaders[ind].CharacterID].Faction])
				CharacterHeaders[ind].Frame.classtexture:SetAtlas(classTextureNames[MyGarrisons.db.global.MGRealms[CharacterHeaders[ind].RealmID].Characters[CharacterHeaders[ind].CharacterID].Class])
			end
		end
	end
end

function MyGarrisons:CharacterHeaderSorter()
	
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName()
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters == nil then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters = {Direction = 1,
Type = "mission"}
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Type == "name" then
		MyGarrisons:SortCharactersByName()
	else
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Type == "mission" then
			MyGarrisons:SortCharactersByMissionTime()
		else
	
	
		end
	
	end
end
function MyGarrisons:SortCharactersByName()
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName()
	sort(CharacterHeaders, function(a,b)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction == 1 then
if a.Used == b.Used then
			if a.CharacterID < b.CharacterID then

				return true
			else
				if a.CharacterID == b.CharacterID then
					return a.RealmID < b.RealmID
				else
					return false;
				end
			end
		else
			if a.Used == true then
				return true
			else
				return false
			end
		end
		else--
		if a.Used == b.Used then
			if a.CharacterID < b.CharacterID then

				return false
			else
				if a.CharacterID == b.CharacterID then
					return a.RealmID > b.RealmID
				else
					return true;
				end
			end
		else
			if a.Used == true then
				return true
			else
				return false
			end
		end
		
		end
	end)
	for k = 1, #CharacterHeaders do
		CharacterHeaders[k].Frame.index = k
	end
end
function MyGarrisons:SortCharactersByCache()


end
function MyGarrisons:SortCharactersByRealm()
	sort(CharacterHeaders, function(a,b)
		
		if a.Used == b.Used then
			
			if a.RealmID < b.RealmID then
				return true
			else
				if a.RealmID == b.RealmID then
					return a.CharacterID < b.CharacterID
				else
					return false;
				end
			end
		else
			if a.Used == true then
				return true
			else
				return false
			end
		end
	end)
	for k = 1, #CharacterHeaders do
		CharacterHeaders[k].Frame.index = k
	end
end
function MyGarrisons:SortCharactersByMissionTime()
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName()
	--MyGarrisons:CountDoneMissions(characterID, realmID)
	sort(CharacterHeaders, function(a,b)
		if a.Used == b.Used then

			local c1, soonestA = MyGarrisons:CountDoneMissions(a.CharacterID, a.RealmID)
			local c2, soonestB = MyGarrisons:CountDoneMissions(b.CharacterID, b.RealmID)
--counter, soonest
			if c1 ~= c2 then
			
				if c1 > c2 then
					if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction == 1 then
						return true
					else
						return false
					end
				else
					if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction == 1 then
						return false
					else
						return true
					end
				end
			else

				if soonestA ~= soonestB then
					if soonestA < soonestB then
						if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction == 1 then
							return true
						else
							return false
						end

					else
						if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction == 1 then
							return false
						else
							return true
						end

					end
				else


					if a.CharacterID < b.CharacterID then
						if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction == 1 then
							return true
						else
							return false
						end

					else
						if a.CharacterID == b.CharacterID then
							if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction == 1 then

								return a.RealmID < b.RealmID
							else
								return a.RealmID > b.RealmID
							end
						else
							if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction == 1 then
								return false;
							else
								return true
							end

						end
					end
				end
			end
		else
			if a.Used == true then
				return true
			else
				return false
			end
		end
	end)
	for k = 1, #CharacterHeaders do
		CharacterHeaders[k].Frame.index = k
	end

end
function MyGarrisons:SortCharactersByOpenWorkOrder()


end

function MyGarrisons:UpdateCharacterTimer(headerIndex)

	local missionheaderheight = 40;
	if CharacterHeaders[headerIndex].TimerBag.MissionHeader.Expanded == true then
		missionheaderheight = CharacterHeaders[headerIndex].TimerBag.MissionHeader:GetHeight()
	end
	local buildingheaderheight = 40
	if CharacterHeaders[headerIndex].TimerBag.BuildingHeader.Expanded == true then
		buildingheaderheight = CharacterHeaders[headerIndex].TimerBag.BuildingHeader:GetHeight()
	end
	CharacterHeaders[headerIndex].TimerBag:SetHeight(missionheaderheight + buildingheaderheight)

	
	--TODO
	--MissionHeader
end
function MyGarrisons:AddCharacterTimer(characterID, realmID)
	local xname, xamount, texturePath,xearnedThisWeek,xweeklyMax,xtotalMax, xisDiscovered = GetCurrencyInfo(824)


--timerscroll
	local HeaderToUse = -1
	--MyGarrisonTimers.timerscroll

	if CharacterHeaderCounter == 0 then
		HeaderToUse = -1
	else
	
		for k = 1, #CharacterHeaders do

			if CharacterHeaders[k].Used == false then
				if HeaderToUse == -1 then
					HeaderToUse = k
				end
			end
			if CharacterHeaders[k].RealmID == realmID and CharacterHeaders[k].CharacterID == characterID then
				if CharacterHeaders[k].Used == false then
					HeaderToUse = k
					break
				else
					return false
				end
			end
		end
	end
	--Frame    = CreateFrame("Frame", "CharacterHeaderTemplate"..(#CharacterHeaders+1),MyGarrisonTimers.timerscroll.GarrisonScrollContent,"CharacterHeaderTemplate"),
	if HeaderToUse == -1 then
		CharacterHeaders[#CharacterHeaders + 1] = {	Used = true, 
													Expanded = false,
													RealmID = realmID,
													CharacterID = characterID,
													Frame = CreateFrame("Button", "MGCharacterHeader"..(#CharacterHeaders+1),MyGarrisonTimers.timerscroll.GarrisonScrollContent,"MGCharacterHeader"),
													TimerBag = CreateFrame("Frame", "TimerBag"..(#CharacterHeaders+1),MyGarrisonTimers.timerscroll.GarrisonScrollContent,"TimerBag") 
		}
		CharacterHeaders[#CharacterHeaders].Frame.characterID=characterID
		CharacterHeaders[#CharacterHeaders].Frame.realmID=realmID
		CharacterHeaders[#CharacterHeaders].Frame.index=HeaderToUse  
		MyGarrisons:UpdateCharacterHeader(#CharacterHeaders)
		HeaderToUse = #CharacterHeaders
	else
		CharacterHeaders[HeaderToUse].Used = true
		CharacterHeaders[HeaderToUse].Expanded = false
		CharacterHeaders[HeaderToUse].RealmID = realmID
		CharacterHeaders[HeaderToUse].CharacterID = characterID
		CharacterHeaders[HeaderToUse].Frame.characterID=characterID
		CharacterHeaders[HeaderToUse].Frame.realmID=realmID
		CharacterHeaders[HeaderToUse].Frame.index=HeaderToUse 
		MyGarrisons:UpdateCharacterHeader(HeaderToUse)
	end
	--texturePath
	
	CharacterHeaders[HeaderToUse].TimerBag:SetPoint("TOPLEFT",CharacterHeaders[HeaderToUse].Frame,"BOTTOMLEFT" )
	CharacterHeaders[HeaderToUse].TimerBag.HeaderIndex = HeaderToUse
	CharacterHeaders[HeaderToUse].TimerBag:Hide();
	MyGarrisons:SetUpTimerBag(HeaderToUse)
	
	for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions) do
		MyGarrisons:AddMissionTimer(characterID, realmID, k)
	end
	MyGarrisons:FillBuildingsForHeader(HeaderToUse)
	--MyGarrisons:AddMissionTimer(characterID, realmID, missionID)
	
	CharacterHeaders[HeaderToUse].Frame.garrcacheicon:SetTexture(texturePath)
	MyGarrisons:CharacterHeaderSorter()
	
	MyGarrisons:ArrangeCharacterHeaders()
end

function MyGarrisons:ArrangeCharacterHeaders()
	for k,v in pairs (CharacterHeaders) do
		v.Frame:ClearAllPoints()
		if k == 1 then
			v.Frame:SetPoint("TOPLEFT",MyGarrisonTimers.timerscroll.GarrisonScrollContent,"TOPLEFT")
		else
			v.Frame:SetPoint("TOPLEFT",CharacterHeaders[k-1].TimerBag,"BOTTOMLEFT")
		end
		v.Frame:SetScript("OnClick",function () 
										local hIndex = k
										MGCharacterHeader_OnClick(hIndex)
									end)
		v.TimerBag.HeaderIndex = k
		v.TimerBag.MissionHeader.HeaderIndex = k
		v.TimerBag.MissionHeader.missionheader.HeaderIndex = k
		v.TimerBag.BuildingHeader.buildingheader.HeaderIndex = k
		v.TimerBag.BuildingHeader.HeaderIndex = k
		--CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers
		for k2,v2 in pairs(v.TimerBag.MissionHeader.MissionTimers) do
			v2.headerIndex = k
		end
		MyGarrisons:AdjustMissionBuildingAnchors (k)
	--[[	v.TimerBag.MissionHeader:SetScript("OnClick", 
	function ()

		if v.TimerBag.MissionHeader.Expanded then
			--v.TimerBag.MissionHeader:SetHeight(0)	
			v.TimerBag.MissionHeader:Hide()
			v.TimerBag.MissionHeader.Expanded = false
			--v.TimerBag:SetHeight(v.TimerBag:GetHeight() -40 * v.TimerBag.MissionHeader.ActiveMissions )
		else
		--	v.TimerBag:SetHeight(CharacterHeaders[hi].TimerBag:GetHeight() +40 * v.TimerBag.MissionHeader.ActiveMissions )
			--v.TimerBag.MissionHeader:SetHeight(40 * v.TimerBag.MissionHeader.ActiveMissions)
			v.TimerBag.MissionHeader:Show()
			v.TimerBag.MissionHeader.Expanded = true
		end
		
	end
	) ]]--
	end
end

function MGCharacterHeader_OnLoad()
	
end
function MGCharacterHeader_OnClick(ind)

	if CharacterHeaders[ind].Expanded then
		CharacterHeaders[ind].TimerBag:Hide();
		CharacterHeaders[ind].Expanded = false
		CharacterHeaders[ind].TimerBag:SetHeight(1)
		CharacterHeaders[ind].TimerBag.MissionHeader.Expanded = false;
	else
		CharacterHeaders[ind].Expanded = true
		CharacterHeaders[ind].TimerBag:Show();
		CharacterHeaders[ind].TimerBag:SetHeight(80)
		CharacterHeaders[ind].TimerBag.MissionHeader:Show()
		MyGarrisons:SortMissionsByTimeLeft(ind)
		MyGarrisons:ArrangeCharacterMissions(ind)
	end
end
function MyGarrisons:UpdateTimersForCharacters()
	MyGarrisonTimers:SetScript("OnUpdate", nil);
	--TODO frame rate affected
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName()
	local Alpha = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alpha
	MyGarrisonTimers.timerscroll:SetAlpha(Alpha)
	for k,v in pairs (CharacterHeaders) do
CharacterHeaders[k].Frame.charname:SetTextColor(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.r,
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.g,
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.b)
		--Cache = {Name = DEFAULT_COLOR, Amount = DEFAULT_COLOR}
if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Amount == nil then
MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache = {Name = {r =0.776, g =0.643, b = 0.0313}, Amount = {r =0.776, g =0.643, b = 0.0313}}
		end
		CharacterHeaders[k].Frame.cache:SetTextColor(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.r,
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.g,
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.b)
		
		CharacterHeaders[k].Frame.cacheAmount:SetTextColor(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Amount.r,
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Amount.g,
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Amount.b)
		
		
		if v.Expanded then
			for k2, v2 in pairs (v.TimerBag.MissionHeader.MissionTimers) do
				if MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Missions[v2.missionID] ~= nil then
					if MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Missions[v2.missionID].EndTime ~= nil then
						local startTime = MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Missions[v2.missionID].StartTime
						local endTime = MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Missions[v2.missionID].EndTime
--Type atlas
						if MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Missions[v2.missionID].MissionAtlas ~= nil then
							v2.missiontypeicon:SetAtlas(MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Missions[v2.missionID].MissionAtlas)
						end
						--endTime = startTime + endTime
						local timeleft = difftime( time(),MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Missions[v2.missionID].EndTime)
						if endTime < time() then
							v2.missiontime:SetText("Done")
							v2.missiontimerbg:SetAtlas("GarrLanding-Mission-Complete", true);
							v2.missiondonetext:Show()
						else
							v2.missiontimerbg:SetAtlas("GarrLanding-Mission-InProgress", true);
							v2.missiondonetext:Hide()
							v2.missiontime:SetText(MyGarrisons:ConvertSecondsToTime(timeleft, endTime))
						end
					end
					v2.missionname:SetText(C_Garrison.GetMissionName(v2.missionID))
				else
					if v2.Used == true then
						v2.Used = false
						v2:Hide()
						v.TimerBag.MissionHeader.ActiveMissions = v.TimerBag.MissionHeader.ActiveMissions - 1
						MyGarrisons:SortMissionsByTimeLeft(k)
					end
					--TODO Bug timerbag does not resize probably.
				end
			end
			MyGarrisons:SortMissionsByTimeLeft(k)
			MyGarrisons:ArrangeCharacterMissions(k)
			for k2, v2 in pairs(v.TimerBag.BuildingHeader.BuildingTimers) do
				local buildingID, buildingName, texturePrefix, icon, description, rank, currencyID, currencyAmount, goldAmount, timeRequirement, needsPlan, isPreBuilt, possSpecs, upgrades, canUpgrade, isMaxLevel, hasFollowerSlot = C_Garrison.GetBuildingInfo(v2.buildingID)
				v2.buildingnameframe.namestring:SetText(buildingName.." lvl "..rank)
				--BuildingSpecialDatas[10] = {Quest = {ResetsAt = 0, Completed = false}, WarSeal = {Used = false, ResetsAt = 0}}
				if v2.buildingID == 10 then
					if MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID].SpecialData == nil then
						MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID].SpecialData = MyGarrisons:GetBuildingSpecialData(v2.buildingID)
						--{Quest = {ResetsAt = 0, Completed = false}, WarSeal = {Used = false, ResetsAt = 0}}
					end
				end
				if MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID] ~= nil then
					if (MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID].UnderConstruction) then
						if (MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID].ConstructionDoneTime ~= nil ) then
							if MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID].ConstructionStartTime + MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID].ConstructionDoneTime < time() then
								v2.bg:SetAtlas("GarrLanding-Building-Complete")
								v2.shipmentstring:SetText("Construction done")
							else
								v2.bg:SetAtlas("GarrLanding-Building-InProgress")
								v2.shipmentstring:SetText("Building: "..MyGarrisons:ConvertSecondsToTimeStart(MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID].ConstructionStartTime + MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID].ConstructionDoneTime ,0))
							end
						end
					else
						v2.bg:SetAtlas("")

						if v2.buildingID == 61 or v2.buildingID == 62 or v2.buildingID == 63 then
							MyGarrisons:UpdateBuildingTimerForMine(k, k2)
						end
						if v2.buildingID == 37 or v2.buildingID == 38 or v2.buildingID == 39 then
							MyGarrisons:UpdateBuildingTimerForPortalHub(k, k2)
						end
						--51, 142, 143}
						if v2.buildingID == 51 or v2.buildingID == 142 or v2.buildingID == 143 then
							MyGarrisons:UpdateBuildingTimerForStorehouse(k, k2)
						end
						--{64, 134, 135}
						if v2.buildingID == 64 or v2.buildingID == 134 or v2.buildingID == 135 then
							MyGarrisons:UpdateBuildingTimerForFishing(k, k2)
						end
						--{52, 140, 141}
						if v2.buildingID == 52 or v2.buildingID == 140 or v2.buildingID == 141 then
							MyGarrisons:UpdateBuildingTimerForSalvage(k, k2)
						end
						--{60, 117, 118}
						if v2.buildingID == 60 or v2.buildingID == 117 or v2.buildingID == 118 then
							MyGarrisons:UpdateBuildingTimerForBlacksmith(k, k2)
						end
						--{42, 167, 168}
						if v2.buildingID == 42 or v2.buildingID == 167 or v2.buildingID == 168 then
							MyGarrisons:UpdateBuildingTimerForMenagerie(k, k2)
						end
						-- leatherworking {90, 121, 122}
						if v2.buildingID == 90 or v2.buildingID == 121 or v2.buildingID == 122 then
							MyGarrisons:UpdateBuildingTimerForLeather(k, k2)
						end

							--91, 123, 124
						if v2.buildingID == 91 or v2.buildingID == 123 or v2.buildingID == 124 then
							--  engineering
							MyGarrisons:UpdateBuildingTimerForEngineer(k, k2)
						end
							--93, 125, 126
						--  enchanting
						if v2.buildingID == 93 or v2.buildingID == 125 or v2.buildingID == 126 then
							MyGarrisons:UpdateBuildingTimerForEnchant(k, k2)
						end
							--24, 25, 133
						--TODO  barn
						if v2.buildingID == 24 or v2.buildingID == 25 or v2.buildingID == 133 then
							MyGarrisons:UpdateBuildingTimerForBarn(k, k2)
						end
							-- lumber"] = 			{40, 41, 138}
						if v2.buildingID == 40 or v2.buildingID == 41 or v2.buildingID == 138 then
							MyGarrisons:UpdateBuildingTimerForLumber(k, k2)
						end

							-- Trade post  111, 144, 145
						if v2.buildingID == 111 or v2.buildingID == 144 or v2.buildingID == 145 then
							MyGarrisons:UpdateBuildingTimerForTradePost(k, k2)
						end
						if v2.buildingID == 34 or v2.buildingID == 35 or v2.buildingID == 36 then
							MyGarrisons:UpdateBuildingTimerForInn(k, k2)
						end
							--TODO Inn{34, 35, 36}
							 --TODO  tech {162, 163, 164}
						if v2.buildingID == 162 or v2.buildingID == 163 or v2.buildingID == 164 then
							MyGarrisons:UpdateBuildingTimerForTech(k, k2)
						end
						--TODO scribe  {95, 129, 130}
						if v2.buildingID == 95 or v2.buildingID == 129 or v2.buildingID == 130 then
							MyGarrisons:UpdateBuildingTimerForScribe(k, k2)
						end
							--TODO Arena  159, 160, 161
						if v2.buildingID == 159 or v2.buildingID == 160 or v2.buildingID == 161 then
							MyGarrisons:UpdateBuildingTimerForTradePost(k, k2)
						end
							--TODO  war{8, 9, 10}
						if v2.buildingID == 8 or v2.buildingID == 9 or v2.buildingID == 10 then
							MyGarrisons:UpdateBuildingTimerForWar(k, k2)
						end
							--{94, 127, 128}
						if v2.buildingID == 94 or v2.buildingID == 127 or v2.buildingID == 128 then
							MyGarrisons:UpdateBuildingTimerForTailoring(k, k2)
						end
						--{76, 119, 120}
						if v2.buildingID == 76 or v2.buildingID == 119 or v2.buildingID == 120 then
							MyGarrisons:UpdateBuildingTimerForAlchemy(k, k2)
						end
						--29, 136, 137
						if v2.buildingID == 29 or v2.buildingID == 136 or v2.buildingID == 137 then
							MyGarrisons:UpdateBuildingTimerForHerb(k, k2)
						end
						--{65, 66, 67}
						if v2.buildingID == 65 or v2.buildingID == 66 or v2.buildingID == 67 then
							MyGarrisons:UpdateBuildingTimerForStable(k, k2)
						end
								--{96, 131, 132}
						if v2.buildingID == 96 or v2.buildingID == 131 or v2.buildingID == 132 then
							MyGarrisons:UpdateBuildingTimerForGem(k, k2)
						end
						if v2.buildingID == 26 or v2.buildingID == 27 or v2.buildingID == 28 then
							MyGarrisons:UpdateBuildingTimerForBarracks(k, k2)
						end
					end
				else
					if v2.Used == true then
						v2.Used = false
						v2:Hide()
						v.TimerBag.BuildingHeader.UsedBuildings = v.TimerBag.BuildingHeader.UsedBuildings - 1
						MyGarrisons:SortBuildingsByID(k)
					end
				end
			end
		end
	end
	MyGarrisons:CharacterHeaderSorter()
	MyGarrisons:ArrangeCharacterHeaders()
	MyGarrisonTimers:SetScript("OnUpdate", function () MyGarrisons:UpdateTimersForCharacters() end);
	--Reduces drop in frame rate, but prevents addon from using too much memory
	MGGarbageCounter = MGGarbageCounter + 1
	if MGGarbageCounter >= 300 then
		collectgarbage("collect") --Script ran too long error.
		MGGarbageCounter = 0
	end
end

--MyGarrisons:UpdateTimersForCharacters()

function MyGarrisons:RemoveBuildingTimer(headerIndex, timerIndex, buildingID)



end
function MGProtoResize1_OnClick()
	
end
------------------------------------------------------------------------
-- TimerBag Function
------------------------------------------------------------------------
--Collapse all

function MyGarrisons:SetUpTimerBag(headerIndex)
	local hi = headerIndex
	CharacterHeaders[hi].TimerBag.MissionHeader = CreateFrame("Button", "MGMissionHeader"..(#CharacterHeaders),CharacterHeaders[hi].TimerBag,"MGMissionTimerFrameX") 
	CharacterHeaders[hi].TimerBag.MissionHeader:SetPoint("TOPLEFT",CharacterHeaders[hi].TimerBag,"TOPLEFT" )
	
	
	CharacterHeaders[hi].TimerBag.MissionHeader.MissionTimers = {}
	CharacterHeaders[hi].TimerBag.MissionHeader.Expanded = false
	CharacterHeaders[hi].TimerBag.MissionHeader.ActiveMissions = 0
	CharacterHeaders[hi].TimerBag.MissionHeader.HeaderIndex = hi
	CharacterHeaders[hi].TimerBag.MissionHeader.missionheader.HeaderIndex = hi
	--CharacterHeaders[headerIndex].TimerBag.MissionHeader:Hide()

	

	CharacterHeaders[hi].TimerBag.BuildingHeader = CreateFrame("Button", "MGBuildingHeader"..(#CharacterHeaders),CharacterHeaders[hi].TimerBag,"MGBuildingTimerFrameX") 
	CharacterHeaders[hi].TimerBag.BuildingHeader:SetPoint("TOPLEFT",CharacterHeaders[hi].TimerBag.MissionHeader,"BOTTOMLEFT" )
	--[[CharacterHeaders[hi].TimerBag.BuildingHeader.BuildingBag = CreateFrame("Frame", "MissionTimerBag"..(hi),CharacterHeaders[hi].TimerBag,"TimerBag2") 
	CharacterHeaders[hi].TimerBag.BuildingHeader.BuildingBag:SetPoint("TOPLEFT",CharacterHeaders[hi].TimerBag.MissionHeader,"BOTTOMLEFT" )
	CharacterHeaders[hi].TimerBag.BuildingHeader.BuildingBag.MissionTimers = {}
	CharacterHeaders[hi].TimerBag.BuildingHeader.BuildingBag.Expanded = false
	CharacterHeaders[hi].TimerBag.BuildingHeader.BuildingBag.ActiveMissions = 0
	CharacterHeaders[hi].TimerBag.BuildingHeader.BuildingBag.HeaderIndex = hi
	CharacterHeaders[hi].TimerBag.BuildingHeader.BuildingBag:Hide()]]--
	--CharacterHeaders[headerIndex].TimerBag.MissionHeader:Hide()
	CharacterHeaders[hi].TimerBag.BuildingHeader.Expanded = false;
	CharacterHeaders[hi].TimerBag.BuildingHeader.NumBuildings = 0
	CharacterHeaders[hi].TimerBag.BuildingHeader.UsedBuildings = 0
	CharacterHeaders[hi].TimerBag.BuildingHeader.BuildingTimers = {}
	CharacterHeaders[hi].TimerBag.BuildingHeader.HeaderIndex = hi
	CharacterHeaders[hi].TimerBag.BuildingHeader.buildingheader.HeaderIndex = hi
end
function MyGarrisons:AdjustMissionBuildingAnchors (hi)
	CharacterHeaders[hi].TimerBag.MissionHeader:SetPoint("TOPLEFT",CharacterHeaders[hi].TimerBag,"TOPLEFT" )
	CharacterHeaders[hi].TimerBag.BuildingHeader:SetPoint("TOPLEFT",CharacterHeaders[hi].TimerBag.MissionHeader,"BOTTOMLEFT" )
end

-- =================================================================================================
-- Mission Timers
-- =================================================================================================

function MyGarrisons:MissionHeaderClick(HeaderIndex)
	if CharacterHeaders[HeaderIndex].TimerBag.MissionHeader.Expanded then
		CharacterHeaders[HeaderIndex].TimerBag.MissionHeader.Expanded = false
	else
		CharacterHeaders[HeaderIndex].TimerBag.MissionHeader.Expanded = true
	end
end

function MyGarrisons:UpdateMissionTimerBagX(TheHeader)--TODO Modify to hide stuff
	if  CharacterHeaders[TheHeader] ~= nil then
		if CharacterHeaders[TheHeader].TimerBag.MissionHeader.Expanded == false then
			for k,v in pairs (CharacterHeaders[TheHeader].TimerBag.MissionHeader.MissionTimers) do
				if v.Used then
					v:Hide()
				end
			end
			CharacterHeaders[TheHeader].TimerBag.MissionHeader:SetHeight(40)
		else
			MyGarrisons:SortMissionsByTimeLeft(TheHeader)
			if CharacterHeaders[TheHeader].TimerBag.MissionHeader.ActiveMissions ~= nil then
				CharacterHeaders[TheHeader].TimerBag.MissionHeader:SetHeight(40 + CharacterHeaders[TheHeader].TimerBag.MissionHeader.ActiveMissions * 44)
			end
			for k,v in pairs (CharacterHeaders[TheHeader].TimerBag.MissionHeader.MissionTimers) do
				if v.Used then
					v:Show()
				end
			end
		end
	end
end
function MyGarrisons:AddMissionTimer(characterID, realmID, missionID)
	--Find headerIndex.
	local headerIndex = 0
	for ind = 1, #CharacterHeaders do
		if CharacterHeaders[ind].Frame.characterID == characterID and CharacterHeaders[ind].Frame.realmID == realmID then
			headerIndex = ind
		end
	end
	if headerIndex ~= 0 then
		--figure out how many mission timers are already in it.
		if #CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers == 0 then
			MyGarrisons:AddNewMissionTimer(characterID, realmID, missionID, headerIndex)
		else
			if CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions == #CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers then
				MyGarrisons:AddNewMissionTimer(characterID, realmID, missionID, headerIndex)
			else
				MyGarrisons:ReuseMissionTimer(characterID, realmID, missionID, headerIndex)
			end
		end
	else
	
	end
end

function MyGarrisons:AddNewMissionTimer(characterID, realmID, missionID, headerIndex)
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions = CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions + 1
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions] = 
	 CreateFrame("Button", "MissionTimer"..(headerIndex).."-"..CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions 
		,CharacterHeaders[headerIndex].TimerBag.MissionHeader,
		"MGMissionTimer") ;
	if CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions == 1 then
		CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions]:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.MissionHeader.missionheader,"BOTTOMLEFT" )
	else
		CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions]:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[#(CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers)-1],"BOTTOMLEFT" )
	end
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions].Used = true;
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions].realmID = realmID
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions].characterID = characterID
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions].missionID = missionID
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions].headerIndex = headerIndex
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions].missionindex = CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions
	if CharacterHeaders[headerIndex].TimerBag.MissionHeader.Expanded == false then
		CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions]:Hide()
	end	
--MyGarrisons:MissionTooltip(characterID, realmID, missionID)
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions]:SetScript("OnEnter", 
	
																																									function () MyGarrisons:MissionTooltip(characterID, realmID, missionID)
																																									end)
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions]:SetScript("OnLeave",	function () GameTooltip:Hide() end)

end

function MyGarrisons:ReuseMissionTimer(characterID, realmID, missionID, headerIndex)
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions = CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions + 1
	local activeMis = CharacterHeaders[headerIndex].TimerBag.MissionHeader.ActiveMissions
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[activeMis].Used = true;
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[activeMis].realmID = realmID
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[activeMis].characterID = characterID
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[activeMis].missionID = missionID
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[activeMis].headerIndex = headerIndex
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[activeMis].missionindex = activeMis --TODO CHECK
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[activeMis]:Hide()
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[activeMis]:SetScript("OnEnter", 
	
	function () MyGarrisons:MissionTooltip(characterID, realmID, missionID) end)
	CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[activeMis]:SetScript("OnLeave", function () GameTooltip:Hide() end)
end
function MyGarrisons:SortMissionsByTimeLeft(headerIndex)
	sort(CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers, function(a,b)
	
		
		local endTimeA  = 0
		local endTimeB = 0
		if MyGarrisons.db.global.MGRealms[a.realmID].Characters[a.characterID].Missions[a.missionID] ~= nil then
			endTimeA = MyGarrisons.db.global.MGRealms[a.realmID].Characters[a.characterID].Missions[a.missionID].EndTime
		end
		if MyGarrisons.db.global.MGRealms[b.realmID].Characters[b.characterID].Missions[b.missionID] ~= nil then
			endTimeB = MyGarrisons.db.global.MGRealms[b.realmID].Characters[b.characterID].Missions[b.missionID].EndTime
		end
	
		local timeleftA = difftime(endTimeA, time())
		local timeleftB = difftime(endTimeB, time())
		if a.Used == b.Used then
			if timeleftA < timeleftB then
				return true
			else
				return false
			end
		else
			if a.Used == true then
				return true
			else
				return false
			end
		end
	end)
	for k = 1, #CharacterHeaders do
		CharacterHeaders[k].Frame.index = k
	end
end
function MyGarrisons:SortMissionsByName(headerIndex)
	sort(CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers, function(a,b)
		local nameA = tostring(C_Garrison.GetMissionName(a.missionID))
		local nameB = tostring(C_Garrison.GetMissionName(b.missionID))
		if a.Used == b.Used then
			return nameA < nameB
		else
			if a.Used == true then
				return true
			else
				return false
			end
		end
	end)
	for k = 1, #CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers do
		CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[k].headerIndex = headerIndex
		CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[k].missionindex = k
	end
end

function MyGarrisons:ArrangeCharacterMissions(headerIndex)
	for k,v in pairs (CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers) do
		v:ClearAllPoints()
		if k == 1 then
			v:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.MissionHeader.missionheader,"BOTTOMLEFT" )
		else
			v:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.MissionHeader.MissionTimers[k-1],"BOTTOMLEFT" )
		end
		v.headerIndex = headerIndex
		v.missionindex  = k
	end
end
function MyGarrisons:BuildingTooltip(characterID, realmID, buildingID)
	GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
	--Building Name & Level

	--Assigned Follower or Lack there of.

	--Work Order Details.

end
function MyGarrisons:MissionTooltip(characterID, realmID, missionID)
	GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
	--[[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID] = {
				StartTime = missionStartTime
				,EndTime =   missionEndTime
				,Followers = v.followers
			} ]]--
		GameTooltip:SetText(C_Garrison.GetMissionName(missionID))

		if(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID].EndTime < time()) then
            GameTooltip:AddLine(COMPLETE, 1, 1, 1);
        else
            GameTooltip:AddLine(tostring(MyGarrisons:ConvertSecondsToTime(0, MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID].EndTime)), 1, 1, 1);
        end
		GameTooltip:AddLine(" ");
		
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID].Followers ~= nil) then
            GameTooltip:AddLine(GARRISON_FOLLOWERS);
			--print(#MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID].Followers)
            for k,v in pairs(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID].Followers) do
				GameTooltip:AddLine(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Followers[v].Name, 1, 1, 1)
				--GameTooltip:AddLine(C_Garrison.GetFollowerName(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions[missionID].Followers[i]), 1, 1, 1);--TEST
            end
            GameTooltip:AddLine(" ");
        end

	GameTooltip:AddLine(REWARDS)
	local rewardText = ""
local rewards = C_Garrison.GetMissionRewardInfo(missionID);
	 for id, reward in pairs(rewards) do
        if string.len(rewardText) > 0 then
            rewardText = rewardText.."\n";
        end
 
        if (reward.quality) then
            rewardText = rewardText.."\n"..ITEM_QUALITY_COLORS[reward.quality + 1].hex..reward.title..FONT_COLOR_CODE_CLOSE;
        elseif (reward.itemID) then
            local itemName, _, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(reward.itemID);
            if itemName then
                rewardText = rewardText..ITEM_QUALITY_COLORS[itemRarity].hex..itemName..FONT_COLOR_CODE_CLOSE;
            end
        elseif (reward.followerXP) then
            rewardText = rewardText.."\n"..reward.title;
        else
            rewardText = rewardText.."\n"..reward.title;
        end
    end
	GameTooltip:AddLine(rewardText);
	GameTooltip:Show();
end
-- =================================================================================================
-- Building timers
-- =================================================================================================
function MyGarrisons:FillBuildingsForHeader(headerIndex)

	local characterID = CharacterHeaders[headerIndex].Frame.characterID
	local realmID = 	CharacterHeaders[headerIndex].Frame.realmID
	local timerIndex = 1
	for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings) do

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.NumBuildings = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.NumBuildings + 1
		local currentIndex = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.NumBuildings
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex] = CreateFrame("Button", "BuildingTimer"..(headerIndex).."-"..currentIndex 
		,CharacterHeaders[headerIndex].TimerBag.BuildingHeader,
		"BuildingTimer") ;
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].Used = true
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].characterID = characterID
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].realmID = realmID
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].buildingID = k
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].timerindex = currentIndex
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].HeaderIndex = headerIndex
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings + 1
	end
	MyGarrisons:SortBuildingsByID(headerIndex)
	MyGarrisons:ArrangeBuildingTimers(headerIndex)
--[[

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
		ConstructionStartTime = 0
	}


	]]--
end


function MyGarrisons:BuildingHeaderClick(HeaderIndex)
	
	if CharacterHeaders[HeaderIndex].TimerBag.BuildingHeader.Expanded then
		CharacterHeaders[HeaderIndex].TimerBag.BuildingHeader.Expanded = false
	else
		CharacterHeaders[HeaderIndex].TimerBag.BuildingHeader.Expanded = true
	end
end

function MyGarrisons:UpdateBuildingTimer(TheHeader)


	if  CharacterHeaders[TheHeader] ~= nil then
		if CharacterHeaders[TheHeader].TimerBag.BuildingHeader.Expanded == false then
			for k,v in pairs (CharacterHeaders[TheHeader].TimerBag.BuildingHeader.BuildingTimers) do
				if v.Used then
					v:Hide()
				end
			end
			CharacterHeaders[TheHeader].TimerBag.BuildingHeader:SetHeight(40)
		else
			MyGarrisons:SortBuildingByTimeLeft(TheHeader)
			if CharacterHeaders[TheHeader].TimerBag.BuildingHeader.UsedBuildings ~= nil then
				CharacterHeaders[TheHeader].TimerBag.BuildingHeader:SetHeight(40 + CharacterHeaders[TheHeader].TimerBag.BuildingHeader.UsedBuildings * 45)
			end
			for k,v in pairs (CharacterHeaders[TheHeader].TimerBag.BuildingHeader.BuildingTimers) do
				if v.Used then
					v:Show()
				end
			end
		end
	end
end
function MyGarrisons:AddBuildingTimer(characterID, realmID, buildingID)
	--Find headerIndex.
	local headerIndex = 0
	for ind = 1, #CharacterHeaders do
		if CharacterHeaders[ind].Frame.characterID == characterID and CharacterHeaders[ind].Frame.realmID == realmID then
			headerIndex = ind
		end
	end
	--figure out how many mission timers are already in it.
	if #CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers == 0 then
		MyGarrisons:AddNewBuildingTimer(characterID, realmID, buildingID, headerIndex)
	else
		if CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings == #CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers then
			MyGarrisons:AddNewBuildingTimer(characterID, realmID, buildingID, headerIndex)
		else
			MyGarrisons:ReuseBuildingTimer(characterID, realmID, buildingID, headerIndex)
		end
	end
end

function MyGarrisons:AddNewBuildingTimer(characterID, realmID, buildingID, headerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings + 1
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings] = 
	 CreateFrame("Button", "BuildingTimer"..(headerIndex).."-"..CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings 
		,CharacterHeaders[headerIndex].TimerBag.BuildingHeader,
		"BuildingTimer") ;
	if CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings == 1 then
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings]:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.BuildingHeader.buildingheader,"BOTTOMLEFT" )
	else
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings]:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[#(CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers)-1],"BOTTOMLEFT" )
	end
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings].Used = true;
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings].realmID = realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings].characterID = characterID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings].buildingID = buildingID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings].headerIndex = headerIndex
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings].buildingindex = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings
	if CharacterHeaders[headerIndex].TimerBag.BuildingHeader.Expanded == false then
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings]:Hide()
	end	

end

function MyGarrisons:ReuseBuildingTimer(characterID, realmID, buildingID, headerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings + 1
	local activeMis = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.UsedBuildings
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[activeMis].Used = true;
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[activeMis].realmID = realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[activeMis].characterID = characterID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[activeMis].buildingID = buildingID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[activeMis].headerIndex = headerIndex
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[activeMis].buildingindex = activeMis
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[activeMis]:Hide()
end
function MyGarrisons:SortBuildingByTimeLeft(headerIndex)
	--[[sort(CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers, function(a,b)
	
		
		local endTimeA  = 0
		local endTimeB = 0
		if MyGarrisons.db.global.MGRealms[a.realmID].Characters[a.characterID].Missions[a.missionID] ~= nil then
		
			endTimeA = MyGarrisons.db.global.MGRealms[a.realmID].Characters[a.characterID].Missions[a.missionID].EndTime
		end
		if MyGarrisons.db.global.MGRealms[b.realmID].Characters[b.characterID].Missions[b.missionID] ~= nil then
			endTimeB = MyGarrisons.db.global.MGRealms[b.realmID].Characters[b.characterID].Missions[b.missionID].EndTime
		end
	
			local timeleftA = difftime(endTimeA, time())
		local timeleftB = difftime(endTimeB, time())
		if a.Used == b.Used then
			
			if timeleftA < timeleftB then
				return true
			
			else
				return false
			end
		else
			if a.Used == true then
				return true
			else
				return false
			end
		end
	end)
	for k = 1, #CharacterHeaders do
		CharacterHeaders[k].Frame.index = k
	end]]--

end
function MyGarrisons:SortBuildingsByName(headerIndex)
--[[
	sort(CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers, function(a,b)
		local nameA = tostring(C_Garrison.GetMissionName(a.missionID))
		local nameB = tostring(C_Garrison.GetMissionName(b.missionID))
		if a.Used == b.Used then
		--	print(nameA)
			return nameA < nameB
			
		else
			if a.Used == true then
				return true
			else
				return false
			end
		end
	end)
	for k = 1, #CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers do
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[k].headerIndex = headerIndex
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[k].buildingindex = k
	end]]--

end
function MyGarrisons:SortBuildingsByID(headerIndex)

	sort(CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers, function(a,b)

		if a.Used == b.Used then
		--	print(nameA)
			return a.buildingID < b.buildingID
		else
			if a.Used == true then
				return true
			else
				return false
			end
		end
	end)
	for k = 1, #CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers do
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[k].headerIndex = headerIndex
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[k].buildingindex = k
	end

end
function MyGarrisons:ArrangeBuildingTimers(headerIndex)
	for k,v in pairs (CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers) do
		v:ClearAllPoints()
		if k == 1 then
			v:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.BuildingHeader.buildingheader,"BOTTOMLEFT" )
		else
			v:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[k-1],"BOTTOMLEFT" )
		end
		v.headerIndex = headerIndex
		v.buildingindex  = k
	end
end
--[[function MyGarrisons:FillBuildingsForHeader(headerIndex)

	local characterID = CharacterHeaders[headerIndex].Frame.characterID
	local realmID = 	CharacterHeaders[headerIndex].Frame.realmID
	local timerIndex = 1
	for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings) do

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.NumBuildings = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.NumBuildings + 1
		local currentIndex = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.NumBuildings
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex] = CreateFrame("Button", "BuildingTimer"..(headerIndex).."-"..currentIndex 
		,CharacterHeaders[headerIndex].TimerBag.BuildingHeader,
		"BuildingTimer") ;
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].characterID = characterID
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].realmID = realmID
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].buildingID = k
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].timerindex = currentIndex
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[currentIndex].HeaderIndex = headerIndex

	end
	MyGarrisons:ArrangeBuildingTimers(headerIndex)


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
		ConstructionStartTime = 0
	}


	
end

function MyGarrisons:UpdateBuildingTimer(TheHeader)
	if  CharacterHeaders[TheHeader] ~= nil then
		if CharacterHeaders[TheHeader].TimerBag.BuildingHeader.Expanded == false then
		--print("Unexpanded X")
			for k,v in pairs (CharacterHeaders[TheHeader].TimerBag.BuildingHeader.BuildingTimers) do
				if v.Used then

					v:Hide()
				end
			end
			CharacterHeaders[TheHeader].TimerBag.BuildingHeader:SetHeight(40)
		else
			--MyGarrisons:SortMissionsByTimeLeft(TheHeader)
		--print("expanded X")
			if CharacterHeaders[TheHeader].TimerBag.BuildingHeader.NumBuildings ~= nil then
				CharacterHeaders[TheHeader].TimerBag.BuildingHeader:SetHeight(40 + CharacterHeaders[TheHeader].TimerBag.BuildingHeader.NumBuildings * 92)
			end
			for k,v in pairs (CharacterHeaders[TheHeader].TimerBag.BuildingHeader.BuildingTimers) do
				if v.Used then
					print("x")
					v:Show()
				end
			end
		end
	end
	
end
function MyGarrisons:ArrangeBuildingTimers(headerIndex)

	for k = 1, #CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers do
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[k].timerindex = k
		if k == 1 then
		
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[k]:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.BuildingHeader.MGMissionHeader,"BOTTOMLEFT" )
			
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[k]:SetPoint("TOPLEFT",CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[k-1],"BOTTOMLEFT" )
		end
	end
end
function MyGarrisons:BuildingHeaderClick(HeaderIndex)
if CharacterHeaders[HeaderIndex].TimerBag.BuildingHeader.Expanded then
		CharacterHeaders[HeaderIndex].TimerBag.BuildingHeader.Expanded = false
	else
		CharacterHeaders[HeaderIndex].TimerBag.BuildingHeader.Expanded = true
	end
end]]--
-- =================================================================================================
-- Building Specifics
-- =================================================================================================


function MyGarrisons:UpdateBuildingTimerForInn(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText("")
end
function MyGarrisons:UpdateBuildingTimerForStorehouse(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText("")
end

function MyGarrisons:UpdateBuildingTimerForBlacksmith(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end
function MyGarrisons:UpdateBuildingTimerForLeather(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end

function MyGarrisons:UpdateBuildingTimerForEnchant(headerIndex, timerIndex)

	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end 
	end
end
function MyGarrisons:UpdateBuildingTimerForScribe(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end

end
function MyGarrisons:UpdateBuildingTimerForTech(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)

	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end
function MyGarrisons:UpdateBuildingTimerForWar(headerIndex, timerIndex)
	
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if buildingID == 10 then
		--CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Show()
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bg5time:Show()

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bg5time:SetText("Scrap")
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[10].SpecialData == nil then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[10].SpecialData =MyGarrisons:GetBuildingSpecialData(10)
		end
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[10].SpecialData.Quests == nil then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[10].SpecialData =MyGarrisons:GetBuildingSpecialData(10)
		end
--MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[nam].Garrison.Buildings[10].SpecialData.Quests.Completed = true
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[10].SpecialData.Quests.ResetsAt < time() then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[10].SpecialData.Quests.Completed = false
			--MyGarrisons.db.global.MGRealms[realmID].Characters[nam].Garrison.Buildings[10].SpecialData.Quests.Completed = true
		end
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[10].SpecialData.Quests.ResetsAt = time()+GetQuestResetTime()
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[10].SpecialData.Quests.Completed == false then
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady.png")
	else
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready.png")
	end
	end
	--MyGarrisons.db.global.MGRealms[v2.realmID].Characters[v2.characterID].Garrison.Buildings[v2.buildingID].SpecialData = MyGarrisons:GetBuildingSpecialData(v2.buildingID)
	--{Quest = {ResetsAt = 0, Completed = false}, WarSeal = {Used = false, ResetsAt = 0}}


	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end
--UpdateBuildingTimerForTradePost
function MyGarrisons:UpdateBuildingTimerForTradePost(headerIndex, timerIndex)

	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end
function MyGarrisons:UpdateBuildingTimerForBarn(headerIndex, timerIndex)

	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end
function MyGarrisons:UpdateBuildingTimerForLumber(headerIndex, timerIndex)

	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end

function MyGarrisons:UpdateBuildingTimerForEngineer(headerIndex, timerIndex)

	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end 
end
function MyGarrisons:UpdateBuildingTimerForTailoring(headerIndex, timerIndex)

	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end
function MyGarrisons:UpdateBuildingTimerForPortalHub(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()

	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	--MGPortalIcons
	--[[BuildingSpecialDatas[37] = {Location1 = ""}
BuildingSpecialDatas[38] = {Location1 = "", Location2 = ""}
BuildingSpecialDatas[39] = {Location1 = "", Location2 = "", Location3 = ""}]]--
	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
	-----------------CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText("")
	if buildingID == 37 then
		if MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1] ~= nil then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1:Show()
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1.porttext:SetTexture(MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1])
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1 ~= "" then
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1:SetScript("OnEnter", function ()  
					GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1))
				end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1:SetScript("OnLeave", function () GameTooltip:Hide() end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1.portname:SetText("1")
			end
		end
	end
	if buildingID == 38 then
		if MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1] ~= nil then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1:Show()
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1.porttext:SetTexture(MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1])
			
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1 ~= "" then
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1:SetScript("OnEnter", function ()  
					GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1))
				end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1:SetScript("OnLeave", function () GameTooltip:Hide() end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1.portname:SetText("1")
			end
		end
		if MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location2] ~= nil then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2:Show()
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2.porttext:SetTexture(MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location2])
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location2 ~= "" then
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2:SetScript("OnEnter", function ()  
					GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location2))
				end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2:SetScript("OnLeave", function () GameTooltip:Hide() end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2.portname:SetText("2")
			end
		end
	end
	if buildingID == 39 then
		if MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1] ~= nil then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1:Show()
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1.porttext:SetTexture(MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1])
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1 ~= "" then
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1:SetScript("OnEnter", function ()  
					GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location1))
				end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1:SetScript("OnLeave", function () GameTooltip:Hide() end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal1.portname:SetText("1")
			end
		end
		if MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location2] ~= nil then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2:Show()
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2.porttext:SetTexture(MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location2])
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location2 ~= "" then
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2:SetScript("OnEnter", function ()  
					GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location2))
				end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2:SetScript("OnLeave", function () GameTooltip:Hide() end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal2.portname:SetText("2")
			end
		end
		if MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location3] ~= nil then
			
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal3:Show()
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal3.porttext:SetTexture(MGPortalIcons[MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location3])
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location3 ~= "" then
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal3:SetScript("OnEnter", function ()  
					GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Location3))
				end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal3:SetScript("OnLeave", function () GameTooltip:Hide() end)
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].portal.portal3.portname:SetText("3")
			end			
		end
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
	
	end
	

end
function MyGarrisons:UpdateBuildingTimerForSalvage(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID  = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID     = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText("")
end
function MyGarrisons:UpdateBuildingTimerForGem(headerIndex, timerIndex)
	
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bg4time:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:Show()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData == nil then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData = MyGarrisons:GetBuildingSpecialData(buildingID)
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.ResetsAt =time()+GetQuestResetTime()
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.Completed = false
	end
if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.ResetsAt == nil then
MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.ResetsAt =time()+GetQuestResetTime()
end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.ResetsAt < time() then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.Completed = false
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.ResetsAt  = time()+GetQuestResetTime()
	end

	--CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("Jewelcrafting Daily")
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:Show()

	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.Completed == false then
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady.png")
	else
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready.png")
	end

end
function MyGarrisons:UpdateBuildingTimerForFishing(headerIndex, timerIndex)
	
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bg4time:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:Show()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	

	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.ResetsAt < time() then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.Completed = false
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.ResetsAt  = time()+GetQuestResetTime()
	end

	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("Fishing Daily")
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:Show()

	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Quests.Completed == false then
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady.png")
	else
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready.png")
	end

end
function MyGarrisons:UpdateBuildingTimerForAlchemy(headerIndex, timerIndex)
	
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")

	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end
function MyGarrisons:UpdateBuildingTimerForHerb(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Show()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	--_________________________________________________________________________________________________________________________________
	--Hot Fix for Herb farm nodes
	if buildingID == 29 then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.MaxNodes = 6
	end
	if buildingID == 136 then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.MaxNodes = 10
	end
	if buildingID == 137 then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.MaxNodes = 16
	end
	--_________________________________________________________________________________________________________________________________
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.ResetsAt < time() then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes = 0
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.ResetsAt = time()+GetQuestResetTime()
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID] ~= nil then
		--buildingID
		--characterID
		--realmID
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes ~= nil and MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.NextCrop ~= nil then
			local hIndex =  MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.NextCrop
			--	print(hIndex)
			if HerbIcons[hIndex] ~= nil then
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture(HerbIcons[hIndex])
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:Show()
			else
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture(HerbIcons["Let's go with a random planting."])
				CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:Show()
			end
--MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.NextCrop
			local OreString = "Herbs picked: ".. MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes.." / "..MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.MaxNodes
		
		
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText(OreString)
		else
			local OreString = "Herbs picked: ".. MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes.." / "..MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.MaxNodes
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText(OreString)
		end
CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:Show()
	end
	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end
function MyGarrisons:UpdateBuildingTimerForBarracks(headerIndex, timerIndex)
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Show()

	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData == nil then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData =MyGarrisons:GetBuildingSpecialData(buildingID)
		end
	if buildingID == 26 then
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:Hide();
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:Hide()
		return false
	end
	
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData~= nil then
	for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData) do
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[k].TimeStarted + 3600 < time() then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[k].TimeStarted = 0
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[k].IsDefeated = false
		end

	end
		 if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Faction == "Horde" then
		 
		local name1, rank1, icon1, castingTime1, minRange1, maxRange1, spellID1 = GetSpellInfo(173660)
		local name2, rank2, icon2, castingTime2, minRange2, maxRange2, spellID2 = GetSpellInfo(173661)
		local name3, rank3, icon3, castingTime3, minRange3, maxRange3, spellID3 = GetSpellInfo(173976)
		local name4, rank4, icon4, castingTime4, minRange4, maxRange4, spellID4 = GetSpellInfo(173658)
		local name5, rank5, icon5, castingTime5, minRange5, maxRange5, spellID5 = GetSpellInfo(173659)
		local name6, rank6, icon6, castingTime6, minRange6, maxRange6, spellID6 = GetSpellInfo(173657)
		

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:Hide();
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:Hide()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bgicon1:SetTexture(MGBodyguards.Horde[1].Image)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bgicon1:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bgicon2:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bgicon3:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bgicon6:Hide()

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bgicon2:SetTexture(MGBodyguards.Horde[2].Image)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bgicon3:SetTexture(MGBodyguards.Horde[3].Image)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture(MGBodyguards.Horde[4].Image)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:SetTexture(MGBodyguards.Horde[5].Image)
		
		--CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bgicon6:SetToFileData(1066345)
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[1].SpellID] == nil ) then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[1].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
		end
		local minutesLeft1 =  (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[1].SpellID].TimeStarted + 3600) - time()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[1].SpellID].IsDefeated == false then
			minutesLeft1 = 0
		else
		minutesLeft1 = minutesLeft1 / 60
		end
	
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bg1time:SetText(ceil(minutesLeft1).." m")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bg1time:Show()
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[2].SpellID] == nil ) then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[2].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
		end
		local minutesLeft2 = (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[2].SpellID].TimeStarted + 3600) - time()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[2].SpellID].IsDefeated == false then
		minutesLeft2 = 0
		else
		minutesLeft2 = minutesLeft2 / 60
		end
	

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bg2time:SetText(ceil(minutesLeft2).." m")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bg2time:Show()
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[3].SpellID] == nil ) then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[3].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
			end
		local minutesLeft3 =(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[3].SpellID].TimeStarted + 3600) - time()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[3].SpellID].IsDefeated == false then
		minutesLeft3 = 0
		else
		minutesLeft3 = minutesLeft3 / 60
		end
	
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bg3time:SetText(ceil(minutesLeft3).." m")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bg3time:Show()
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[4].SpellID] == nil ) then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[4].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
			end
		local minutesLeft4 =(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[4].SpellID].TimeStarted + 3600) - time()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[4].SpellID].IsDefeated == false then
			minutesLeft4 = 0
		else
		minutesLeft4 = minutesLeft4 / 60
		end

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bg4time:SetText(ceil(minutesLeft4).." m")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bg4time:Show()
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[5].SpellID] == nil ) then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[5].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
			end
		local minutesLeft5 = (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[5].SpellID].TimeStarted + 3600) - time()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Horde[5].SpellID].IsDefeated == false then
		minutesLeft5 = 0
		else
		minutesLeft5 = minutesLeft5 / 60
		end

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bg5time:SetText(ceil(minutesLeft5).." m")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bg5time:Show()
		
		local minutesLeft6 = (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[173657].TimeStarted + 3600) - time()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[173657].IsDefeated == false then
		minutesLeft6 = 0
		else
		minutesLeft6 = minutesLeft6 / 60
		end
	--print(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[173657].TimeStarted)

		--CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bg6time:SetText(ceil(minutesLeft6).." m")
		--CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bg6time:Show()

	end
if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Faction == "Alliance" then
		 
		local name1, rank1, icon1, castingTime1, minRange1, maxRange1, spellID1 = GetSpellInfo(173660)
		local name2, rank2, icon2, castingTime2, minRange2, maxRange2, spellID2 = GetSpellInfo(173661)
		local name3, rank3, icon3, castingTime3, minRange3, maxRange3, spellID3 = GetSpellInfo(173976)
		local name4, rank4, icon4, castingTime4, minRange4, maxRange4, spellID4 = GetSpellInfo(173658)
		local name5, rank5, icon5, castingTime5, minRange5, maxRange5, spellID5 = GetSpellInfo(173659)
		local name6, rank6, icon6, castingTime6, minRange6, maxRange6, spellID6 = GetSpellInfo(173657)
		

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:Hide();
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:Hide()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bgicon1:SetTexture(MGBodyguards.Alliance[1].Image)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bgicon1:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bgicon2:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bgicon3:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bgicon6:Hide()

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bgicon2:SetTexture(MGBodyguards.Alliance[2].Image)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bgicon3:SetTexture(MGBodyguards.Alliance[3].Image)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture(MGBodyguards.Alliance[4].Image)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:SetTexture(MGBodyguards.Alliance[5].Image)
		
		--CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bgicon6:SetToFileData(1066345)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData == nil then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData =MyGarrisons:GetBuildingSpecialData(buildingID)
		end
			if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[1].SpellID] == nil ) then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[1].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
			end

			local minutesLeft1 =  (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[1].SpellID].TimeStarted + 3600) - time()
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[1].SpellID].IsDefeated == false then
				minutesLeft1 = 0
			else
			minutesLeft1 = minutesLeft1 / 60
			end
	
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bg1time:SetText(ceil(minutesLeft1).." m")
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bg1time:Show()
		
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[2].SpellID] == nil ) then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[2].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
			end
			local minutesLeft2 = (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[2].SpellID].TimeStarted + 3600) - time()
			if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[2].SpellID].IsDefeated == false then
			minutesLeft2 = 0
			else
			minutesLeft2 = minutesLeft2 / 60
			end
	

			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bg2time:SetText(ceil(minutesLeft2).." m")
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bg2time:Show()
		
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[3].SpellID] == nil ) then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[3].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
			end
		local minutesLeft3 =(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[3].SpellID].TimeStarted + 3600) - time()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[3].SpellID].IsDefeated == false then
		minutesLeft3 = 0
		else
		minutesLeft3 = minutesLeft3 / 60
		end
	
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bg3time:SetText(ceil(minutesLeft3).." m")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bg3time:Show()
		
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[4].SpellID] == nil ) then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[4].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
			end
		local minutesLeft4 =(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[4].SpellID].TimeStarted + 3600) - time()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[4].SpellID].IsDefeated == false then
			minutesLeft4 = 0
		else
		minutesLeft4 = minutesLeft4 / 60
		end

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bg4time:SetText(ceil(minutesLeft4).." m")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bg4time:Show()
		
		if (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[5].SpellID] == nil ) then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[5].SpellID] = {TimeStarted = 0, IsDefeated = false, icon = ""}
			end
		local minutesLeft5 = (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[5].SpellID].TimeStarted + 3600) - time()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[MGBodyguards.Alliance[5].SpellID].IsDefeated == false then
		minutesLeft5 = 0
		else
		minutesLeft5 = minutesLeft5 / 60
		end

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bg5time:SetText(ceil(minutesLeft5).." m")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bg5time:Show()
		
		
	--print(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData[173657].TimeStarted)

		--CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bg6time:SetText(ceil(minutesLeft6).." m")
		--CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bg6time:Show()

	end

end
end

--[[if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v].SpecialData.IsDefeated == false then
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v].SpecialData.IsDefeated = true
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[v].SpecialData.TimeStarted = timeLeft
			end]]--
function MyGarrisons:UpdateBuildingTimerForMenagerie(headerIndex, timerIndex)
	--TODO
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.ResetsAt < time() then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Completed = false
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.ResetsAt  = time()+GetQuestResetTime()
	end
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bgicon1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bgicon2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bgicon3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bgicon6:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:Show()
	if buildingID == 42 or buildingID == 167 then
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Faction == "Horde" then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("Scrappin")
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("Battle Pet Roundup")
		end
	else
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("Mastering the Menagerie")
	end
	--print(tostring(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Completed).."  "..characterID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Completed == false then
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady.png")
	else
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready.png")
	end
end

function MyGarrisons:UpdateBuildingTimerForMine(headerIndex, timerIndex)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Hide()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Hide()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
		
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID] ~= nil then
		--buildingID
		--characterID
		--realmID
		--ResetsAt
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.ResetsAt < time() then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes = 0
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.ResetsAt = time()+GetQuestResetTime()
		end
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:Show()
		local OreString = "Ore mined: ".. MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes.." / "..MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.MaxNodes
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText(OreString)
	end
	MyGarrisons:UpdateShipment(characterID, realmID, buildingID)
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration ~= nil then
		local FinishedShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].FinishedWorkOrders
		local PendingShipments =  #MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderQueue
		local MaxShipments = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].MaxWorkOrders
		local Timeleft = MyGarrisons:ConvertSecondsToTimeStart( MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime + MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].ShipmentDuration)
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].WorkOrderStartTime ~= 0 then
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.."/"..PendingShipments.." of "..MaxShipments.." "..Timeleft)
		else
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:SetText(FinishedShipments.." ready for pick up.  "..(MaxShipments).." open")
		end
	end
end
function MyGarrisons:UpdateBuildingTimerForStable(headerIndex, timerIndex)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:Show()
	CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:Show()
	local buildingID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].buildingID
	local characterID= CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].characterID
	local realmID = CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].realmID
		
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID] ~= nil then
		--buildingID
		--characterID
		--realmID
		--local OreString = "Ore mined: ".. MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.UsedNodes.." / "..MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.MaxNodes
		--CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText(OreString)
		local name1, rank1, icon1, castingTime1, minRange1, maxRange1, spellID1 = GetSpellInfo(171831)
		local name2, rank2, icon2, castingTime2, minRange2, maxRange2, spellID2 = GetSpellInfo(171617)
		local name3, rank3, icon3, castingTime3, minRange3, maxRange3, spellID3 = GetSpellInfo(171637)
		local name4, rank4, icon4, castingTime4, minRange4, maxRange4, spellID4 = GetSpellInfo(171638)
		local name5, rank5, icon5, castingTime5, minRange5, maxRange5, spellID5 = GetSpellInfo(171841)
		local name6, rank6, icon6, castingTime6, minRange6, maxRange6, spellID6 = GetSpellInfo(171623)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:SetText("")
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].specialstring:Hide();
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].shipmentstring:Hide()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bgicon1:SetTexture(icon1)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bgicon1:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bgicon2:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bgicon3:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:Show()
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bgicon6:Show()

		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bgicon2:SetTexture(icon2)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bgicon3:SetTexture(icon3)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bgicon4:SetTexture(icon4)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bgicon5:SetTexture(icon5)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bgicon6:SetTexture(icon6)

		local quest1Max = 0
		local quest1Done = 0
		--171831
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData ~= nil then
		for k2,v2 in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Mounts[171831] ) do
			quest1Max = quest1Max + 1
			if v2.Completed then
				quest1Done = quest1Done + 1
			end
		end
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:SetScript("OnEnter", function () 
		
		GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(name1)
		end)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1:SetScript("OnLeave", function () GameTooltip:Hide() end)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bg1time:SetText(quest1Done.."/"..quest1Max)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe1.bg1time:Show()
		local quest2Max = 0
		local quest2Done = 0
--171617
		for k2,v2 in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Mounts[171617] ) do
			quest2Max = quest2Max + 1
			if v2.Completed then
				quest2Done = quest2Done + 1
			end
		end
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:SetScript("OnEnter", function () 
		
		GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(name2)
		end)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2:SetScript("OnLeave", function () GameTooltip:Hide() end)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bg2time:SetText(quest2Done.."/"..quest2Max)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe2.bg2time:Show()
		local quest3Max = 0
		local quest3Done = 0
		--171637
	for k2,v2 in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Mounts[171637] ) do
			quest3Max = quest3Max + 1
			if v2.Completed then
				quest3Done = quest3Done + 1
			end
		end
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:SetScript("OnEnter", function () 
		
		GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(name3)
		end)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3:SetScript("OnLeave", function () GameTooltip:Hide() end)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bg3time:SetText(quest3Done.."/"..quest3Max)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe3.bg3time:Show()
		local quest4Max = 0
		local quest4Done = 0
--171638
		for k2,v2 in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Mounts[171638] ) do
			quest4Max = quest4Max + 1
			if v2.Completed then
				quest4Done = quest4Done + 1
			end
		end
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:SetScript("OnEnter", function () 
		
		GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(name4)
		end)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4:SetScript("OnLeave", function () GameTooltip:Hide() end)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bg4time:SetText(quest4Done.."/"..quest4Max)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe4.bg4time:Show()
		local quest5Max = 0
		local quest5Done = 0
--171841
		for k2,v2 in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Mounts[171841] ) do
			quest5Max = quest5Max + 1
			if v2.Completed then
				quest5Done = quest5Done + 1
			end
		end
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:SetScript("OnEnter", function () 
		
		GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(name5)
		end)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5:SetScript("OnLeave", function () GameTooltip:Hide() end)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bg5time:SetText(quest5Done.."/"..quest5Max)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe5.bg5time:Show()
		local quest6Max = 0
		local quest6Done = 0
--171623
		for k2,v2 in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[buildingID].SpecialData.Mounts[171623] ) do
			quest6Max = quest6Max + 1
			if v2.Completed then
				quest6Done = quest6Done + 1
			end
		end
			CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:SetScript("OnEnter", function () 
		
		GameTooltip:SetOwner(MyGarrisonTimers, "ANCHOR_CURSOR_RIGHT");
					GameTooltip:SetText(name6)
		end)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6:SetScript("OnLeave", function () GameTooltip:Hide() end)
		
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bg6time:SetText(quest6Done.."/"..quest6Max)
		CharacterHeaders[headerIndex].TimerBag.BuildingHeader.BuildingTimers[timerIndex].bgframe6.bg6time:Show()
		end
	end
end
function MyGarrisons:HeaderUpdateAction()
	for k, v in pairs (CharacterHeaders) do
		local characterID= CharacterHeaders[k].CharacterID
		local realmID = CharacterHeaders[k].RealmID
		
	MyGarrisons:UpdateMissionCounter(characterID, realmID, k)
	end

	headerUpdateTimer =  MyGarrisons:ScheduleTimer("HeaderUpdateAction", 1)
end
local headerUpdateTimer =  MyGarrisons:ScheduleTimer("HeaderUpdateAction", 1)	
function MyGarrisons:CountDoneMissions(characterID, realmID)
	local counter = 0
	local soonest = 0
	local expmiss = 0
	for k,v in pairs (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions) do
		
		local timeleftA = difftime(v.EndTime, time())
		if  v.EndTime< time() then
			counter = counter + 1
			local foundexpearned = false;
			for kX,vX in pairs (v.Followers) do
				 if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Followers[vX].Level ~= 100 and (MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Followers[vX].Quality ~= 6 and MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Followers[vX].Quality ~= 5 ) then
				foundexpearned = true
				end
			
			end
			if foundexpearned then
expmiss = expmiss + 1
				end
			--Followers
		--[[	 MyGarrisons.db.global.MGRealms[GetRealmName()].Characters[characterID].Garrison.Followers[v.followerID] = {
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
			]]--
		else
			if soonest > v.EndTime  or soonest == 0 then
				soonest = v.EndTime
			
			end
		end
	end
	return counter, soonest, expmiss
end

function MyGarrisons:UpdateMissionCounter(characterID, realmID, ind)
local thischar = UnitName("player")
	local thisrealm = GetRealmName();
--ShowCache = true,
--						ShowMissionCounter = true,
--						ShowShipmentCounter = true,
--						ShowInvasion = true,
	if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowCache == nil then
		MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowCache = true
	end

	if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowCache == true then
		CharacterHeaders[ind].Frame.cache:Show()
		CharacterHeaders[ind].Frame.cacheAmount:Show()
	else
		CharacterHeaders[ind].Frame.cache:Hide()
		CharacterHeaders[ind].Frame.cacheAmount:Hide()
	end

	if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowMissionCounter == nil then
		MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowMissionCounter = true
	end

if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowMissionFollowerExp == nil then
MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowMissionFollowerExp = true
end
	if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowMissionCounter == true then
		CharacterHeaders[ind].Frame.missionscounter:Show()
		CharacterHeaders[ind].Frame.missionscounter.missiontitle:Show()
		local counter, soonest, expers = MyGarrisons:CountDoneMissions(characterID, realmID)
		local newstring = counter.."/".. MyGarrisons:TableSize(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Missions)
		CharacterHeaders[ind].Frame.missionscounter.counter:SetText(newstring)
		if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowMissionFollowerExp == true then
			CharacterHeaders[ind].Frame.missionscounter.followerexp:Show()
			CharacterHeaders[ind].Frame.missionscounter.expcount:Show()
			CharacterHeaders[ind].Frame.missionscounter.expcount:SetText(expers)
		else
			CharacterHeaders[ind].Frame.missionscounter.followerexp:Hide()
			CharacterHeaders[ind].Frame.missionscounter.expcount:Hide()
		end
	else
		CharacterHeaders[ind].Frame.missionscounter:Hide()
		CharacterHeaders[ind].Frame.missionscounter.missiontitle:Hide()
	end


	if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowShipmentCounter == nil then
		MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowShipmentCounter = false
	end
	if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowShipmentCounter == true then
		CharacterHeaders[ind].Frame.shipmentscounter:Show()
		CharacterHeaders[ind].Frame.ordertext:Show()
	else
		CharacterHeaders[ind].Frame.shipmentscounter:Hide()
		CharacterHeaders[ind].Frame.ordertext:Hide()
	end
	if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowInvasion == nil then
		MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowInvasion = true
	end

	if MyGarrisons.db.global.MGRealms[thisrealm].Characters[thischar].Settings.ShowInvasion == true then
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Invasion then
			CharacterHeaders[ind].Frame.invasion:Show()
		else
			CharacterHeaders[ind].Frame.invasion:Hide()
		end
		
	else
		CharacterHeaders[ind].Frame.invasion:Hide()
	end


end
--Stables
--{65, 66, 67}
--Mounts:  
--171831		Trained Silverpelt
--171617		Trained Icehoof
--171637		Trained Rocktusk
--171638		Trained Riverwallow
--171841		Trained Snarler
--171623		Trained Meadowstomper
-- =================================================================================================
-- Utilities
-- =================================================================================================

function MyGarrisons:ConvertSecondsToTime(timesec, endTime)
	
	local thetime =  difftime(endTime, time())

	local rHour = floor(thetime / (60 * 60));
 
   
    local divisor_for_minutes = thetime % (60 * 60);

    local rMin = floor(divisor_for_minutes / 60);
 
    
    local divisor_for_seconds = divisor_for_minutes % 60;
    local rSec = ceil(divisor_for_seconds);
--string.format("%.2d:%.2d:%.2d", s/(60*60), s/60%60, s%60)
	--format ("%.2d:%.2d:%.2d",rHour,rMin,rSec)
	return format ("%.2d:%.2d:%.2d",rHour,rMin,rSec)
end
function MyGarrisons:ConvertSecondsToTimeStart(startTime, duration)
	
	local thetime =  difftime(startTime, time())

	local rHour = floor(thetime / (60 * 60));
 
   
    local divisor_for_minutes = thetime % (60 * 60);

    local rMin = floor(divisor_for_minutes / 60);
 
    
    local divisor_for_seconds = divisor_for_minutes % 60;
    local rSec = ceil(divisor_for_seconds);
--string.format("%.2d:%.2d:%.2d", s/(60*60), s/60%60, s%60)
	--format ("%.2d:%.2d:%.2d",rHour,rMin,rSec)
	return format ("%.2d:%.2d:%.2d",rHour,rMin,rSec)
end
local Maximized = true
local OldHeight = 0
function MyGarrisons:MinizerMaxi()
	if Maximized then
					
		OldHeight = MyGarrisonTimers:GetHeight()
		MyGarrisonTimers.timerscroll:Hide()
		MyGarrisonTimers:SetHeight(19)
		Maximized = false
	else
		Maximized = true;
		MyGarrisonTimers:SetHeight(OldHeight)
		MyGarrisonTimers.timerscroll:Show()

	end
end