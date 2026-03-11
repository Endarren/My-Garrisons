-- Author      : 
-- Create Date : 1/1/2015 9:22:32 AM




function MyGarrisons:SetAllPortalUncheckedExcept(locationNumber, index)
	for i = 1, 7 do
		if i ~= locationNumber then
			--print(i)
			MyGarrisonsPortalSetter["portal"..index]["select"..i]:SetChecked(false)
		end
	end
end
function MyGarrisons:OpenMGPortalSetter()
--MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37].SpecialData.Location1
	local characterID, realmi = UnitName("player")
	local realmID = GetRealmName()
	--{37, 38, 39}
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37] ~= nil then
		local loc1Name = GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37].SpecialData.Location1)
		local found1 = false;
		for i = 2,7 do
			if loc1Name == MyGarrisonsPortalSetter["portal"..1]["select"..i.."text"]:GetText() then
				MyGarrisonsPortalSetter["portal"..1]["select"..i]:SetChecked(true)
				found1 = true;
			else
				MyGarrisonsPortalSetter["portal"..1]["select"..i]:SetChecked(false)
			end
		end
		if found1 == false then
			MyGarrisonsPortalSetter["portal"..1]["select"..1]:SetChecked(true)
		end
	end
		--[[
		
	MyGarrisonsPortalSetter.portal1.select1text:SetText("None");
	MyGarrisonsPortalSetter.portal1.select2text:SetText(GetMapNameByID(949));
	MyGarrisonsPortalSetter.portal1.select3text:SetText(GetMapNameByID(947));
	MyGarrisonsPortalSetter.portal1.select4text:SetText(GetMapNameByID(948));
	MyGarrisonsPortalSetter.portal1.select5text:SetText(GetMapNameByID(950));
	MyGarrisonsPortalSetter.portal1.select6text:SetText(GetMapNameByID(941));
	MyGarrisonsPortalSetter.portal1.select7text:SetText(GetMapNameByID(946));

		
		]]--
	
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38] ~= nil then
		local loc1Name = GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location1)
		local found1 = false;
		for i = 2,7 do
			if loc1Name == MyGarrisonsPortalSetter["portal"..1]["select"..i.."text"]:GetText() then
				MyGarrisonsPortalSetter["portal"..1]["select"..i]:SetChecked(true)
				found1 = true;
			else
				MyGarrisonsPortalSetter["portal"..1]["select"..i]:SetChecked(false)
			end
		end
		if found1 == false then
			MyGarrisonsPortalSetter["portal"..1]["select"..1]:SetChecked(true)
		end


		local loc2Name = GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData.Location2)
		local found2 = false;
		for i = 2,7 do
			if loc2Name == MyGarrisonsPortalSetter["portal"..2]["select"..i.."text"]:GetText() then
				MyGarrisonsPortalSetter["portal"..2]["select"..i]:SetChecked(true)
				found2 = true;
			else
				MyGarrisonsPortalSetter["portal"..2]["select"..i]:SetChecked(false)
			end
		end
		if found2 == false then
			MyGarrisonsPortalSetter["portal"..2]["select"..1]:SetChecked(true)
		end
	end
	if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39] ~= nil then
		local loc1Name = GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location1)
		local found1 = false;
		for i = 2,7 do
			if loc1Name == MyGarrisonsPortalSetter["portal"..1]["select"..i.."text"]:GetText() then
				MyGarrisonsPortalSetter["portal"..1]["select"..i]:SetChecked(true)
				found1 = true;
			else
				MyGarrisonsPortalSetter["portal"..1]["select"..i]:SetChecked(false)
			end
		end
		if found1 == false then
			MyGarrisonsPortalSetter["portal"..1]["select"..1]:SetChecked(true)
		end


		local loc2Name = GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location2)
		local found2 = false;
		for i = 2,7 do
			if loc2Name == MyGarrisonsPortalSetter["portal"..2]["select"..i.."text"]:GetText() then
				MyGarrisonsPortalSetter["portal"..2]["select"..i]:SetChecked(true)
				found2 = true;
			else
				MyGarrisonsPortalSetter["portal"..2]["select"..i]:SetChecked(false)
			end
		end
		if found2 == false then
			MyGarrisonsPortalSetter["portal"..2]["select"..1]:SetChecked(true)
		end

		local loc3Name = GetMapNameByID(MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location3)
		local found3 = false;
		for i = 2,7 do
			if loc3Name == MyGarrisonsPortalSetter["portal"..3]["select"..i.."text"]:GetText() then
				MyGarrisonsPortalSetter["portal"..3]["select"..i]:SetChecked(true)
				found3 = true;
			else
				MyGarrisonsPortalSetter["portal"..3]["select"..i]:SetChecked(false)
			end
		end
		if found3 == false then
			MyGarrisonsPortalSetter["portal"..3]["select"..1]:SetChecked(true)
		end
	end
end

local MGNewPortalValues = {"", 949,947,948,950,941,946}
local MGWaygetSpellIds = {"", 173503, 173820, 173553,173808,173816,173797}
--[[
MGWayGateToZone[173816] =  941
MGWayGateToZone[173797] =  946
MGWayGateToZone[] =  947
MGWayGateToZone[] =  948
MGWayGateToZone[] =  949
MGWayGateToZone[] =  950

]]--

