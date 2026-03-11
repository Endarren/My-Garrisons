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


	OptionFrames["alert"] = {Created = true, 
								Frame = CreateFrame("Frame", "MGTimerOptionsFrame", MyGarrisonsOptionFrame.optionscroll.OptionsScrollFrame,"MGAlertOptionFrame")}

	OptionFrames["alert"].Frame:SetPoint("TOPLEFT", MyGarrisonsOptionFrame.optionscroll.OptionsScrollFrame,0,0 )
	OptionFrames["alert"].Frame:Hide()
--Frame = CreateFrame("Button", "MGCharacterHeader"..(#CharacterHeaders+1),MyGarrisonTimers.timerscroll.GarrisonScrollContent,"MGCharacterHeader"),
end
----------------------------------------------------------------
-- Frame Alert
function MyGarrisons:ShowFrameAlert()
	--MyGarrisonsOptionFrame.optionscroll
	--optionscroll
	for k,v in pairs (OptionFrames) do
		if k == "alert" then
			v.Frame:Show()
		else
			v.Frame:Hide()
		end
	end
	MyGarrisons:UpdateAlertOptions()
end

function MyGarrisons:UpdateAlertOptions()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()

	--Alert = {Enabled = false, InCombat = false}
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alert == nil then
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alert = {Enabled = false, InCombat = false, Alpha = 1, Missions = true, Shipments = true, FinalShipment = true}
	end
	OptionFrames["alert"].Frame.alertcheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alert.Enabled)
	OptionFrames["alert"].Frame.combatalert:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alert.InCombat)
	OptionFrames["alert"].Frame.alertalphaslider:SetValue(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alert.Alpha)


	OptionFrames["alert"].Frame.missalert:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alert.Missions)
	OptionFrames["alert"].Frame.shipalert:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alert.Shipments)
	OptionFrames["alert"].Frame.finalshipalert:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alert.FinalShipment)
	

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
--alertbutton
function MyGarrisons:RevertFrameOptions()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
end
local IsColorPicking = {}
IsColorPicking["char-name"] = false
IsColorPicking["cache-name"] = false
IsColorPicking["cache-amount"] = false
function MyGarrisons:StartColorPickCharName()
	IsColorPicking["char-name"] = true
end
function MyGarrisons:ChangeCharacterNameColor()
	if IsColorPicking["char-name"] == true then
		local characterID, rea = UnitName("player")
		local realmID =  GetRealmName()
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character == nil then
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character = {Name = {r = 0, g = 0, b = 0}, 
			Cache = {r = 0, g = 0, b = 0}, Mission = {r = 0, g = 0, b = 0}, Shipment = {r = 0, g = 0, b = 0}}
		end
		if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.Exp == nil then
		
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission = 
					{Exp = {r = 198, g = 164, b = 8}, Title = {	r = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.r, 
																g = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.g, 
																b = MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.b }}
		end
		local r,g,b = ColorPickerFrame:GetColorRGB();
		if ColorPickerFrame:IsShown() == false then

			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.r = r
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.b = b
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.g = g
			IsColorPicking["char-name"]  = false
		end
		
	end
end



function MyGarrisons:StartColorPickCacheName()
	IsColorPicking["cache-name"] = true
end
function MyGarrisons:ChangeCacheNameColor()
	if IsColorPicking["cache-name"] == true then
		local characterID, rea = UnitName("player")
		local realmID =  GetRealmName()

		local r,g,b = ColorPickerFrame:GetColorRGB();
		if ColorPickerFrame:IsShown() == false then

			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.r = r
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.b = b
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.g = g
			IsColorPicking["cache-name"]  = false
		end
		
	end
end


function MyGarrisons:StartColorPickCacheAmount()
	IsColorPicking["cache-amount"] = true
end
function MyGarrisons:ChangeCacheAmountColor()
	if IsColorPicking["cache-amount"] == true then
		local characterID, rea = UnitName("player")
		local realmID =  GetRealmName()

		local r,g,b = ColorPickerFrame:GetColorRGB();
		if ColorPickerFrame:IsShown() == false then

			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Amount.r = r
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Amount.b = b
			MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Amount.g = g
			IsColorPicking["cache-name"]  = false
		end
		
	end
end







function MyGarrisons:UpdateTimerOptions()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	OptionFrames["options"].Frame.onstartcheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowOnLogIn)
	OptionFrames["options"].Frame.hideoncheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.HideInCombat)
	OptionFrames["options"].Frame.alphaslider:SetValue(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Alpha)


	OptionFrames["options"].Frame.cachecheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowCache)

	OptionFrames["options"].Frame.missheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowMissionCounter)
	
	OptionFrames["options"].Frame.missexpheck:SetChecked(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowMissionFollowerExp)
	
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

function MyGarrisons:ChangeMissExp()
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.ShowMissionFollowerExp =OptionFrames["options"].Frame.missexpheck:GetChecked()
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