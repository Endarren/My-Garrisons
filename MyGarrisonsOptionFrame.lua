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

function MyGarrisons:MGColorSelection (identifier)

	local r,g, b = MyGarrisons:MGGetColor(identifier)
	MyGarrisons:StartColorPickCharName()
						--TODO cancelFunc
	ColorPickerFrame.func = function () MyGarrisons:MGSetColor(identifier) end
	ColorPickerFrame.cancelFunc = function () MyGarrisons:MGCancelColor(r,g,b, identifier) end
	ColorPickerFrame.previousValues = {r = r, g = g, b = b, opacity = 1}
	ColorPickerFrame:SetColorRGB(r, g, b);
	ColorPickerFrame:Show()

end
function MyGarrisons:MGSetColor(identifier)
	local characterID, rea = UnitName("player")
	local realmID =  GetRealmName()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	MyGarrisons:MGCancelColor(r,g,b, identifier)
	
end
function MyGarrisons:MGGetColor(identifier)
	local characterID, rea = UnitName("player")
		local realmID =  GetRealmName()
	local r,g,b = ColorPickerFrame:GetColorRGB();

	if identifier == "Char-Cache-Name" then --TODO add to the others
		return MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.r,
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.g,
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.b
	end
	if identifier == "Char-Name" then
	return MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.r,
MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.g,
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.b

	end
	if identifier == "Char-Miss-Total" then
	
		return true
	end

	if identifier == "Char-Miss-None" then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.None.r = r
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.None.g = g
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.None.b = b
		return true
	end
	if identifier == "Char-Miss-Half" then
		return MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.Half.r,
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.Half.g,
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.Half.b

	end
	if identifier == "Char-Miss-All" then
		return MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.All.r,
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.All.g,
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.All.b

	end
	if identifier == "Char-Miss-Exp" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.Exp.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.Exp.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.Exp.b
	
	end
	if identifier == "Char-Ship-Name" then
	
		return true
	end
	if identifier == "Char-Ship-Next" then
	
		return true
	end
	if identifier == "Char-Ship-NextTime" then
	
		return true
	end
	if identifier == "Char-Ship-Done" then
	
		return true
	end
	if identifier == "Char-Ship-Done-Time" then
	
		return true
	end
	if identifier == "Char-Ship-Done-Fin" then
	
		return true
	end
----------------------------------------------------------
	if identifier == "Mission-Name" then
	
		return true
	end
	if identifier == "Mission-Time" then
	
		return true
	end
	if identifier == "Mission-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Mining
	if identifier == "Build-Mine-Name" then
	
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.Name.b
	
	end
	if identifier == "Build-Mine-Node" then
	return		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.Node.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.Node.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.Node.b
	
	end
	if identifier == "Build-Mine-Node-None" then
	
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.NodeNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.NodeNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.NodeNone.b
	
	end
	if identifier == "Build-Mine-Node-Half" then
	
				return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.NodeHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.NodeHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.NodeHalf.b
	end
	if identifier == "Build-Mine-Node-All" then
	
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.NodeAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.NodeAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.NodeAll.b
	end
	if identifier == "Build-Mine-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.Timer.b
	
	end
	if identifier == "Build-Mine-Timer-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.TimerStart.b
	end
	if identifier == "Build-Mine-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.TimerHalf.b
	end
	if identifier == "Build-Mine-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Mine.TimerDone.b
	end
----------------------------------------------------------
	-- Fishing
	if identifier == "Build-Fish-Name" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Fish.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Fish.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Fish.Name.b

	end
	if identifier == "Build-Fish-Quest" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Fish.Quest.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Fish.Quest.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Fish.Quest.b
	end
