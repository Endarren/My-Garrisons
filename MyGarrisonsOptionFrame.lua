-- Author      : 
-- Create Date : 12/20/2014 7:26:11 PM
local OptionFrames = {}
local OptionsScrollFrame = nil
function MyGarrisons:SetUpOptionsFrame()

	--Creating Timer Frame Options panel
	OptionsScrollFrame = CreateFrame("Frame", "MGOptionsScrollFrame", MyGarrisonsOptionFrame.optionscroll)
	OptionsScrollFrame:SetSize(128, 28)
	--OptionsScrollFrame:SetPoint("TOPLEFT", MyGarrisonsOptionFrame.optionscroll,0,0 )
	--OptionsScrollFrame:SetAllPoints( MyGarrisonsOptionFrame.optionscroll)
	OptionsScrollFrame:Show()
		
	MyGarrisonsOptionFrame.optionscroll.OptionsScrollFrame = OptionsScrollFrame
 
	MyGarrisonsOptionFrame.optionscroll:SetScrollChild(OptionsScrollFrame)
	OptionFrames["options"] = {Created = true, 
								Frame = CreateFrame("Frame", "MGTimerOptionsFrame", MyGarrisonsOptionFrame.optionscroll.OptionsScrollFrame,"MGTimerOptionsPanel")}

	OptionFrames["options"].Frame:SetPoint("TOPLEFT", MyGarrisonsOptionFrame.optionscroll.OptionsScrollFrame,0,0 )
	OptionFrames["options"].Frame:Hide()
--Frame = CreateFrame("Button", "MGCharacterHeader"..(#CharacterHeaders+1),MyGarrisonTimers.timerscroll.GarrisonScrollContent,"MGCharacterHeader"),
end
----------------------------------------------------------------
-- Frame Options
local tempAlphaMouseOn =1
local tempAlphaMouseOff = 1


function MyGarrisons:ShowFrameOptions()
	--MyGarrisonsOptionFrame.optionscroll
	--optionscroll
	for k,v in pairs (OptionFrames) do
		if k == "options" then
			v.Frame:Show()
		else
			v.Frame:Hide()
		end
	end
	MyGarrisons:UpdateTimerOptions()
end

function MyGarrisons:RevertFrameOptions()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
end

function MyGarrisons:UpdateTimerOptions()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	OptionFrames["options"].Frame.onstartcheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowOnLogIn)
	OptionFrames["options"].Frame.hideoncheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.HideInCombat)
	OptionFrames["options"].Frame.alphaslider:SetValue(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alpha)


	OptionFrames["options"].Frame.cachecheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowCache)

	OptionFrames["options"].Frame.missheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowMissionCounter)

	OptionFrames["options"].Frame.shipcheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowShipmentCounter)

	OptionFrames["options"].Frame.invasioncheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowInvasion)

	OptionFrames["options"].Frame.tradecheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.TradeChatDisabled)

	OptionFrames["options"].Frame.generalcheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.GeneralChatDisabled)
	MyGarrisons:UpdateCharacterSortOptions()
end
function MyGarrisons:UpdateCharacterSortOptions()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
--OptionFrames["options"].Frame.missiontimeleftcheck:SetChecked()
	--OptionFrames["options"].Frame.characternamecheck:SetChecked()
	--sortUp
	--sortDown
	--MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters
	--Direction = 1,
--Type = "name"
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Type == "name" then
		OptionFrames["options"].Frame.characternamecheck:SetChecked(true)
		OptionFrames["options"].Frame.missiontimeleftcheck:SetChecked(false)
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Type == "mission" then
		OptionFrames["options"].Frame.characternamecheck:SetChecked(false)
		OptionFrames["options"].Frame.missiontimeleftcheck:SetChecked(true)
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction == 1 then
		OptionFrames["options"].Frame.sortUp:SetChecked(true)
		OptionFrames["options"].Frame.sortDown:SetChecked(false)
	else
		OptionFrames["options"].Frame.sortUp:SetChecked(false)
		OptionFrames["options"].Frame.sortDown:SetChecked(true)
	end
end
function MyGarrisons:SetCharacterSortName()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Type = "name"
	MyGarrisons:UpdateCharacterSortOptions()
end
function MyGarrisons:SetCharacterSortMissionTime()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Type = "mission"
	MyGarrisons:UpdateCharacterSortOptions()
end
function MyGarrisons:SetCharacterSortUp()
local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction = 1
	MyGarrisons:UpdateCharacterSortOptions()
end
function MyGarrisons:SetCharacterSortDown()
local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Sorting.Characters.Direction = -1
	MyGarrisons:UpdateCharacterSortOptions()
end
function MyGarrisons:ChangeAlpha()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alpha = OptionFrames["options"].Frame.alphaslider:GetValue()
end
function MyGarrisons:ChangeOnStart()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowOnLogIn = OptionFrames["options"].Frame.onstartcheck:GetChecked()
end
function MyGarrisons:ChangeCombatHide()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.HideInCombat =OptionFrames["options"].Frame.hideoncheck:GetChecked()
end

function MyGarrisons:ChangeInvasion()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowInvasion =OptionFrames["options"].Frame.invasioncheck:GetChecked()
end

function MyGarrisons:ChangeMissCounter()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowMissionCounter =OptionFrames["options"].Frame.missheck:GetChecked()
end

function MyGarrisons:ChangeShipCounter()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowShipmentCounter =OptionFrames["options"].Frame.shipcheck:GetChecked()
end

function MyGarrisons:ChangeCacheCounter()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowCache =OptionFrames["options"].Frame.cachecheck:GetChecked()
end


function MyGarrisons:ChangeTradeChat()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.TradeChatDisabled =OptionFrames["options"].Frame.tradecheck:GetChecked()
end

function MyGarrisons:ChangeGeneralChat()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.GeneralChatDisabled =OptionFrames["options"].Frame.generalcheck:GetChecked()
end



----------------------------------------------------------------
-- Building Options
function MyGarrisons:ShowBuildingOptions()


end