function MyGarrisons:SetUpPortalDropDowns()
	

	for p = 1,3 do
		MyGarrisonsPortalSetter["portal"..p].select1text:SetText("None");
		MyGarrisonsPortalSetter["portal"..p].select2text:SetText(GetMapNameByID(949));
		MyGarrisonsPortalSetter["portal"..p].select3text:SetText(GetMapNameByID(947));
		MyGarrisonsPortalSetter["portal"..p].select4text:SetText(GetMapNameByID(948));
		MyGarrisonsPortalSetter["portal"..p].select5text:SetText(GetMapNameByID(950));
		MyGarrisonsPortalSetter["portal"..p].select6text:SetText(GetMapNameByID(941));
		MyGarrisonsPortalSetter["portal"..p].select7text:SetText(GetMapNameByID(946));

		for i = 1,7 do
			local portalIndex = p;
			local checkindex = i;
			MyGarrisonsPortalSetter["portal"..p]["select"..i]:SetChecked(false)
			MyGarrisonsPortalSetter["portal"..p]["select"..i]:SetScript("OnClick",
				function ()  
				--	print(portalIndex.."  "..checkindex)
					local characterID, realmi = UnitName("player")
					local realmID = GetRealmName()
					--MGWaygetSpellIds
					--MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData.Location3
					if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37] ~= nil then
						MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37].SpecialData["Location"..portalIndex] =MGNewPortalValues[checkindex]
						--if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37].SpecialData["Location"..portalIndex] = 
						--MyGarrisons:RemovePortalFromTower(characterID, realmID, MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[37].SpecialData["Location"..portalIndex])
					end
					if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38] ~= nil then
						MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[38].SpecialData["Location"..portalIndex] =MGNewPortalValues[checkindex]
					end
					if MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39] ~= nil then
						MyGarrisons.db.global.MGRealms[realmID].Characters[characterID].Garrison.Buildings[39].SpecialData["Location"..portalIndex] =MGNewPortalValues[checkindex]
					end
					--MyGarrisons:RemovePortalFromTower(characterID, realmID, MGWaygetSpellIds[checkindex])
					--MyGarrisons:AddPortalToTower(characterID, realmID, MGWaygetSpellIds[checkindex])
					MyGarrisons:SetAllPortalUncheckedExcept(checkindex, portalIndex)
					--MGNewPortalValues
				end
				)
		end
		--TODO
	end
	MyGarrisons:OpenMGPortalSetter()
	--[[
	MyGarrisonsPortalSetter.portal1.select1text:SetText("None");
	MyGarrisonsPortalSetter.portal1.select2text:SetText(GetMapNameByID(949));
	MyGarrisonsPortalSetter.portal1.select3text:SetText(GetMapNameByID(947));
	MyGarrisonsPortalSetter.portal1.select4text:SetText(GetMapNameByID(948));
	MyGarrisonsPortalSetter.portal1.select5text:SetText(GetMapNameByID(950));
	MyGarrisonsPortalSetter.portal1.select6text:SetText(GetMapNameByID(941));
	MyGarrisonsPortalSetter.portal1.select7text:SetText(GetMapNameByID(946));



	MyGarrisonsPortalSetter.portal2.select1text:SetText("None");
	MyGarrisonsPortalSetter.portal2.select2text:SetText(GetMapNameByID(949));
	MyGarrisonsPortalSetter.portal2.select3text:SetText(GetMapNameByID(947));
	MyGarrisonsPortalSetter.portal2.select4text:SetText(GetMapNameByID(948));
	MyGarrisonsPortalSetter.portal2.select5text:SetText(GetMapNameByID(950));
	MyGarrisonsPortalSetter.portal2.select6text:SetText(GetMapNameByID(941));
	MyGarrisonsPortalSetter.portal2.select7text:SetText(GetMapNameByID(946));


	MyGarrisonsPortalSetter.portal3.select1text:SetText("None");
	MyGarrisonsPortalSetter.portal3.select2text:SetText(GetMapNameByID(949));
	MyGarrisonsPortalSetter.portal3.select3text:SetText(GetMapNameByID(947));
	MyGarrisonsPortalSetter.portal3.select4text:SetText(GetMapNameByID(948));
	MyGarrisonsPortalSetter.portal3.select5text:SetText(GetMapNameByID(950));
	MyGarrisonsPortalSetter.portal3.select6text:SetText(GetMapNameByID(941));
	MyGarrisonsPortalSetter.portal3.select7text:SetText(GetMapNameByID(946));
]]--
end

function MyGarrisons:ChangePortal1(val)
	MyGarrisonsPortalSetter.portal1.select1:SetChecked(val == 1)
	MyGarrisonsPortalSetter.portal1.select2:SetChecked(val == 2)
	MyGarrisonsPortalSetter.portal1.select3:SetChecked(val == 3)
	MyGarrisonsPortalSetter.portal1.select4:SetChecked(val == 4)
	MyGarrisonsPortalSetter.portal1.select5:SetChecked(val == 5)
	MyGarrisonsPortalSetter.portal1.select6:SetChecked(val == 6)
	MyGarrisonsPortalSetter.portal1.select7:SetChecked(val == 7)


end

function MyGarrisonsPortal2Input_OnTextChanged()
	
end
--{37, 38, 39}
function MyGarrisons:UpdatePortalSetter()



end