----------------------------------------------------------
	-- Herb
	if identifier == "Build-Herb-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Name.b
	end
	if identifier == "Build-Herb-Node" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Node.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Node.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Node.b
	end
	if identifier == "Build-Herb-Node-None" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.NodeNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.NodeNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.NodeNone.b
	end
	if identifier == "Build-Herb-Node-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.NodeHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.NodeHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.NodeHalf.b
	end
	if identifier == "Build-Herb-Node-All" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.NodeAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.NodeAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.NodeAll.b
	end
	if identifier == "Build-Herb-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Timer.b
	end
	if identifier == "Build-Herb-Timer-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.TimerStart.b
	end
	if identifier == "Build-Herb-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.TimerHalf.b
	end
	if identifier == "Build-Herb-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.TimerDone.b
	end
	if identifier == "Build-Herb-Crop" then
				return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Crop.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Crop.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Herb.Crop.b
	end
----------------------------------------------------------
	-- Pet
	if identifier == "Build-Pet-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Pet.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Pet.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Pet.Name.b
	end
	if identifier == "Build-Pet-Quest" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Pet.Quest.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Pet.Quest.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Pet.Quest.b
	end
----------------------------------------------------------
	-- Storehouse
	if identifier == "Build-Store-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Store.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Store.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Store.Name.b
	end
----------------------------------------------------------
	-- Salvage
	if identifier == "Build-Salvage-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Salvage.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Salvage.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Salvage.Name.b
	end

----------------------------------------------------------
	-- Tailor
	if identifier == "Build-Tailor-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.Name.b
	end
	if identifier == "Build-Tailor-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.Timer.b
	end
	if identifier == "Build-Tailor-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.ShipNone.b
	end
	if identifier == "Build-Tailor-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.ShipHalf.b
	end
	if identifier == "Build-Tailor-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.ShipAll.b
	end
	if identifier == "Build-Tailor-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.TimerStart.b

	end
	if identifier == "Build-Tailor-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.TimerHalf.b
	end
	if identifier == "Build-Tailor-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Tailor.TimerDone.b
	end
----------------------------------------------------------
	-- Leather
	if identifier == "Build-Leather-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.Name.b
	end
	if identifier == "Build-Leather-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.Timer.b
	end
	if identifier == "Build-Leather-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.ShipNone.b
	end
	if identifier == "Build-Leather-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.ShipHalf.b
	end
	if identifier == "Build-Leather-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.ShipAll.b
	end
	if identifier == "Build-Leather-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.TimerStart.b

	end
	if identifier == "Build-Leather-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.TimerHalf.b
	end
	if identifier == "Build-Leather-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Leather.TimerDone.b
	end
----------------------------------------------------------
	-- Gem
	if identifier == "Build-Gem-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.Name.b
	end
	if identifier == "Build-Gem-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.Timer.b
	end
	if identifier == "Build-Gem-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.ShipNone.b
	end
	if identifier == "Build-Gem-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.ShipHalf.b
	end
	if identifier == "Build-Gem-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.ShipAll.b
	end
	if identifier == "Build-Gem-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.TimerStart.b
	end
	if identifier == "Build-Gem-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.TimerHalf.b
	end
	if identifier == "Build-Gem-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.TimerDone.b
	end
	if identifier == "Build-Gem-Quest" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.Quest.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.Quest.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gem.Quest.b
	end
----------------------------------------------------------
	-- Enchant
	if identifier == "Build-Enchant-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.Name.b
	end
	if identifier == "Build-Enchant-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.Timer.b
	end
	if identifier == "Build-Enchant-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.ShipNone.b
	end
	if identifier == "Build-Enchant-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.ShipHalf.b
	end
	if identifier == "Build-Enchant-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.ShipAll.b
	end
	if identifier == "Build-Enchant-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.TimerStart.b

	end
	if identifier == "Build-Enchant-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.TimerHalf.b
	end
	if identifier == "Build-Enchant-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Enchant.TimerDone.b
	end
----------------------------------------------------------
	-- Engineer
	if identifier == "Build-Engineer-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.Name.b
	end
	if identifier == "Build-Engineer-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.Timer.b
	end
	if identifier == "Build-Engineer-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.ShipNone.b
	end
	if identifier == "Build-Engineer-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.ShipHalf.b
	end
	if identifier == "Build-Engineer-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.ShipAll.b
	end
	if identifier == "Build-Engineer-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.TimerStart.b

	end
	if identifier == "Build-Engineer-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.TimerHalf.b
	end
	if identifier == "Build-Engineer-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Engineer.TimerDone.b
	end
----------------------------------------------------------
	-- Alchemy
if identifier == "Build-Alchemy-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.Name.b
	end
	if identifier == "Build-Alchemy-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.Timer.b
	end
	if identifier == "Build-Alchemy-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.ShipNone.b
	end
	if identifier == "Build-Alchemy-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.ShipHalf.b
	end
	if identifier == "Build-Alchemy-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.ShipAll.b
	end
	if identifier == "Build-Alchemy-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.TimerStart.b

	end
	if identifier == "Build-Alchemy-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.TimerHalf.b
	end
	if identifier == "Build-Alchemy-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.TimerDone.b
	end
	if identifier == "Build-Alchemy-Timer-Quest" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.Quest.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.Quest.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Alchemy.Quest.b
	end
----------------------------------------------------------
	-- Inscript
	if identifier == "Build-Inscript-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.Name.b
	end
	if identifier == "Build-Inscript-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.Timer.b
	end
	if identifier == "Build-Inscript-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.ShipNone.b
	end
	if identifier == "Build-Inscript-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.ShipHalf.b
	end
	if identifier == "Build-Inscript-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.ShipAll.b
	end
	if identifier == "Build-Inscript-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.TimerStart.b

	end
	if identifier == "Build-Inscript-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.TimerHalf.b
	end
	if identifier == "Build-Inscript-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inscript.TimerDone.b
	end
----------------------------------------------------------
	-- Barn
	if identifier == "Build-Barn-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.Name.b
	end
	if identifier == "Build-Barn-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.Timer.b
	end
	if identifier == "Build-Barn-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.ShipNone.b
	end
	if identifier == "Build-Barn-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.ShipHalf.b
	end
	if identifier == "Build-Barn-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.ShipAll.b
	end
	if identifier == "Build-Barn-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.TimerStart.b

	end
	if identifier == "Build-Barn-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.TimerHalf.b
	end
	if identifier == "Build-Barn-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barn.TimerDone.b
	end
----------------------------------------------------------
	-- Inn
	if identifier == "Build-Inn-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inn.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inn.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Inn.Name.b
	end
----------------------------------------------------------
	-- Trade
	if identifier == "Build-Trade-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.Name.b
	end
	if identifier == "Build-Trade-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.Timer.b
	end
	if identifier == "Build-Trade-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.ShipNone.b
	end
	if identifier == "Build-Trade-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.ShipHalf.b
	end
	if identifier == "Build-Trade-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.ShipAll.b
	end
	if identifier == "Build-Trade-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.TimerStart.b

	end
	if identifier == "Build-Trade-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.TimerHalf.b
	end
	if identifier == "Build-Trade-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Trade.TimerDone.b
	end
----------------------------------------------------------
	-- Lumber
	if identifier == "Build-Lumber-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.Name.b
	end
	if identifier == "Build-Lumber-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.Timer.b
	end
	if identifier == "Build-Lumber-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.ShipNone.b
	end
	if identifier == "Build-Lumber-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.ShipHalf.b
	end
	if identifier == "Build-Lumber-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.ShipAll.b
	end
	if identifier == "Build-Lumber-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.TimerStart.b

	end
	if identifier == "Build-Lumber-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.TimerHalf.b
	end
	if identifier == "Build-Lumber-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Lumber.TimerDone.b
	end
----------------------------------------------------------
	-- Arena
	if identifier == "Build-Arena-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.Name.b
	end
	if identifier == "Build-Arena-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.Timer.b
	end
	if identifier == "Build-Arena-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.ShipNone.b
	end
	if identifier == "Build-Arena-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.ShipHalf.b
	end
	if identifier == "Build-Arena-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.ShipAll.b
	end
	if identifier == "Build-Arena-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.TimerStart.b

	end
	if identifier == "Build-Arena-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.TimerHalf.b
	end
	if identifier == "Build-Arena-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Arena.TimerDone.b
	end
----------------------------------------------------------
	-- Mage Tower
	if identifier == "Build-Mage-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.Name.b
	end
	if identifier == "Build-Mage-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.Timer.b
	end
	if identifier == "Build-Mage-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.ShipNone.b
	end
	if identifier == "Build-Mage-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.ShipHalf.b
	end
	if identifier == "Build-Mage-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.ShipAll.b
	end
	if identifier == "Build-Mage-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.TimerStart.b

	end
	if identifier == "Build-Mage-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.TimerHalf.b
	end
	if identifier == "Build-Mage-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Portal.TimerDone.b
	end
----------------------------------------------------------
	-- Barracks
	if identifier == "Build-Barracks-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.Name.b
	
	end
	if identifier == "Build-Barracks-BG-None" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.BGNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.BGNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.BGNone.b
	end
	if identifier == "Build-Barracks-BG-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.BGHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.BGHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.BGHalf.b
	end
	if identifier == "Build-Barracks-BG-All" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.BGALL.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.BGALL.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Barrack.BGALL.b
	end	
----------------------------------------------------------
	-- Stables
	if identifier == "Build-Stables-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.Name.b
	
	end
	if identifier == "Build-Stables-Quests-None" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.QuestNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.QuestNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.QuestNone.b
	end
	if identifier == "Build-Stables-Quests-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.QuestHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.QuestHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.QuestHalf.b
	end
	if identifier == "Build-Stables-Quests-All" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.QuestAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.QuestAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Stable.QuestAll.b
	end
----------------------------------------------------------
	-- Gnome
	if identifier == "Build-Gnome-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.Name.b
	end
	if identifier == "Build-Gnome-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.Timer.b
	end
	if identifier == "Build-Gnome-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.ShipNone.b
	end
	if identifier == "Build-Gnome-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.ShipHalf.b
	end
	if identifier == "Build-Gnome-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.ShipAll.b
	end
	if identifier == "Build-Gnome-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.TimerStart.b

	end
	if identifier == "Build-Gnome-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.TimerHalf.b
	end
	if identifier == "Build-Gnome-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Gnome.TimerDone.b
	end
----------------------------------------------------------
	-- Dwarf
if identifier == "Build-Dwarf-Name" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.Name.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.Name.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.Name.b
	end
	if identifier == "Build-Dwarf-Timer" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.Timer.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.Timer.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.Timer.b
	end
	if identifier == "Build-Dwarf-Ship-Start" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.ShipNone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.ShipNone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.ShipNone.b
	end
	if identifier == "Build-Dwarf-Ship-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.ShipHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.ShipHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.ShipHalf.b
	end
	if identifier == "Build-Dwarf-Ship-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.ShipAll.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.ShipAll.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.ShipAll.b
	end
	if identifier == "Build-Dwarf-Timer-Start" then
	return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.TimerStart.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.TimerStart.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.TimerStart.b

	end
	if identifier == "Build-Dwarf-Timer-Half" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.TimerHalf.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.TimerHalf.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.TimerHalf.b
	end
	if identifier == "Build-Dwarf-Timer-Done" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.TimerDone.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.TimerDone.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.TimerDone.b
	end
	if identifier == "Build-Dwarf-Scrap" then
		return	MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.Scraps.r,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.Scraps.g,
				MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Buildings.Dwarf.Scraps.b
	end
end
function MyGarrisons:MGCancelColor(r,g,b, identifier)
local characterID, rea = UnitName("player")
		local realmID =  GetRealmName()

	if identifier == "Char-Name" then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.r = r
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.g = g
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Name.b = b

		return true
	end
	if identifier == "Char-Cache-Name" then --TODO add to the others
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.r = r
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.g = g
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Cache.Name.b = b
	end
	if identifier == "Char-Miss-Total" then
	
		--Mission = {CompletedRange = {None =DEFAULT_COLOR, 
		--Half = DEFAULT_COLOR, All = DEFAULT_COLOR },
		--Exp = DEFAULT_COLOR, Title = DEFAULT_COLOR}, 

		return true
	end
	if identifier == "Char-Miss-None" then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.None.r = r
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.None.g = g
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.None.b = b
		return true
	end
	if identifier == "Char-Miss-Half" then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.Half.r = r
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.Half.g = g
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.Half.b = b
		return true
	end
	if identifier == "Char-Miss-All" then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.All.r = r
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.All.g = g
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.CompletedRange.All.b = b
		return true
	end
	if identifier == "Char-Miss-Exp" then
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.Exp.r = r
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.Exp.g = g
		MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Settings.Colors.Character.Mission.Exp.b = b
		return true
	end
	if identifier == "Char-Ship-Name" then
	
		return true
	end
	if identifier == "Char-Ship-Next" then
	
		return true
	end
	if identifier == "Char-Ship-NextTime" then
	
		return true
	end
	if identifier == "Char-Ship-Done" then
	
		return true
	end
	if identifier == "Char-Ship-Done-Time" then
	
		return true
	end
	if identifier == "Char-Ship-Done-Fin" then
	
		return true
	end
----------------------------------------------------------
	if identifier == "Mission-Name" then
	
		return true
	end
	if identifier == "Mission-Time" then
	
		return true
	end
	if identifier == "Mission-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Mining
	if identifier == "Build-Mine-Name" then
	
		return true
	end
	if identifier == "Build-Mine-Node" then
	
		return true
	end
	if identifier == "Build-Mine-Node-None" then
	
		return true
	end
	if identifier == "Build-Mine-Node-Half" then
	
		return true
	end
	if identifier == "Build-Mine-Node-All" then
	
		return true
	end
	if identifier == "Build-Mine-Timer" then
	
		return true
	end
	if identifier == "Build-Mine-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Mine-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Mine-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Fishing
	if identifier == "Build-Fish-Name" then
	
		return true
	end
	if identifier == "Build-Fish-Quest" then
	
		return true
	end
----------------------------------------------------------
	-- Herb
	if identifier == "Build-Herb-Name" then
	
		return true
	end
	if identifier == "Build-Herb-Node" then
	
		return true
	end
	if identifier == "Build-Herb-Node-None" then
	
		return true
	end
	if identifier == "Build-Herb-Node-Half" then
	
		return true
	end
	if identifier == "Build-Herb-Node-All" then
	
		return true
	end
	if identifier == "Build-Herb-Timer" then
	
		return true
	end
	if identifier == "Build-Herb-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Herb-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Herb-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Pet
	if identifier == "Build-Pet-Name" then
	
		return true
	end
	if identifier == "Build-Pet-Quest" then
	
		return true
	end
----------------------------------------------------------
	-- Storehouse
	if identifier == "Build-Store-Name" then
	
		return true
	end
----------------------------------------------------------
	-- Salvage
	if identifier == "Build-Salvage-Name" then
	
		return true
	end

----------------------------------------------------------
	-- Tailor
	if identifier == "Build-Tailor-Name" then
	
		return true
	end
	if identifier == "Build-Tailor-Timer" then
	
		return true
	end
	if identifier == "Build-Tailor-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Tailor-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Tailor-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Tailor-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Tailor-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Tailor-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Leather
	if identifier == "Build-Leather-Name" then
	
		return true
	end
	if identifier == "Build-Leather-Timer" then
	
		return true
	end
	if identifier == "Build-Leather-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Leather-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Leather-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Leather-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Leather-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Leather-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Gem
	if identifier == "Build-Gem-Name" then
	
		return true
	end
	if identifier == "Build-Gem-Timer" then
	
		return true
	end
	if identifier == "Build-Gem-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Gem-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Gem-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Gem-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Gem-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Gem-Timer-Done" then
	
		return true
	end
	if identifier == "Build-Gem-Quest" then
	
		return true
	end
----------------------------------------------------------
	-- Enchant
	if identifier == "Build-Enchant-Name" then
	
		return true
	end
	if identifier == "Build-Enchant-Timer" then
	
		return true
	end
	if identifier == "Build-Enchant-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Enchant-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Enchant-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Enchant-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Enchant-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Enchant-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Engineer
	if identifier == "Build-Engineer-Name" then
	
		return true
	end
	if identifier == "Build-Engineer-Timer" then
	
		return true
	end
	if identifier == "Build-Engineer-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Engineer-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Engineer-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Engineer-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Engineer-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Engineer-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Alchemy
	if identifier == "Build-Alchemy-Name" then
	
		return true
	end
	if identifier == "Build-Alchemy-Timer" then
	
		return true
	end
	if identifier == "Build-Alchemy-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Alchemy-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Alchemy-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Alchemy-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Alchemy-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Alchemy-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Inscript
	if identifier == "Build-Inscript-Name" then
	
		return true
	end
	if identifier == "Build-Inscript-Timer" then
	
		return true
	end
	if identifier == "Build-Inscript-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Inscript-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Inscript-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Inscript-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Inscript-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Inscript-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Barn
	if identifier == "Build-Barn-Name" then
	
		return true
	end
	if identifier == "Build-Barn-Timer" then
	
		return true
	end
	if identifier == "Build-Barn-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Barn-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Barn-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Barn-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Barn-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Barn-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Inn
	if identifier == "Build-Inn-Name" then
	
		return true
	end
----------------------------------------------------------
	-- Trade
	if identifier == "Build-Trade-Name" then
	
		return true
	end
	if identifier == "Build-Trade-Timer" then
	
		return true
	end
	if identifier == "Build-Trade-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Trade-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Trade-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Trade-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Trade-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Trade-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Lumber
	if identifier == "Build-Lumber-Name" then
	
		return true
	end
	if identifier == "Build-Lumber-Timer" then
	
		return true
	end
	if identifier == "Build-Lumber-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Lumber-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Lumber-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Lumber-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Lumber-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Lumber-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Arena
	if identifier == "Build-Arena-Name" then
	
		return true
	end
	if identifier == "Build-Arena-Timer" then
	
		return true
	end
	if identifier == "Build-Arena-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Arena-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Arena-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Arena-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Arena-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Arena-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Mage Tower
	if identifier == "Build-Mage-Name" then
	
		return true
	end
	if identifier == "Build-Mage-PortalNum" then
	
		return true
	end
----------------------------------------------------------
	-- Barracks
	if identifier == "Build-Barracks-Name" then
	
		return true
	end
	if identifier == "Build-Barracks-BG-None" then
	
		return true
	end
	if identifier == "Build-Barracks-BG-Half" then
	
		return true
	end
	if identifier == "Build-Barracks-BG-All" then
	
		return true
	end	
----------------------------------------------------------
	-- Stables
	if identifier == "Build-Stables-Name" then
	
		return true
	end
	if identifier == "Build-Stables-Quests-None" then
	
		return true
	end
	if identifier == "Build-Stables-Quests-Half" then
	
		return true
	end
	if identifier == "Build-Stables-Quests-All" then
	
		return true
	end
----------------------------------------------------------
	-- Gnome
	if identifier == "Build-Gnome-Name" then
	
		return true
	end
	if identifier == "Build-Gnome-Timer" then
	
		return true
	end
	if identifier == "Build-Gnome-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Gnome-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Gnome-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Gnome-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Gnome-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Gnome-Timer-Done" then
	
		return true
	end
----------------------------------------------------------
	-- Dwarf

	if identifier == "Build-Dwarf-Name" then
	
		return true
	end
	if identifier == "Build-Dwarf-Timer" then
	
		return true
	end
	if identifier == "Build-Dwarf-Ship-Start" then
	
		return true
	end
	if identifier == "Build-Dwarf-Ship-Half" then
	
		return true
	end
	if identifier == "Build-Dwarf-Ship-Done" then
	
		return true
	end
	if identifier == "Build-Dwarf-Timer-Start" then
	
		return true
	end
	if identifier == "Build-Dwarf-Timer-Half" then
	
		return true
	end
	if identifier == "Build-Dwarf-Timer-Done" then
	
		return true
	end
	if identifier == "Build-Dwarf-Scrap" then
	
		return true
	end
end
-------------------------------------------------------------
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