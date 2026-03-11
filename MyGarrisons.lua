MyGarrisons = LibStub("AceAddon-3.0"):NewAddon("MyGarrisons", "AceConsole-3.0","AceComm-3.0", "AceEvent-3.0", "AceTimer-3.0","AceHook-3.0");



-- Simple class for date/time calculations in Lua 5.0
-- author: Philipp Janda <philipp.janda@web.de>
--
-- The algorithms for date calculations are from here:
--   http://home.capecod.net/~pbaum/date/date0.htm


-- Usage:
-- Create a date object using e.g.:
--   local d1 = date:parse( "31-12-2000" )
--   local d2 = date:parse( "29_2_2000/10:52:44" )
--   local d3 = date:parse( "01.10.1582 11:11:11" )
--   local d4 = date:now()
-- -- ...
-- Date delimiters can be `.', `_' or `-'. The only allowed time
-- delimiter is `:'. Between date and time strings there must be
-- exactly one (arbitrary) character.
--
-- You can output the date using:
--   print( d1 )
--
-- This is mainly for debugging. If you need finer control, you
-- will probably use the member variables of the date object to
-- do your own formatting:
--   print( d1.weekday, d1.day, d1.month, d1.year )
--   print( d1.hour, d1.minute, d1.second )
--
-- You can do date calculations assigning to the members of the
-- date objects. E.g.:
--   d1.day = d1.day + 10     -- add 10 days to date d1
--   d1.year = d1.year - 20   -- 20 years ago...
-- -- ...
-- Note that you cannot assign to the weekday member of date objects!
-- You can also calculate the number of seconds between two dates:
--   local nsecs = d1 - d2


-- Unresolved issues:
-- There are some unintuitive behaviours when subtracting months
-- (or maybe even leap years), e.g.:
--   local d = date:parse( "31.3.2003" )
--   d.month = d.month - 1
--   print( d )
-- --> 03.03.2003/00:00:00
-- 31.03.2003 minus one month is the 31.02.2003, but this date
-- doesn't exist, so we get 3 days after the 28th of february, which
-- is 03.03.2003!
-- This isn't beautiful, but kind of logic. I don't known if I should
-- change this behaviour since it is kind of implicit in the
-- calculation formulas.




local Public, Private, Meta = {}, {}, {}
caldate = Public



----------------------------------------------------------------------
-- private calculation functions

function Public.gregorian2daynumber( d, m, y )
  if m < 3 then
    m = m + 12
    y = y - 1
  end
  local a = math.floor( ( 153*m - 457 ) / 5 )
  local b = math.floor( y / 4 )
  local c = math.floor( y / 100 )
  local e = math.floor( y / 400 )
  return d + a + 365*y + b - c + e + 1721118.5
end


function Public.daynumber2gregorian( jdn )
  local temp = jdn - 1721118.5
  local z = math.floor( temp )
  local r = temp - z
  local g = z - 0.25
  local a = math.floor( g / 36524.25 )
  local b = a - math.floor( a / 4 )
  local year = math.floor( ( b + g ) / 365.25 )
  local c = b + z - math.floor(  365.25 * year )
  local month = mtrunc( ( 5*c + 456 ) / 153 )
  local day = c - mtrunc( ( 153*month - 457 ) / 5 ) + r
  if month > 12 then
    year = year + 1
    month = month - 12
  end
  return day, month, year
end


function Public.julian2daynumber( d, m, y )
  if m < 3 then
    m = m + 12
    y = y - 1
  end
  local a = math.floor( ( 153*m - 457 ) / 5 )
  local b = math.floor( y / 4 )
  return d + a + 365*y + b + 1721116.5
end


function Public.daynumber2julian( jdn )
  local temp = jdn - 1721116.5
  local z = math.floor( temp )
  local r = temp - z
  local year = math.floor( ( z - 0.25 ) / 365.25 )
  local c = z - math.floor( 365.25 * year )
  local month = mtrunc( ( 5*c + 456 ) / 153 )
  local day = c - mtrunc( ( 153*month - 457 ) / 5 ) + r
  if month > 12 then
    year = year + 1
    month = month - 12
  end
  return day, month, year
end


function Public.date2daynumber( day, month, year )
  if year > 1582 or
     ( year == 1582 and month > 10 ) or
     ( year == 1582 and month == 10 and day > 14 ) then
    return Public.gregorian2daynumber( day, month, year )
  else
    return Public.julian2daynumber( day, month, year )
  end
end


function Public.daynumber2date( jdn )
  local day, month, year
  if jdn > 2299160 then
    day, month, year = Public.daynumber2gregorian( jdn )
  else
    day, month, year = Public.daynumber2julian( jdn )
  end
  return day, month, year
end


local seconds_per_minute = 60
local seconds_per_hour = 60 * seconds_per_minute
local seconds_per_day = 24 * seconds_per_hour
Private.weekday = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" }


function Private.update( data )
  local ticks = data.ticks
  local jdn = ticks / seconds_per_day
  jdn_int = math.floor( jdn )
  local jdn_midnight
  if jdn - jdn_int >= 0.5 then
    jdn_midnight = jdn_int + 0.5
  else
    jdn_midnight = jdn_int - 0.5
  end
  local second = ticks - jdn_midnight*seconds_per_day
  -- compute the time since midnight
  local hour = math.floor( second / seconds_per_hour )
  second = second - hour*seconds_per_hour
  local minute = math.floor( second / seconds_per_minute )
  second = second - minute*seconds_per_minute
  -- compute the date
  local day, month, year = Public.daynumber2date( jdn_midnight )
  -- set the values for the DateTime object
  data.second = second
  data.minute = minute
  data.hour = hour
  data.day = day
  data.month = month
  data.year = year
  data.weekday = Private.weekday[ math.fmod( jdn_midnight+1, 7 )+0.5 ]
end


----------------------------------------------------------------------
-- the constructors


-- normal constructor
function Public:new( year, month, day, hour, minute, second )
  -- parameters
  year = tonumber( year ) or 1970
  month = tonumber( month ) or 1
  day = tonumber( day ) or 1
  hour = tonumber( hour ) or 0
  minute = tonumber( minute ) or 0
  second = tonumber( second ) or 0
  -- calculate seconds
  local sex = Public.date2daynumber( day, month, year ) * seconds_per_day
  sex = sex + hour*seconds_per_hour + minute*seconds_per_minute + second
  local obj = {}
  local data = {
    ticks = sex,
  }
  -- compute the missing fields in data table
  Private.update( data )
  local meta = {
    -- metamethods
    __index = data, -- just return the data (or methods...)
    __newindex = Meta.__newindex,
    __tostring = Meta.__tostring,
    __sub = Meta.__sub,
    __le = Meta.__le,
    __lt = Meta.__lt,
    __eq = Meta.__eq
  }
  setmetatable( obj, meta )
  return obj
end



-- parses a given date string and creates a DateTime object
function Public:parse( datestr )
  local year, month, day, hour, minute, second, i, j, _
  local datepattern = "^(%d+)[%.%-_](%d+)[%.%-_](%-?%d+)"
  local timepattern = "^(%d+):(%d+):(%d+)"
  -- parse date
  i, j, day, month, year = string.find( datestr, datepattern )
  if not i then -- no date found, assume today
    _, _, day, month, year = string.find(
      date( "%d.%m.%Y" ),
      datepattern
    )
    j = 1
  else
    j = j + 2 -- skip delimiter
  end
  -- parse time
  _, _, hour, minute, second = string.find( datestr, timepattern, j )
  if not hour then
    second = 0
    _, _, hour, minute = string.find( datestr, "^(%d+):(%d+)$", j )
  end
  return Public.new( self, year, month, day, hour, minute, second )
end



-- makes a DateTime object from the current date and time



----------------------------------------------------------------------
-- some member functions


-- return a string representation
function Meta.__tostring( self )
  local data = getmetatable( self ).__index
  return string.format( "%02d.%02d.%04d/%02d:%02d:%02d",
                        data.day, data.month, data.year,
                        data.hour, data.minute, data.second )
end

-- compute the time difference in seconds...
function Meta.__sub( a, b )
  if type( a ) == "table" and type( a.ticks ) == "number" and
     type( b ) == "table" and type( b.ticks ) == "number" then
    return a.ticks - b.ticks
  else
    error( "can only subtract Date objects" )
  end
end

-- compare two Date/Time objects
function Meta.__le( a, b )
  if type( a ) == "table" and type( a.ticks ) == "number" and
     type( b ) == "table" and type( b.ticks ) == "number" then
    return a.ticks <= b.ticks
  else
    error( "can only compare two Date objects" )
  end
end

-- compare two Date/Time objects
function Meta.__lt( a, b )
  if type( a ) == "table" and type( a.ticks ) == "number" and
     type( b ) == "table" and type( b.ticks ) == "number" then
    return a.ticks < b.ticks
  else
    error( "can only compare two Date objects" )
  end
end

-- compare two Date/Time objects
function Meta.__eq( a, b )
  if type( a ) == "table" and type( a.ticks ) == "number" and
     type( b ) == "table" and type( b.ticks ) == "number" then
    return a.ticks == b.ticks
  else
    error( "can only compare two Date objects" )
  end
end

-- set a field, but update the ticks counter and all fields
function Meta.__newindex( self, key, value )
  local data = getmetatable( self ).__index
  if key == "ticks" then
    data.ticks = value
  elseif key == "second" then
    data.ticks = data.ticks + ( value - data.second )
  elseif key == "minute" then
    data.ticks = data.ticks + ( value - data.minute )*seconds_per_minute
  elseif key == "hour" then
    data.ticks = data.ticks + ( value - data.hour )*seconds_per_hour
  elseif key == "day" then
    data.ticks = data.ticks + ( value - data.day )*seconds_per_day
  elseif key == "month" then

    local hour, minute, second = data.hour, data.minute, data.second
    local day, month, year = data.day, value, data.year
    local addyears = math.floor( month / 12 )
    month = month - addyears*12
    year = year + addyears
    if month == 0 then
      year = year - 1
      month = 12
    end
    local sex = Public.date2daynumber( day, month, year ) * seconds_per_day
    sex = sex + hour*seconds_per_hour + minute*seconds_per_minute + second
    data.ticks = sex

  elseif key == "year" then

    local day, month, year = data.day, data.month, value
    local hour, minute, second = data.hour, data.minute, data.second
    local sex = Public.date2daynumber( day, month, year ) * seconds_per_day
    sex = sex + hour*seconds_per_hour + minute*seconds_per_minute + second
    data.ticks = sex

  elseif key == "weekday" then
    error( "cannot set weekday for Date object" )
  else
    rawset( self, key, value )
    return
  end
  Private.update( data )
end




----------------------------------------------------------------------
-- a helper function for the math library
function mtrunc( number )
  if number < 0 then
    return -math.floor( -number )
  else
    return math.floor( number )
  end
end

----------------------------------------------------------------------
-- The code above was made by another coder.


local checkTimer             = nil
local GarrisonScrollContent  = nil
local characterScrollContent = nil
local followersOnMission     = {}
local TimerHeaders           = {}
local CharactersTimers       = {}
local CharacterHeaders       = {}

local GBRealmList = {}
local garrisonBuildingScrollChild = nil
local GBSelectedNameRealm = ""
local GBBuildingUI = {}
local GBFollowerUI = {}
local GBCharacterProperties = nil
local realmOptionsPanel = nil

local realmCharaList = nil

local GBBuildingUI = {}
local GBFollowerUI = {}

local GBTimerFrame = nil

local GBTimerScrollChild = nil

local GBTimerScrollElements = {}

local MGSelecedTimerIndex = -1;

local MGSelectedTimerType = -1;
local MGSelectedTimerChar = "";
local GBIndex = -1;
-- ================================================================================================================
function MyGarrisons:SetUpGBTimerFrame()

	--Initialize the frame.
	GBTimerFrame = CreateFrame("Frame", "GBCharaTimers", GarrisonBuildings.garrisonBuildingScrollChild,"MGCharacterTimersFrame")

	GBTimerFrame:SetPoint("TOPLEFT", GarrisonBuildings.garrisonBuildingScrollChild,10,-60 )
	GBTimerFrame:Hide()
	--Initialize the scroll child.
	
	GBTimerScrollChild = CreateFrame("Frame", "GBTimerScrollChild", GBTimerFrame.timescroll)
	GBTimerScrollChild:SetSize(128, 28)
	GBTimerScrollChild:SetPoint("TOPLEFT", GBTimerFrame.timescroll,10,-6 )
	GBTimerScrollChild:Show()
		
	GBTimerFrame.timescroll.GBTimerScrollChild = GBTimerScrollChild
 
	GBTimerFrame.timescroll:SetScrollChild(GBTimerScrollChild)


end
function MyGarrisons:UpdateGBTimers()

--GBSelectedNameRealm
	for k = 1, #GBTimerScrollElements do
		if GBTimerScrollElements[k].Used ~= false then
			if GBTimerScrollElements[k].TimerType == "Mission" then
				--GBTimerScrollElements[k].Frame.timername
				GBTimerScrollElements[k].Frame.timername:SetText(C_Garrison.GetMissionName(GBTimerScrollElements[k].TimerIndex))
			end
			
			if GBTimerScrollElements[k].TimerType == "Building" then
			GBTimerScrollElements[k].Frame.timername:SetText(MyGarrisons.db.global.Garrisons[GBSelectedNameRealm].Constructions[GBTimerScrollElements[k].TimerIndex].BuildingName)
			end
		end

	end
end
function MyGarrisons:FillGBForCharacter()
	MyGarrisons:ClearGBTimers()

--GBSelectedNameRealm
--MyGarrisons:AddGBTimerElement(charRealmName, timerType, timerIndex)

		for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[GBSelectedNameRealm].Missions) do
			MyGarrisons:AddGBTimerElement(GBSelectedNameRealm, "Mission", k2)
			
		end
		for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[GBSelectedNameRealm].Constructions) do
			MyGarrisons:AddGBTimerElement(GBSelectedNameRealm, "Building", k2)
			
		end
		for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[GBSelectedNameRealm].Constructions) do
			MyGarrisons:AddGBTimerElement(GBSelectedNameRealm, "Shipment", k2)
			
		end
		MyGarrisons:UpdateGBTimers()
end

--
-- Frame
-- Used
-- Character Name and Realm
-- Timer Type
-- Timer Index
--
function MyGarrisons:AddGBTimerElement(charRealmName, timerType, timerIndex)
	--GBTimerScrollChild
	local found = false
	local firstUnused = 0
	for k = 1, #GBTimerScrollElements do
		if found == false then
			if GBTimerScrollElements[k].Used == false then
				found = true
				firstUnused = k
			end
		end
	end
	if firstUnused == 0 then
		local newIndex = #GBTimerScrollElements+1
		firstUnused = newIndex
		GBTimerScrollElements[newIndex] = {Used = true, Name = charRealmName, TimerType = timerType, TimerIndex = timerIndex,
											Frame = CreateFrame("Frame", "GBTimer"..newIndex,GBTimerScrollChild,"MGTimerElement")
		
		
		}
		if newIndex == 1 then
		
			GBTimerScrollElements[newIndex].Frame:SetPoint("TOPLEFT",GBTimerScrollChild,"TOPLEFT" )

		else
			GBTimerScrollElements[newIndex].Frame:SetPoint("TOPLEFT",GBTimerScrollElements[newIndex-1].Frame,"BOTTOMLEFT" )
		end
	
	
	end

GBTimerScrollElements[firstUnused].Used = true
GBTimerScrollElements[firstUnused].Name = charRealmName
GBTimerScrollElements[firstUnused].TimerType = timerType
GBTimerScrollElements[firstUnused].TimerIndex = timerIndex	
GBTimerScrollElements[firstUnused].Frame:Show()

GBTimerScrollElements[firstUnused].Frame.deleter:SetScript("OnClick" , function()

	MGSelecedTimerIndex =  GBTimerScrollElements[firstUnused].TimerIndex;

	MGSelectedTimerType = GBTimerScrollElements[firstUnused].TimerType;
	MGSelectedTimerChar = charRealmName;
	GBIndex = firstUnused
	MyGarrisonsConfirmFrame.ConfirmQuestion:SetText("Are you sure you want to remove the timer for "..GBTimerScrollElements[firstUnused].Frame.timername:GetText().."?")
	MyGarrisonsConfirmFrame:Show()
	
 end)
end
function MyGarrisons:RemoveTimer()
	MyGarrisons:UnuseCharacterTimer(MGSelectedTimerChar, MGSelectedTimerType, MGSelecedTimerIndex)
	MyGarrisons:UnuseGBTimerElement(GBIndex) 

	if MGSelectedTimerType == "Mission" then
		MyGarrisons.db.global.Garrisons[MGSelectedTimerChar].Missions[MGSelecedTimerIndex] = nil
	end
	MGSelecedTimerIndex =  -1;

	MGSelectedTimerType = -1;
	MGSelectedTimerChar = "";
	GBIndex = -1
	MyGarrisonsConfirmFrame:Hide()
	--TODO Remove from database.
end
function MyGarrisons:SwitchGBTimerElements(index1, index2)

	--Switch Fields.
	local temp1Name = GBTimerScrollElements[index1].Name
	local temp1Type = GBTimerScrollElements[index1].TimerType
	local temp1Index = GBTimerScrollElements[index1].TimerIndex
	local temp1Used = GBTimerScrollElements[index1].Used
	
	local temp2Name = GBTimerScrollElements[index2].Name
	local temp2Type = GBTimerScrollElements[index2].TimerType
	local temp2Index = GBTimerScrollElements[index2].TimerIndex	
	local temp2Used = GBTimerScrollElements[index2].Used
	
	
	GBTimerScrollElements[index2].Name 			= temp1Name
	GBTimerScrollElements[index2].TimerType 	= temp1Type
	GBTimerScrollElements[index2].TimerIndex 	= temp1Index
	GBTimerScrollElements[index2].Used 			= temp1Used
	
	
	GBTimerScrollElements[index1].Name 			= temp2Name
	GBTimerScrollElements[index1].TimerType 	= temp2Type
	GBTimerScrollElements[index1].TimerIndex 	= temp2Index
	GBTimerScrollElements[index1].Used 			= temp2Used
	
	--Switch Frame Data
	
	
	
end
function MyGarrisons:UnuseGBTimerElement(index)

	local lastIndex = index
	for k = index+1, #GBTimerScrollElements do
		if GBTimerScrollElements[k].Used == true then
			MyGarrisons:SwitchGBTimerElements(k-1, k)
			lastIndex = k
		end
	end

	GBTimerScrollElements[lastIndex].Used = false
	GBTimerScrollElements[lastIndex].Frame:Hide()
	GBTimerScrollElements[lastIndex].TimerType = "Empty"
	GBTimerScrollElements[lastIndex].TimerIndex 	= 0

end
function MyGarrisons:ClearGBTimers()
	for k = 1, #GBTimerScrollElements do
		GBTimerScrollElements[k].Frame:Hide()
		GBTimerScrollElements[k].Used = false
		GBTimerScrollElements[k].TimerType = "Empty"
		GBTimerScrollElements[k].TimerIndex 	= 0
	end

end
-- =========================
function MyGarrisons:SetUpCharacterProperties()

--CharacterProperties

	GBCharacterProperties = CreateFrame("Frame", "GBCharaProp", GarrisonBuildings.garrisonBuildingScrollChild,"CharacterProperties")
--	GBCharacterProperties:SetSize(278,250)
	GBCharacterProperties:SetPoint("TOPLEFT", GarrisonBuildings.garrisonBuildingScrollChild,10,-60 )
	GBCharacterProperties:Show()
	GBCharacterProperties:Hide()
	GBCharacterProperties.deletechar:SetScript("OnClick", function ()  
	
	--TODO character Delete
	local splitted = {}
splitted = 	{MyGarrisons:splitAtFirst(GBSelectedNameRealm, "-")}
	local realmIndex = 0

	
	for k,v in pairs(GBRealmList) do
		if GBRealmList[k].RealmName == splitted[2] then
			realmIndex = k
		end
	end
	
	local foundIndex = 0;
	
	for k,v in pairs(GBRealmList[realmIndex].Characters) do
		if GBRealmList[realmIndex].Characters[k].Name == splitted[1] then
		foundIndex = k
		end
	
	end
	GBRealmList[realmIndex].Characters[foundIndex].CharProp:Hide()
	MyGarrisons:DeleteCharacterInRealmList(realmIndex, foundIndex)
	local timersIndex = 0;
	
	for k,v in pairs (CharacterHeaders) do
		if CharacterHeaders[k].Name == GBSelectedNameRealm then
		timersIndex = k
		end
	end
	MyGarrisons:UnuseCharacterHeader(timersIndex)
	MyGarrisons.db.global.Garrisons[GBSelectedNameRealm] = nil
	end)

end
function MyGarrisons:FillCharacterPropertiesForSelected()
	GBCharacterProperties.charaname:SetText(GBSelectedNameRealm);
--GBSelectedNameRealm 

end
function MyGarrisons:BuildRealmOptionPanel()


	realmOptionsPanel = CreateFrame("Frame", "re",GarrisonBuildings.garrisonBuildingScrollChild, "RealmOptionsFrame" )
	realmOptionsPanel:SetPoint("TOPLEFT", GarrisonBuildings.garrisonBuildingScrollChild,10,-60 )
	realmCharaList = CreateFrame("Frame", "realmCharaList", realmOptionsPanel.scroll)
	realmCharaList:SetSize(128, 28)
	realmCharaList:SetPoint("TOPLEFT", realmOptionsPanel.scroll,10,-6 )
	realmCharaList:Show()
		
	realmOptionsPanel.scroll.realmCharaList = realmCharaList
 
	realmOptionsPanel.scroll:SetScrollChild(realmCharaList)
	
	--realmOptionsPanel.scroll
	realmOptionsPanel:Hide();

end
function MyGarrisons:SetUpRealmOptions(realm)

	realmOptionsPanel:Show()

end
function MyGarrisons:FillFollowersEmpty()

	for k = 1, 25 do
		GBFollowerUI[k] = {Texture = nil, FollowerID = 0, 
		Frame =CreateFrame("Frame", "Follower"..k,garrisonBuildingScrollChild,"FollowerFrame"), Used = false}
		if k == 1 then
		
			GBFollowerUI[k].Frame:SetPoint("TOPLEFT",garrisonBuildingScrollChild,"TOPLEFT" )

		else
			GBFollowerUI[k].Frame:SetPoint("TOPLEFT",GBFollowerUI[k-1].Frame,"BOTTOMLEFT" )
		end
		GBFollowerUI[k].Frame:Hide()
	end

end
function MyGarrisons:AddFollowerTOUI(charname, followerIndex)
	local firstUnusedFrame = 0;
	local unusedFound = false;
	if #GBFollowerUI == 0 then
		--firstUnusedFrame = 1
		GBFollowerUI[1] = {Texture = nil, FollowerID = 0, 
		Frame =CreateFrame("Frame", "Follower"..k,garrisonBuildingScrollChild,"FollowerFrame"), Used = false}
		GBFollowerUI[1].Frame:SetPoint("TOPLEFT",garrisonBuildingScrollChild,"TOPLEFT" )
	end
	
	for k,v in pairs(GBFollowerUI) do
		if GBFollowerUI[k].Used == false and unusedFound == false then
			unusedFound = true;
			firstUnusedFrame = k
		end
	end
	if unusedFound == false then
		firstUnusedFrame = #GBFollowerUI + 1
		GBFollowerUI[firstUnusedFrame] = {Texture = nil, FollowerID = 0, 
		Frame =CreateFrame("Frame", "Follower"..k,garrisonBuildingScrollChild,"FollowerFrame"), Used = false}
		GBFollowerUI[firstUnusedFrame].Frame:SetPoint("TOPLEFT",GBFollowerUI[firstUnusedFrame-1].Frame,"BOTTOMLEFT" )
	end
	
	
	
	
	
	
	-------------------------------------------------------
	
	--MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex]
		GBFollowerUI[firstUnusedFrame].Frame:Show()
		GBFollowerUI[firstUnusedFrame].Frame.followername:SetText(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Name)
GBFollowerUI[firstUnusedFrame].FollowerID =followerIndex
		GBFollowerUI[firstUnusedFrame].Frame.followerclass:SetText("Class: "..MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Class)
		SetPortraitTexture(GBFollowerUI[firstUnusedFrame].Frame.followerportrait.Portrait,MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].DisplayID)
		local color = ITEM_QUALITY_COLORS[MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Quality]
		
		GBFollowerUI[firstUnusedFrame].Used = true;
		GBFollowerUI[firstUnusedFrame].Frame.followerportrait.PortraitRingQuality:SetVertexColor(color.r, color.g, color.b);
        GBFollowerUI[firstUnusedFrame].Frame.followerportrait.Level:SetText(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Level);
    
		GBFollowerUI[firstUnusedFrame].Frame.followerportrait.LevelBorder:SetVertexColor(color.r, color.g, color.b);
		
		local counter = 0;
		if C_Garrison.GetFollowerModelItems(followerIndex) ~= nil then
		for v,h in pairs (C_Garrison.GetFollowerModelItems(followerIndex)) do
	
			local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = GetItemInfo(h);
			if counter == 1 then
				GBFollowerUI[firstUnusedFrame].Frame.gear2.text:SetTexture(itemTexture)
				counter = 0
			end
			if counter == 0 then
				GBFollowerUI[firstUnusedFrame].Frame.gear1.text:SetTexture(itemTexture)
				counter = 1;
			end
			
		end
		end
		GBFollowerUI[firstUnusedFrame].Frame.expbar:SetMinMaxValues(1, MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].LevelXP)
		GBFollowerUI[firstUnusedFrame].Frame.expbar:SetValue(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].XP)
		GBFollowerUI[firstUnusedFrame].Frame.expbar.expstr:SetText(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].XP.."/"..MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].LevelXP);
		
		GBFollowerUI[firstUnusedFrame].Frame.expbar:Show()
		GBFollowerUI[firstUnusedFrame].Frame.ability1.text:SetTexture(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[1].Icon)
		GBFollowerUI[firstUnusedFrame].Frame.ability1:SetScript("OnEnter", function() 
				GarrisonFollowerAbilityTooltip:ClearAllPoints();
				GarrisonFollowerAbilityTooltip:SetPoint("TOPLEFT", GBFollowerUI[firstUnusedFrame].Frame.ability1, "BOTTOMRIGHT");
		
				GarrisonFollowerAbilityTooltip_Show(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[1].ID) 
				end)
		GBFollowerUI[firstUnusedFrame].Frame.ability1:SetScript("OnLeave", function() GarrisonFollowerAbilityTooltip:Hide(); end)
		if MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[2] ~= nil then
		GBFollowerUI[firstUnusedFrame].Frame.ability2.text:SetTexture(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[2].Icon)
		
		GBFollowerUI[firstUnusedFrame].Frame.ability2:SetScript("OnEnter", function() GarrisonFollowerAbilityTooltip:ClearAllPoints();
				GarrisonFollowerAbilityTooltip:SetPoint("TOPLEFT", GBFollowerUI[firstUnusedFrame].Frame.ability2, "BOTTOMRIGHT");
		
				GarrisonFollowerAbilityTooltip_Show(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[2].ID) 
		
		
		end)
		GBFollowerUI[firstUnusedFrame].Frame.ability2:SetScript("OnLeave", function() GarrisonFollowerAbilityTooltip:Hide(); end)
		end
		if MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[3] ~= nil then
			GBFollowerUI[firstUnusedFrame].Frame.ability3.text:SetTexture(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[3].Icon)
			GBFollowerUI[firstUnusedFrame].Frame.ability3:SetScript("OnEnter", function() 
													GarrisonFollowerAbilityTooltip:ClearAllPoints();
													GarrisonFollowerAbilityTooltip:SetPoint("TOPLEFT", GBFollowerUI[firstUnusedFrame].Frame.ability3, "BOTTOMRIGHT");
													GarrisonFollowerAbilityTooltip_Show(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[3].ID) 


													end)
			GBFollowerUI[firstUnusedFrame].Frame.ability3:SetScript("OnLeave", function() GarrisonFollowerAbilityTooltip:Hide(); end)
		end
		if MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[4]~= nil then
			GBFollowerUI[firstUnusedFrame].Frame.ability4.text:SetTexture(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[4].Icon)
			GBFollowerUI[firstUnusedFrame].Frame.ability4:SetScript("OnEnter", function() 
				GarrisonFollowerAbilityTooltip:ClearAllPoints();
				GarrisonFollowerAbilityTooltip:SetPoint("TOPLEFT", GBFollowerUI[firstUnusedFrame].Frame.ability4, "BOTTOMRIGHT");
		
				GarrisonFollowerAbilityTooltip_Show(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Abilities[4].ID) 

			end)
			GBFollowerUI[firstUnusedFrame].Frame.ability4:SetScript("OnLeave", function() GarrisonFollowerAbilityTooltip:Hide(); end)
		end
		
		-------------------------------------------------
		
		if MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[1] ~= nil then
			GBFollowerUI[firstUnusedFrame].Frame.trait1.text:SetTexture(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[1].Icon)
			GBFollowerUI[firstUnusedFrame].Frame.trait1:SetScript("OnEnter", function()  
		
				GarrisonFollowerAbilityTooltip:ClearAllPoints();
				GarrisonFollowerAbilityTooltip:SetPoint("TOPLEFT", GBFollowerUI[firstUnusedFrame].Frame.trait1, "BOTTOMRIGHT");
		
				GarrisonFollowerAbilityTooltip_Show(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[1].ID) 
			end)
			GBFollowerUI[firstUnusedFrame].Frame.trait1:SetScript("OnLeave", function() GarrisonFollowerAbilityTooltip:Hide(); end)
		end
		if MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[2] ~= nil then
			GBFollowerUI[firstUnusedFrame].Frame.trait2.text:SetTexture(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[2].Icon)
			GBFollowerUI[firstUnusedFrame].Frame.trait2:SetScript("OnEnter", function() 
				GarrisonFollowerAbilityTooltip:ClearAllPoints();
				GarrisonFollowerAbilityTooltip:SetPoint("TOPLEFT", GBFollowerUI[firstUnusedFrame].Frame.trait2, "BOTTOMRIGHT");
		
				GarrisonFollowerAbilityTooltip_Show(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[2].ID)
				
		-- print(C_Garrison.GetFollowerModelItems(k));
		
			end)
			GBFollowerUI[firstUnusedFrame].Frame.trait2:SetScript("OnLeave", function() GarrisonFollowerAbilityTooltip:Hide(); end)
		end
		if MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[3] ~= nil then
			GBFollowerUI[firstUnusedFrame].Frame.trait3.text:SetTexture(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[3].Icon)
			GBFollowerUI[firstUnusedFrame].Frame.trait3:SetScript("OnEnter", function() 

			GarrisonFollowerAbilityTooltip:ClearAllPoints();
				GarrisonFollowerAbilityTooltip:SetPoint("TOPLEFT", GBFollowerUI[firstUnusedFrame].Frame.trait3, "BOTTOMRIGHT");
		
				GarrisonFollowerAbilityTooltip_Show(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[3].ID) 
		end)
		GBFollowerUI[firstUnusedFrame].Frame.trait3:SetScript("OnLeave", function() GarrisonFollowerAbilityTooltip:Hide(); end)
		end
		if MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[4] ~= nil then
			GBFollowerUI[firstUnusedFrame].Frame.trait4.text:SetTexture(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[4].Icon)
			GBFollowerUI[firstUnusedFrame].Frame.trait4:SetScript("OnLeave", function() GarrisonFollowerAbilityTooltip:Hide(); end)
			GBFollowerUI[firstUnusedFrame].Frame.trait4:SetScript("OnEnter", function()
				GarrisonFollowerAbilityTooltip:ClearAllPoints();
				GarrisonFollowerAbilityTooltip:SetPoint("TOPLEFT", GBFollowerUI[firstUnusedFrame].Frame.trait4, "BOTTOMRIGHT");
				GarrisonFollowerAbilityTooltip_Show(MyGarrisons.db.global.Garrisons[charname].Followers[followerIndex].Traits[4].ID) 
			end)
		end
		
		--Portrait
		--GBFollowerUI[firstUnusedFrame].Frame.followerportrait.PortraitRingQuality:SetVertexColor(color.r, color.g, color.b);
		--GBFollowerUI[firstUnusedFrame].Frame.followerportrait

	
end
function MyGarrisons:HideAllFollowers()
	for k,v in pairs (GBFollowerUI) do
		GBFollowerUI[k].Used = false
		GBFollowerUI[k].ID = 0
		GBFollowerUI[k].Frame:Hide()
	end
end
local currentSelectedLogFrame = 0;
local currentSelectedCharacter = "";
function MyGarrisons:ClearFollowers()
	for k,v in pairs(GBFollowerUI) do
		GBFollowerUI[k].Used = false
		GBFollowerUI[k].Frame:Hide()
	end


end
function MyGarrisons:SetUpFollowersForChar(charname)
	local currentFrame = 1
	currentSelectedLogFrame = 2;
	currentSelectedCharacter = charname
	for k,v in pairs (MyGarrisons.db.global.Garrisons[charname].Followers) do
	
		MyGarrisons:AddFollowerTOUI(charname, k)
	
	
		
	end
end

--function MyGarrisons
function MyGarrisons:FillGarrisonBuildings()
--GarrisonBuildings.charScroll.characterScrollContent
--GarrisonBuildings.charScroll.characterScrollContent
	local realmList = {}
	local charPerRealm = {}
	--MyGarrisons.db.global.Garrisons[name.."-"..realm]
	for k,v in pairs (MyGarrisons.db.global.Garrisons) do
		--MyGarrisons:splitAtFirst(str, pattern)
		local parts = {MyGarrisons:splitAtFirst(k, "-")}
	
		if realmList[parts[2]] == nil then
			charPerRealm[parts[2]] = 1
			realmList[parts[2]] = 1
		else
		charPerRealm[parts[2]] = charPerRealm[parts[2]] +1
		end
		
		
	end
	for k,v in pairs (realmList) do
		GBRealmList[#GBRealmList+1] = {RealmName = k, Expanded = false, 
		Frame = CreateFrame("Frame", "RealmListHeader"..(#GBRealmList+1),GarrisonBuildings.charScroll.characterScrollContent,"RealmListHeader"),
		CharBag = CreateFrame("Frame", "RealmBag"..(#GBRealmList+1),GarrisonBuildings.charScroll.characterScrollContent,"RealmBag"),
		Characters = {}

		}
		if #GBRealmList == 1 then
			GBRealmList[#GBRealmList].Frame:SetPoint("TOPLEFT",GarrisonBuildings.charScroll.characterScrollContent,"TOPLEFT" )

		else
			GBRealmList[#GBRealmList].Frame:SetPoint("TOPLEFT",GBRealmList[#GBRealmList-1].CharBag,"BOTTOMLEFT" )
		end
		local temprealm = k
		GBRealmList[#GBRealmList].CharBag:SetPoint("TOPLEFT",GBRealmList[#GBRealmList].Frame,"BOTTOMLEFT" )
		GBRealmList[#GBRealmList].Frame.realmProp:SetScript("OnClick", function ()
		GBTimerFrame:Hide()
		MyGarrisons:HideAllFollowers() MyGarrisons:HideAllBuildings()  MyGarrisons:SetUpRealmOptions(temprealm) end)
		local ind = #GBRealmList
			
		for k2 = 1,charPerRealm[k] do
		local tempK = k2

			GBRealmList[#GBRealmList].Characters[k2] = {Used = false, Name = "", Expanded = false,
			Frame = CreateFrame("Frame", "CharacterListTemplate"..(#GBRealmList)..k2,GBRealmList[#GBRealmList].CharBag,"CharacterListTemplate"),
			CharProp = CreateFrame("Frame", "CharacterProp"..(#GBRealmList)..k2,GBRealmList[#GBRealmList].CharBag,"CharacterProp")
			
			}
			GBRealmList[#GBRealmList].Characters[k2].CharProp:SetPoint("TOPLEFT",GBRealmList[#GBRealmList].Characters[k2].Frame,"BOTTOMLEFT")
			GBRealmList[#GBRealmList].Characters[k2].CharProp:Hide()
			GBRealmList[#GBRealmList].Characters[k2].CharProp:SetHeight(1)
			
			--MyGarrisons:SetBuildingListForCharacter(charname)
			--MyGarrisons:HideAllBuildings()
--GBRealmList[#GBRealmList].Characters[k2].CharProp.follow:SetScript("OnClick",  function() realmOptionsPanel:Hide() MyGarrisons:HideAllFollowers() ()MyGarrisons:HideAllBuildings()  end)
			
			--MyGarrisons:SetUpFollowersForChar(charname)
			
			GBRealmList[#GBRealmList].Characters[k2].CharProp.follow:SetScript("OnClick", function ()
GBTimerFrame:Hide()
	GBCharacterProperties:Hide()
			realmOptionsPanel:Hide() MyGarrisons:HideAllFollowers() MyGarrisons:HideAllBuildings()MyGarrisons:SetUpFollowersForChar(GBRealmList[ind].Characters[k2].Name.."-"..GBRealmList[ind].RealmName) end)
			GBRealmList[#GBRealmList].Characters[k2].CharProp.buildings:SetScript("OnClick", function () 
GBTimerFrame:Hide()
	GBCharacterProperties:Hide()
MyGarrisons:HideAllFollowers()
MyGarrisons:SetBuildingListForCharacter(GBRealmList[ind].Characters[k2].Name.."-"..GBRealmList[ind].RealmName)
			end)
			GBRealmList[#GBRealmList].Characters[k2].CharProp.timersbut:SetScript("OnClick", function () 
--TODO
			GBSelectedNameRealm = GBRealmList[ind].Characters[k2].Name.."-"..GBRealmList[ind].RealmName
			GBTimerFrame:Show()
			GBCharacterProperties:Hide()
			MyGarrisons:HideAllFollowers()
			MyGarrisons:HideAllBuildings()
			MyGarrisons:FillGBForCharacter()
			end)
			--MyGarrisons:DeleteCharacterInRealmList(realmIndex, cindex)
			
		--	GBCharacterProperties:Show()
	--GBCharacterProperties:Hide()
	
			GBRealmList[#GBRealmList].Characters[k2].Frame.charbut:SetScript("OnClick",function ()
			GBTimerFrame:Hide()
					if GBRealmList[ind].Characters[tempK].Expanded == false  then
			realmOptionsPanel:Hide() MyGarrisons:HideAllFollowers() MyGarrisons:HideAllBuildings()

			GBSelectedNameRealm = GBRealmList[ind].Characters[k2].Name.."-"..GBRealmList[ind].RealmName
			
			GBCharacterProperties:Show()
			MyGarrisons:FillCharacterPropertiesForSelected()
						GBRealmList[ind].Characters[tempK].CharProp:Show()
						GBRealmList[ind].Characters[tempK].Expanded = true
						GBRealmList[ind].Characters[tempK].CharProp:SetHeight(74)
						MyGarrisons:ExpandCollapseRealm(ind, true)
		
			
					else
								realmOptionsPanel:Hide() MyGarrisons:HideAllFollowers() MyGarrisons:HideAllBuildings()

			GBSelectedNameRealm = GBRealmList[ind].Characters[k2].Name.."-"..GBRealmList[ind].RealmName
			GBCharacterProperties:Show()
			MyGarrisons:FillCharacterPropertiesForSelected()
						GBRealmList[ind].Characters[tempK].CharProp:Hide()
						GBRealmList[ind].Characters[tempK].Expanded = false
						MyGarrisons:ExpandCollapseRealm(ind, true)
						GBRealmList[ind].Characters[tempK].CharProp:SetHeight(1)
					end
			
			
		



			end)
			--CharacterProp
			if k2 == 1 then
				GBRealmList[#GBRealmList].Characters[k2].Frame:SetPoint("TOPLEFT",GBRealmList[#GBRealmList].CharBag,"TOPLEFT" )
				
			else
				GBRealmList[#GBRealmList].Characters[k2].Frame:SetPoint("TOPLEFT",GBRealmList[#GBRealmList].Characters[tempK-1].CharProp,"BOTTOMLEFT" )
			end
			
			--GBRealmList[#GBRealmList].Characters[k2].Frame.charbut.charname:SetText("")
		--	if #CharacterHeaders == 1 then
	--	CharacterHeaders[#CharacterHeaders].Frame:SetPoint("TOPLEFT",MyGarrisonTimers.timerscroll.GarrisonScrollContent,"TOPLEFT" )
--if index == 1 then
--			CharacterHeaders[charactersH].Timers[index].Frame:SetPoint("TOPLEFT",CharacterHeaders[charactersH].TimerBag,"TOPLEFT")
	--	else
	--		CharacterHeaders[charactersH].Timers[index].Frame:SetPoint("TOPLEFT",CharacterHeaders[charactersH].Timers[index-1].Frame,"BOTTOMLEFT")
	--else
	--	CharacterHeaders[#CharacterHeaders].Frame:SetPoint("TOPLEFT",CharacterHeaders[#CharacterHeaders-1].TimerBag,"BOTTOMLEFT" )
			
		end
		
		GBRealmList[#GBRealmList].Frame.realmname:SetText(k)
		
		GBRealmList[#GBRealmList].CharBag:Hide();
		GBRealmList[#GBRealmList].CharBag:SetHeight(1);
			
		GBRealmList[#GBRealmList].Frame.expander:SetScript("OnClick",function () 
		if GBRealmList[ind].Expanded then
		MyGarrisons:ExpandCollapseRealm(ind,false)
		for ktemp, vd in pairs (GBRealmList[ind].Characters) do
			GBRealmList[ind].Characters[ktemp].CharProp:Hide()
		end
		else
		MyGarrisons:ExpandCollapseRealm(ind, true)
		for ktemp, vd in pairs (GBRealmList[ind].Characters) do
			if GBRealmList[ind].Characters[ktemp].Expanded then
			GBRealmList[ind].Characters[ktemp].CharProp:Show()
			end
		end
		end

	--SetNormalTexture
	if GBRealmList[ind].Expanded then
		GBRealmList[ind].Frame.expander:SetNormalTexture("Interface\\BUTTONS\\UI-MinusButton-Up")
		GBRealmList[ind].Frame.expander:SetPushedTexture("Interface\\BUTTONS\\UI-MinusButton-Down")
		GBRealmList[ind].Frame.expander:GetHighlightTexture("Interface\\BUTTONS\\UI-MinusButton-Hilight")
	else
		GBRealmList[ind].Frame.expander:SetNormalTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
		GBRealmList[ind].Frame.expander:SetPushedTexture("Interface\\BUTTONS\\UI-PlusButton-Down")
		GBRealmList[ind].Frame.expander:GetHighlightTexture("Interface\\BUTTONS\\UI-PlusButton-Hilight")
		--Button:SetPushedTexture
		--Button:GetHighlightTexture
	end

	end)
		
		
	end
	--"RealmListHeader"
end
function MyGarrisons:AddCharacterToGBRealmList (charname)
	local parts = {MyGarrisons:splitAtFirst(charname, "-")}
	local realmKey = parts[2]
	local nam = parts[1]
	local rindex = 0
	
	for k,v in pairs (GBRealmList) do
		if GBRealmList[k].RealmName == realmKey then
			rindex = k
		end
	end
	local unusedIndex = 0
	local found = false
	for k, v in pairs (GBRealmList[rindex].Characters) do
		if found == false then
			if GBRealmList[rindex].Characters[k].Used == false then
				unusedIndex = k
				found = true
			end
		end
		
	--Characters
	end
	GBRealmList[rindex].Characters[unusedIndex].Used = true
	GBRealmList[rindex].Characters[unusedIndex].Name = nam
	GBRealmList[rindex].Characters[unusedIndex].Frame.charbut.charname:SetText(nam)
end
function MyGarrisons:CountUsedChars( index)
	local count = 0;
	for k,v in pairs (GBRealmList[index].Characters) do
		if GBRealmList[index].Characters[k].Used then
			count = count + 1
		end
	end
	return count
end
function MyGarrisons:CountExpandedCharactersInRealm(index)
	local count = 0;
	for k,v in pairs (GBRealmList[index].Characters) do
		if GBRealmList[index].Characters[k].Used and GBRealmList[index].Characters[k].Expanded then
			count = count + 1
		end
	end
	return count

end
function MyGarrisons:HideShowCharacters(index, shown)
	for k,v in pairs (GBRealmList[index].Characters) do
		if shown == true then
			if GBRealmList[index].Characters[k].Used then
				GBRealmList[index].Characters[k].Frame:Show()
				
			end
		else
			if GBRealmList[index].Characters[k].Used then
				GBRealmList[index].Characters[k].Frame:Hide()
			end
		end
	end
	MyGarrisons:UpdateColors ()
end
function MyGarrisons:DeleteCharacterInRealmList(realmIndex, cindex)

	for index = cindex+1, MyGarrisons:TableSize(GBRealmList[realmIndex].Characters) do
		if GBRealmList[realmIndex].Characters[index].Used == false then
			GBRealmList[realmIndex].Characters[index-1].Used = false
			GBRealmList[realmIndex].Characters[index-1].Frame:Hide();

			return true
		else
		
			MyGarrisons:SwitchCharactersInRealm(realmIndex, index-1, index)
		end
	
	end
	GBRealmList[realmIndex].Characters[MyGarrisons:TableSize(GBRealmList[realmIndex].Characters)].Used = false
			GBRealmList[realmIndex].Characters[MyGarrisons:TableSize(GBRealmList[realmIndex].Characters)].Frame:Hide();

end
function MyGarrisons:SwitchCharactersInRealm(realmIndex, cIndex1, cIndex2)

	local tempName1 = GBRealmList[realmIndex].Characters[cIndex1].Name
	local tempName2 = GBRealmList[realmIndex].Characters[cIndex2].Name
	
	GBRealmList[realmIndex].Characters[cIndex1].Name = tempName2
	GBRealmList[realmIndex].Characters[cIndex1].Frame.charbut.charname:SetText(tempName2)
	
	GBRealmList[realmIndex].Characters[cIndex2].Name = tempName1
	GBRealmList[realmIndex].Characters[cIndex2].Frame.charbut.charname:SetText(tempName1)

end
function MyGarrisons:ExpandCollapseRealm(index, boo)
	if boo == false then
		GBRealmList[index].CharBag:SetHeight(1);
		GBRealmList[index].Expanded = false
		MyGarrisons:HideShowCharacters(index, false)
		GBRealmList[index].Expanded =boo
		--CharacterHeaders[index].TimerBag:Hide()

	else
	--74
		local bagHeight = ( 16)*MyGarrisons:CountUsedChars( index) + (74 * MyGarrisons:CountExpandedCharactersInRealm(index))
		if bagHeight ~= 0 then
			GBRealmList[index].CharBag:SetHeight(bagHeight);
			GBRealmList[index].Expanded = true
			MyGarrisons:HideShowCharacters(index, true)
			GBRealmList[index].CharBag:Show()
			GBRealmList[index].Expanded = boo
			
		end
		
	end
	MyGarrisons:UpdateColors ()
end
function MyGarrisons:AddCharacterHeader()
	CharacterHeaders[#CharacterHeaders+1] = {
	
											Frame    = CreateFrame("Frame", "CharacterHeaderTemplate"..(#CharacterHeaders+1),MyGarrisonTimers.timerscroll.GarrisonScrollContent,"CharacterHeaderTemplate"),
											TimerBag = CreateFrame("Frame", "TimerBag"..(#CharacterHeaders+1),MyGarrisonTimers.timerscroll.GarrisonScrollContent,"TimerBag"),
											Timers   = {},
											Name     = "",
											Used     = false,
											Expanded = false,
											Texture = nil
	}
	if #CharacterHeaders == 1 then
		CharacterHeaders[#CharacterHeaders].Frame:SetPoint("TOPLEFT",MyGarrisonTimers.timerscroll.GarrisonScrollContent,"TOPLEFT" )

	else
		CharacterHeaders[#CharacterHeaders].Frame:SetPoint("TOPLEFT",CharacterHeaders[#CharacterHeaders-1].TimerBag,"BOTTOMLEFT" )
	end
	CharacterHeaders[#CharacterHeaders].Texture = CharacterHeaders[#CharacterHeaders].Frame:CreateTexture("tes","BACKGROUND")
			CharacterHeaders[#CharacterHeaders].Texture:SetAllPoints()
			CharacterHeaders[#CharacterHeaders].Texture:SetAtlas("GarrMission_FollowerListButton");
	CharacterHeaders[#CharacterHeaders].TimerBag:SetPoint("TOPLEFT",CharacterHeaders[#CharacterHeaders].Frame,"BOTTOMLEFT" )
	CharacterHeaders[#CharacterHeaders].TimerBag:Hide();
	local ind = #CharacterHeaders
	CharacterHeaders[#CharacterHeaders].Frame.expander:SetScript("OnClick",function () MyGarrisons:ExpandCollapseTB(ind)

	--SetNormalTexture
	if CharacterHeaders[ind].Expanded then
		CharacterHeaders[ind].Frame.expander:SetNormalTexture("Interface\\BUTTONS\\UI-MinusButton-Up")
		CharacterHeaders[ind].Frame.expander:SetPushedTexture("Interface\\BUTTONS\\UI-MinusButton-Down")
		CharacterHeaders[ind].Frame.expander:GetHighlightTexture("Interface\\BUTTONS\\UI-MinusButton-Hilight")
	else
		CharacterHeaders[ind].Frame.expander:SetNormalTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
		CharacterHeaders[ind].Frame.expander:SetPushedTexture("Interface\\BUTTONS\\UI-PlusButton-Down")
		CharacterHeaders[ind].Frame.expander:GetHighlightTexture("Interface\\BUTTONS\\UI-PlusButton-Hilight")
		--Button:SetPushedTexture
		--Button:GetHighlightTexture
	end

	end)

	return #CharacterHeaders
end
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
function MyGarrisons:UseCharacterHeader(charname)
	local index = 0;
	local found = false;
	for k = 1, #CharacterHeaders do
		if CharacterHeaders[k].Used == false and found == false then
			index = k;
			found = true
		end
	end
	if index == 0 then
		index = MyGarrisons:AddCharacterHeader()
	end
	CharacterHeaders[index].Name = charname;
	CharacterHeaders[index].Used = true;
	CharacterHeaders[index].Frame:Show()
	CharacterHeaders[index].Frame.charname:SetText(charname)
	
	CharacterHeaders[index].Frame.classtexture:SetAtlas(classTextureNames[MyGarrisons.db.global.Garrisons[charname].Class])
end

function MyGarrisons:FillCharacters()
	local charNames = {}
	for k,v in pairs (MyGarrisons.db.global.Garrisons) do

		MyGarrisons:UseCharacterHeader(k)

		--MyGarrisons:AddCharacterTimer(charname, typeID, missID)
		for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[k].Missions) do
			MyGarrisons:AddCharacterTimer(k, "Mission", k2)
			
		end
		for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[k].Constructions) do
			MyGarrisons:AddCharacterTimer(k, "Building", k2)
			
		end
		if MyGarrisons.db.global.Garrisons[k].Shipments ~= nil then
		for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[k].Shipments) do
			MyGarrisons:AddCharacterTimer(k, "Shipment", k2)
			
		end
		end
		--TODO Fill Work Orders
	end
end

function MyGarrisons:UnuseCharacterHeader(index)
--checkTimer = MyGarrisons:ScheduleRepeatingTimer("TimerCheckFunc", 1 )
	MyGarrisons:CancelTimer(checkTimer)
	
	
	--TODO:  Uses the timers for this index.

	--TODO:  Reposition the active Character Headers
	local lastUsed = index
	for k = index+1, #CharacterHeaders do
		if CharacterHeaders[k].Used ~= false then
			MyGarrisons:SwapCharacterHeaders(k-1, k)
			lastUsed = k
		end
	end

	CharacterHeaders[lastUsed].Frame:Hide();
	CharacterHeaders[lastUsed].TimerBag:Hide();
	CharacterHeaders[lastUsed].Name     = ""
	CharacterHeaders[lastUsed].Used     = false
	CharacterHeaders[lastUsed].Expanded = false
	checkTimer = MyGarrisons:ScheduleRepeatingTimer("TimerCheckFunc", 1 )
	GBCharacterProperties:Hide()
end
function MyGarrisons:SwapCharacterHeaders(index1, index2)
	
	local tempName1                   = CharacterHeaders[index1].Name 
	local tempUsed1                   = CharacterHeaders[index1].Used 
	local tempExp1                    = CharacterHeaders[index1].Expanded 
	

	local tempName2                   = CharacterHeaders[index2].Name 
	local tempUsed2                   = CharacterHeaders[index2].Used 
	local tempExp2                    = CharacterHeaders[index2].Expanded 

	
	--TODO:  Update the GUI
	--Swap timers
	local temp1Timers = {};
	local temp2Timers = {};

	MyGarrisons:ClearTimersForCharacter(index1)
	MyGarrisons:ClearTimersForCharacter(index2)

	CharacterHeaders[index1].Frame.charname:SetText(tempName2)
	
	CharacterHeaders[index1].Frame.classtexture:SetAtlas(classTextureNames[MyGarrisons.db.global.Garrisons[tempName2].Class])

	CharacterHeaders[index2].Frame.charname:SetText(tempName1)

	CharacterHeaders[index2].Frame.classtexture:SetAtlas(classTextureNames[MyGarrisons.db.global.Garrisons[tempName1].Class])


	CharacterHeaders[index1].Name = tempName2

	CharacterHeaders[index2].Name = tempName1

	for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[tempName2 ].Missions) do
			MyGarrisons:AddCharacterTimer(tempName2 , "Mission", k2)
			
		end
		for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[tempName2 ].Constructions) do
			MyGarrisons:AddCharacterTimer(tempName2 , "Building", k2)
			
		end
		--TODO Workorders
		for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[CharacterHeaders[index2].Name ].Missions) do
			MyGarrisons:AddCharacterTimer(CharacterHeaders[index2].Name , "Mission", k2)
			
		end
		for k2,v2 in pairs (MyGarrisons.db.global.Garrisons[CharacterHeaders[index2].Name ].Constructions) do
			MyGarrisons:AddCharacterTimer(CharacterHeaders[index2].Name , "Building", k2)
			
			
		end
		--TODO Workorders
		if GBSelectedNameRealm ==tempName2 then
		MyGarrisons:ClearGBTimers()
			MyGarrisons:FillGBForCharacter()
			
		end
		if GBSelectedNameRealm ==CharacterHeaders[index2].Name  then
			MyGarrisons:ClearGBTimers()
			MyGarrisons:FillGBForCharacter()
			
		end
	MyGarrisons:UpdateColors ()
end
function MyGarrisons:ClearTimersForCharacter(index)
	for k,v in pairs (CharacterHeaders[index].Timers) do
		CharacterHeaders[index].Timers[k].Used = false
	
	end
end


function MyGarrisons:CountUsedTimers(index)
	local count = 0;
	for k,v in pairs (CharacterHeaders[index].Timers) do
		if CharacterHeaders[index].Timers[k].Used then
			count = count + 1
		end
	end
	return count
end
function MyGarrisons:HideShowTimers(index, shown)
	for k,v in pairs (CharacterHeaders[index].Timers) do
		if shown == true then
			if CharacterHeaders[index].Timers[k].Used then
				CharacterHeaders[index].Timers[k].Frame:Show()
			end
		else
			if CharacterHeaders[index].Timers[k].Used then
				CharacterHeaders[index].Timers[k].Frame:Hide()
			end
		end
	end
	MyGarrisons:UpdateColors ()
end
function MyGarrisons:ExpandCollapseTB(index)
	if CharacterHeaders[index].Expanded == true then
		CharacterHeaders[index].TimerBag:SetHeight(1);
		CharacterHeaders[index].Expanded = false
		MyGarrisons:HideShowTimers(index, false)
		--CharacterHeaders[index].TimerBag:Hide()

	else
		local bagHeight = 30*MyGarrisons:CountUsedTimers(index)
		if bagHeight ~= 0 then
			CharacterHeaders[index].TimerBag:SetHeight(bagHeight);
			CharacterHeaders[index].Expanded = true
			MyGarrisons:HideShowTimers(index, true)
			CharacterHeaders[index].TimerBag:Show()
		end
		
	end
	MyGarrisons:UpdateColors ()
end
function MyGarrisons:AddCharacterTimer(charname, typeID, missID)


	--TODO  Look for unused timers.
	local charactersH = 0;
	for k,v in pairs (CharacterHeaders) do
		if CharacterHeaders[k].Name == charname then
			charactersH = k
		end

	end
	local index = 0
	local found = false
	for k= 1,(#CharacterHeaders[charactersH].Timers) do
		--print("Timer used status = "
		if CharacterHeaders[charactersH].Timers[k].Used == true and CharacterHeaders[charactersH].Timers[k].TimerType == typeID and CharacterHeaders[charactersH].Timers[k].ID == missID then
			return nil
		end
		if CharacterHeaders[charactersH].Timers[k].Used == false or CharacterHeaders[charactersH].Timers[k].ID == 0 then
			if index ~= 0 then
				if index > k then
					index = k
				end
			else
			index = k
			end

		end
	end

	if index == 0 then
		index = #CharacterHeaders[charactersH].Timers + 1
		--MissionTimerTemplate
		--CreateFrame("Frame", "CharacterHeaderTemplate"..(#CharacterHeaders+1),MyGarrisonTimers.timerscroll.GarrisonScrollContent,"CharacterHeaderTemplate"),
		
		CharacterHeaders[charactersH].Timers[index] = 
		{	Frame                                   = CreateFrame("Frame", "MissionTimerTemplate"..charname..index,CharacterHeaders[charactersH].TimerBag,"MissionTimerTemplate"),
			Name                                    = charname, 
			TimerType                               = typeID, 
			ID                                      = missID, 
			Used                                    = false,
			Texture	=	nil	}
			CharacterHeaders[charactersH].Timers[index].Texture = CharacterHeaders[charactersH].Timers[index].Frame:CreateTexture("tes","BACKGROUND")
			CharacterHeaders[charactersH].Timers[index].Texture:SetAllPoints()
		if index == 1 then
			CharacterHeaders[charactersH].Timers[index].Frame:SetPoint("TOPLEFT",CharacterHeaders[charactersH].TimerBag,"TOPLEFT")
		else
			CharacterHeaders[charactersH].Timers[index].Frame:SetPoint("TOPLEFT",CharacterHeaders[charactersH].Timers[index-1].Frame,"BOTTOMLEFT")
		end
	end
	CharacterHeaders[charactersH].Timers[index].Name      = charname
	CharacterHeaders[charactersH].Timers[index].TimerType = typeID
	CharacterHeaders[charactersH].Timers[index].ID        = missID
	CharacterHeaders[charactersH].Timers[index].Used      = true
	CharacterHeaders[charactersH].Timers[index].Frame.nameframe.namestring:SetText("FILLED")
	if CharacterHeaders[charactersH].Expanded == false then
	CharacterHeaders[charactersH].Timers[index].Frame:Hide()
	else
	CharacterHeaders[charactersH].Timers[index].Frame:Show()
		local bagHeight = 30*MyGarrisons:CountUsedTimers(charactersH)
		CharacterHeaders[charactersH].TimerBag:SetHeight(bagHeight);
	end
	--If no unused timer, make new one.

		MyGarrisons:UpdateColors ()
end
function MyGarrisons:UpdateTimers()
	

end
function MyGarrisons:UnuseCharacterTimer2(charname, typeID, missID)

end
function MyGarrisons:UnuseCharacterTimer(charname, typeID, missID)



	local charactersH = 0;
	for k,v in pairs (CharacterHeaders) do
		if CharacterHeaders[k].Name == charname then
			charactersH = k
		end

	end
	local index = 0
	local found = false

	for k,v in pairs (CharacterHeaders[charactersH].Timers) do
		if CharacterHeaders[charactersH].Timers[k].Used == true then
		
			if CharacterHeaders[charactersH].Timers[k].ID == missID and CharacterHeaders[charactersH].Timers[k].TimerType == typeID and found == false then
				
				index = k
				found = true
			end
		end
	end

	if index ~= 0 then
		CharacterHeaders[charactersH].Timers[index].Name      = charname
		CharacterHeaders[charactersH].Timers[index].TimerType = 0
		CharacterHeaders[charactersH].Timers[index].ID        = 0
		CharacterHeaders[charactersH].Timers[index].Used      = false
		CharacterHeaders[charactersH].Timers[index].Frame.nameframe.namestring:SetText("")
		--CharacterHeaders[charactersH].Timers[index].Frame:Hide()
		for k = index+1, #CharacterHeaders[charactersH].Timers  do
			MyGarrisons:SwapTimers(charactersH, k-1, k)

		end
		CharacterHeaders[charactersH].Timers[#CharacterHeaders[charactersH].Timers].Frame:Hide()
		--CharacterHeaders[charactersH].Timers[#CharacterHeaders[charactersH].Timers].Used      = false
	end

	MyGarrisons:UpdateColors ()
	if CharacterHeaders[charactersH].Expanded == false then

	else

		local bagHeight = 30*MyGarrisons:CountUsedTimers(charactersH)
		CharacterHeaders[charactersH].TimerBag:SetHeight(bagHeight);
	end
	
MyGarrisons:CheckForShownUnused(charactersH)
end
function MyGarrisons:CheckForShownUnused(cindex)
	for k = 1, #CharacterHeaders[cindex].Timers do
		if CharacterHeaders[cindex].Timers[k].Used == false then
			if CharacterHeaders[cindex].Timers[k].Frame:IsShown() then
				CharacterHeaders[cindex].Timers[k].Frame:Hide()
			end
		else
			if CharacterHeaders[cindex].Timers[k].ID == 0 then
				CharacterHeaders[cindex].Timers[k].Used = false
				
			end
		end
	end
end
--This function is used to switch which timer frame is used for what ID.
-- Inputs:  cindex: Character Index,  tindex1: Timer 1 Index ,  tindex2: Timer 2 Index.
function MyGarrisons:SwapTimers(cindex, tindex1, tindex2)
	local names1 = CharacterHeaders[cindex].Timers[tindex1].Frame.nameframe.namestring:GetText()
	local timertype1 = CharacterHeaders[cindex].Timers[tindex1].TimerType
	local id1        = CharacterHeaders[cindex].Timers[tindex1].ID
	local used1      = CharacterHeaders[cindex].Timers[tindex1].Used

	local names2 = CharacterHeaders[cindex].Timers[tindex2].Frame.nameframe.namestring:GetText()
	local timertype2 = CharacterHeaders[cindex].Timers[tindex2].TimerType
	local id2        = CharacterHeaders[cindex].Timers[tindex2].ID
	local used2      = CharacterHeaders[cindex].Timers[tindex2].Used

	CharacterHeaders[cindex].Timers[tindex1].TimerType = timertype2
	CharacterHeaders[cindex].Timers[tindex1].ID        = id2
	CharacterHeaders[cindex].Timers[tindex1].Used      = used2
	CharacterHeaders[cindex].Timers[tindex1].Frame.nameframe.namestring:SetText(names2)

	CharacterHeaders[cindex].Timers[tindex2].TimerType = timertype1
	CharacterHeaders[cindex].Timers[tindex2].ID        = id1
	CharacterHeaders[cindex].Timers[tindex2].Used      = used1
	CharacterHeaders[cindex].Timers[tindex2].Frame.nameframe.namestring:SetText(names1)
	
	MyGarrisons:UpdateColors ()
end


function MyGarrisons:DetermineDuration(durString)
	returnTimes = {}

	local x1, x2, minuteString = strfind(durString,"(%d+ min)")
	if x1 ~= nil then
		local a1, a2, minutes = strfind(minuteString,"(%d+)")
		returnTimes.min = tonumber(minutes)

		--returnTimes.min =
	end

	local y1, y2, hourString = strfind(durString,"(%d+ hour)")
	if y1 ~= nil then
		local a1, a2, hour = strfind(hourString,"(%d+)")
		returnTimes.hour = tonumber(hour)
		--returnTimes.min =
	end
	return returnTimes
end
-- ===================================================================================================== --
-- Command Line Options
-- ===================================================================================================== --
local NeooptionTable = {
		name	= "MyGarrisons",
		handler = MyGarrisons,
		type	= 'group',
		args = {
						clear = 		{
									name = "Clear Database",
									type = "execute",
									func = function ()
									MyGarrisons.db.global.Garrisons = {}
									end
						},
						timers 	=	{
									name = "Show timers",
									desc = "Shows the timer frame",
									type = "execute",
									func = function ()
									MyGarrisonTimers:Show()
										 end
						},
						show=	{
									name = "Show",
									desc = "Shows the full frame",
									type = "execute",
									func = function ()
									GarrisonBuildings:Show()
										 end
						},
						scan 	=	{
									name = "SCAN",
									desc = "Shows the timer frame",
									type = "execute",
									func = function ()
									MyGarrisons:ShipmentScan ()
										 end
						}

				}
			}

LibStub("AceConfig-3.0"):RegisterOptionsTable("MyGarrisons", NeooptionTable, {"gar"})


---------------------------------------------------------------------------------------------------------------------------------------------------
--Shipments
---------------------------------------------------------------------------------------------------------------------------------------------------


function MyGarrisons:ScanShipments()

	local nam, realmi = UnitName("player")
	
	if MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments == nil then
		MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments = {}
	end
	local MyBuildings = C_Garrison.GetBuildings();
	
	for i = 1, #MyBuildings do 
		local buildingID = MyBuildings[i].buildingID;
        if ( buildingID ) then
			local shipie = {C_Garrison.GetLandingPageShipmentInfo(buildingID)};
			if shipie[1] ~= nil then
				if shipie[9] ~= nil then
					if MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments [shipie[9]] == nil then
				MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments [shipie[9]] = {	TotalMax = shipie[3],
																									TotalOrdered = shipie[5],
																									TotalDone = shipie[4],
																									StartTime = 0,
																									EndTime = 0}
				--print(" N "..shipie[1])
				end
				
				end
			end
			
			
			--1		Building Name
			--2		WorkOrder Icon
			--3		Max Orders
			--4		Orders Done
			--5		Total number of orders placed
			--6		Time order placed in seconds?
			--7		Total time for one order in seconds
			--8		Remaining Time for current Order in string
			--9		Type of place(Mine, Garden)
			
			
		end
	
	end

end


---------------------------------------------------------------------------------------------------------------------------------------------------
---Buildings









function MyGarrisons:ProgressCheck()
	for k,v in pairs (C_Garrison.GetInProgressMissions()) do
		for k2, v2 in pairs (v) do
			if k2 == "missionID" then

			end
			if k2 == "duration" then
--local currentMissions = C_Garrison.GetInProgressMissions()
--for k,v in pairs (currentMissions) do
	--local tempMissionID = v.missionID
	--local tempTimeLeftString = v.timeLeft
	
	
				local timeTab = MyGarrisons:DetermineDuration(v2)
				--("%m_%d_%y/%H:%M:%S")
				local startTime = caldate:parse(date("%m_%d_%y/%H:%M:%S"))

				local endTime = caldate:parse(date("%m_%d_%y/%H:%M:%S"))
				if timeTab.hour ~= nil then
					endTime.hour = endTime.hour + timeTab.hour
					
				end
				if timeTab.min ~= nil then
					endTime.minute = endTime.minute + timeTab.min

				end

			end
		end
	end
end
function MyGarrisons:FollowerToMission(missionID, followerID)

	followersOnMission[tostring(followerID)] = missionID
end
function MyGarrisons:RemoveFollowerMission(missionID, followerID)

	followersOnMission[tostring(followerID)] = nil

end
local missionTimeStringPattern = "%d*%s?%l*%s?%d*%s?%l* (%d+) %l* %d*%s?%l*%s?%d*%s?%l* (%d+) %l*"

function MyGarrisons:Par()
	--print(strfind(C_Garrison.GetMissionTimes(142),missionTimeStringPattern))
	--print(C_Garrison.GetMissionTimes(205))
	local splits = {}
	local a = {C_Garrison.GetMissionTimes(205)}
	for k,v in pairs(a) do
	--	print(k.." "..tostring(v))
	end
	
	splits = {strsplit("%s*",C_Garrison.GetMissionTimes(205))}
	for k,v in pairs (splits) do
	--	print(k.." "..v)
	end
end
function MyGarrisons:StartGMission(missionID)
	--find all followers assigned to that mission

	local folls = {}
	for k,v in pairs (followersOnMission) do
		if v == missionID then
			for k2,v2 in pairs ( C_Garrison.GetFollowerAbilities(tostring(k))) do 
				--for k3,v3 in pairs (v) do
				--epic mount = 221
				if v2.id == 221 then
					--print("EPIC MOUNT")
				end
				--end
			end
			tinsert(folls,C_Garrison.GetFollowerInfo(tostring(k)).name)
		end
	end
	--print("Followers going on "..C_Garrison.GetMissionName(missionID))
	for k,v in pairs(folls) do
	--	print(v)
	end
	--Save the mission
	MyGarrisons:SaveMission(missionID, followersOnMission)
	MyGarrisons:ProgressCheck()
end
function MyGarrisons:SaveMission(missionID, followers)
	local nam, realmi = UnitName("player")
	local epicmountcount = 0;
	if MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Missions[missionID] == nil then
	
	
	
		for k,v in pairs (followers) do
			if v == missionID then
				for k2,v2 in pairs ( C_Garrison.GetFollowerAbilities(tostring(k))) do 

					if v2.id == 221 then
						--print("EPIC MOUNT")
						epicmountcount = epicmountcount + 1
					end

				end
			end
		end

	--	print("creating entry for mission")
		local d2 = caldate:parse( date("%m_%d_%y/%H:%M:%S"))
		--local missionTimeString = C_Garrison.GetMissionTimes(missionID)
		--print(strfind(C_Garrison.GetMissionTimes(missionID),missionTimeStringPattern))
		--print(strfind(C_Garrison.GetMissionTimes(missionID),"%d*%s?%l*%s?%d*%s?%l* (%d+) %l* %d*%s?%l*%s?%d*%s?%l* (%d+) %l*"))
		--local start, endS, num1, num2 = strfind(missionTimeString, missionTimeStringPattern)
		local a = {C_Garrison.GetMissionTimes(missionID)}
		local totalSeconds
		--if epicmountcount ==0 then
			totalSeconds = tonumber(a[2]) + (tonumber(a[5]))
		--else
		--	local reducedtime = (tonumber(a[5]))
		--	for k = 1,epicmountcount do
		--		reducedtime = reducedtime / 2
		--	end
		--	totalSeconds = tonumber(a[2]) +reducedtime
		--end
		d2.second = d2.second + totalSeconds

		MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Missions[missionID] = {	StartTime =  Meta.__tostring(caldate:parse(date("%m_%d_%y/%H:%M:%S"))), 
																							EndTimer  = Meta.__tostring(d2), 
																							Followers = followers}
		MyGarrisons:AddCharacterTimer(nam.."-"..GetRealmName(), "Mission", missionID)
		if GBSelectedNameRealm ==nam.."-"..GetRealmName() then
			
			MyGarrisons:ClearGBTimers()
			MyGarrisons:FillGBForCharacter()
		end
	end
	
end


function MyGarrisons:ScanGarrison()

	local nam, realmi = UnitName("player")
	for k,v in pairs (C_Garrison.GetBuildings()) do 
			local foll = MyGarrisons:GetFollowersForBuilding(nam, GetRealmName(), v.buildingID)
			

			local buildInfo = {C_Garrison.GetBuildingInfo(v.buildingID)}
			MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Buildings[k] = {PlotID = v.plotID, 
			ID = v.buildingID, 
			BuildingName = buildInfo[2],
			Icon = buildInfo[4],
			Level = buildInfo[6],
			Follower = foll}
											--C_Garrison.GetFollowerInfoForBuilding

		--123
	end
	
end
function MyGarrisons:AddFollowerToBuilding(nam, realm, plotID, followerID)
	for k,v in pairs (MyGarrisons.db.global.Garrisons[nam.."-"..realm].Buildings) do
		if v.PlotID == plotID then
			MyGarrisons.db.global.Garrisons[nam.."-"..realm].Buildings[k].Follower = followerID
		end
	end
	
end
function MyGarrisons:RemoveFollowerToBuilding(nam, realm, plotID)
	for k,v in pairs (MyGarrisons.db.global.Garrisons[nam.."-"..realm].Buildings) do
		if v.PlotID == plotID then
			MyGarrisons.db.global.Garrisons[nam.."-"..realm].Buildings[k].Follower = 0
		end
	end
	
end
function MyGarrisons:GetFollowersForBuilding(nam, realm, buildingID)
	for k,v in pairs (MyGarrisons.db.global.Garrisons[nam.."-"..realm].Buildings) do
		if v.ID == buildingID then
			return v.Follower;
		end
	end
	return nil
end
function MyGarrisons:BuildingAlreadyInScan(nam, realm, plotID, buildingID)
	for k,v in pairs (MyGarrisons.db.global.Garrisons[nam.."-"..realm].Buildings) do
		
		
	end
	return false
end
-- The default Database settings.
local defaults = {
	
	global = {Garrisons = {},
				Settings = {
							CharacterHeaderTextColor = {R = 1, B = 0, 	  G = 0.82},
							CharacterBarColor = {R = 0, B = 0, 	  G = 0},
							CharacterTimerTextColor    = {R = 1, B = 0, 	  G = 0.82},
							MissionTimerTextColor    = {R = 1, B = 0, 	  G = 0.82},
							MissionHeaderTextColor   = {R = 0, B = 0.753, G = 0.753},
							MissionBarColor          = {R = 0, B = 0, 	  G = 0},
							MissionFrameColor        = {R = 0, B = 0, 	  G = 0},
							BuildingTimerTextColor   = {R = 1, B = 0,     G = 0.82},
							BuildingHeaderTextColor  = {R = 0, B = 0.753, G = 0.753},
							BuildingBarColor         = {R = 0, B = 0, 	  G = 0},
							BuildingFrameColor       = {R = 0, B = 0, 	  G = 0},
							WorkOrderTimerTextColor  = {R = 1, B = 0, 	  G = 0.82},
							WorkOrderHeaderTextColor = {R = 0, B = 0.753, G = 0.753},
							WorkOrderBarColor        = {R = 0, B = 0, 	  G = 0},
							WorkOrderFrameColor      = {R = 0, B = 0, 	  G = 0},
							
							
							HideTimerFrameOnStart	 = false
							
							
							}
	
	
	}


}
local main = {
	name = "MyGarrisons",
	type = "group",
	handler = MyGarrisons,
	args = {
			HideTimerFrameOnStart = {
										name = "Hide Timer Frame on Start",
										type = "toggle",
										get = function () return MyGarrisons.db.global.Settings.HideTimerFrameOnStart end,
										set = function (info, val) MyGarrisons.db.global.Settings.HideTimerFrameOnStart = val end,
										order = 1
			
									},
									MissColorOptions = {type = "header", name = "Mission Color Options", order = 7},
								MissionHeaderTextColor = {
										name = "Mission Header Color",
										type = "color",
										order = 8,
										get  = function() return MyGarrisons.db.global.Settings.MissionHeaderTextColor.R,MyGarrisons.db.global.Settings.MissionHeaderTextColor.G,MyGarrisons.db.global.Settings.MissionHeaderTextColor.B,1  end,
										set  = function(x, r,g,b,a) MyGarrisons.db.global.Settings.MissionHeaderTextColor.R = r  MyGarrisons.db.global.Settings.MissionHeaderTextColor.B = b MyGarrisons.db.global.Settings.MissionHeaderTextColor.G = g MyGarrisons:UpdateColors ()  end
										
							},
							MissionBarColor = {
										name = "Mission Bar Color",
										type = "color",
										order = 8,
										get  = function() return MyGarrisons.db.global.Settings.MissionBarColor.R,MyGarrisons.db.global.Settings.MissionBarColor.G,MyGarrisons.db.global.Settings.MissionBarColor.B,1  end,
										set  = function(x, r,g,b,a) MyGarrisons.db.global.Settings.MissionBarColor.R = r  MyGarrisons.db.global.Settings.MissionBarColor.B = b MyGarrisons.db.global.Settings.MissionBarColor.G = g MyGarrisons:UpdateColors () end
										
							},
							MissionTimerTextColor = {
										name = "Mission Timer Text Color",
										type = "color",
										order = 8,
										get  = function() return MyGarrisons.db.global.Settings.MissionTimerTextColor.R,MyGarrisons.db.global.Settings.MissionTimerTextColor.G,MyGarrisons.db.global.Settings.MissionTimerTextColor.B,1  end,
										set  = function(x, r,g,b,a) MyGarrisons.db.global.Settings.MissionTimerTextColor.R = r  MyGarrisons.db.global.Settings.MissionTimerTextColor.B = b MyGarrisons.db.global.Settings.MissionTimerTextColor.G = g  MyGarrisons:UpdateColors () end
										
							},
							
							CharColorOptions = {type = "header", name = "Color Options", order = 5},
							CharacterHeaderTextColor = {
										name = "Character Header Text Color",
										type = "color",
										order = 6,
										get  = function() return MyGarrisons.db.global.Settings.CharacterHeaderTextColor.R,MyGarrisons.db.global.Settings.CharacterHeaderTextColor.G,MyGarrisons.db.global.Settings.CharacterHeaderTextColor.B,1  end,
										set  = function(x, r,g,b,a) MyGarrisons.db.global.Settings.CharacterHeaderTextColor.R = r  MyGarrisons.db.global.Settings.CharacterHeaderTextColor.B = b MyGarrisons.db.global.Settings.CharacterHeaderTextColor.G = g MyGarrisons:UpdateColors () end
										
							},
							CharacterBarColor = {
										name = "Character Bar Color",
										type = "color",
										order = 6,
										get  = function() return MyGarrisons.db.global.Settings.CharacterBarColor.R,MyGarrisons.db.global.Settings.CharacterBarColor.G,MyGarrisons.db.global.Settings.CharacterBarColor.B,1  end,
										set  = function(x, r,g,b,a)  MyGarrisons.db.global.Settings.CharacterBarColor.R = r  MyGarrisons.db.global.Settings.CharacterBarColor.B = b MyGarrisons.db.global.Settings.CharacterBarColor.G = g MyGarrisons:UpdateColors ()  end
										
							},
							CharacterTimerTextColor = {
										name = "Character Timer Texe Color",
										type = "color",
										order = 6,
										get  = function() return MyGarrisons.db.global.Settings.CharacterTimerTextColor.R,MyGarrisons.db.global.Settings.CharacterTimerTextColor.G,MyGarrisons.db.global.Settings.CharacterTimerTextColor.B,1  end,
										set  = function(x, r,g,b,a) MyGarrisons.db.global.Settings.CharacterTimerTextColor.R = r  MyGarrisons.db.global.Settings.CharacterTimerTextColor.B = b MyGarrisons.db.global.Settings.CharacterTimerTextColor.G = g MyGarrisons:UpdateColors ()  end
										
							},
							BuldingColorOptions = {type = "header", name = "Building Color Options", order = 9},
	BuildingHeaderTextColor = {
										name = "Building Header Text Color",
										type = "color",
										order = 10,
										get  = function() return MyGarrisons.db.global.Settings.BuildingHeaderTextColor.R,MyGarrisons.db.global.Settings.BuildingHeaderTextColor.G,MyGarrisons.db.global.Settings.BuildingHeaderTextColor.B,1  end,
										set  = function(x, r,g,b,a) MyGarrisons.db.global.Settings.BuildingHeaderTextColor.R = r  MyGarrisons.db.global.Settings.BuildingHeaderTextColor.B = b MyGarrisons.db.global.Settings.BuildingHeaderTextColor.G = g  MyGarrisons:UpdateColors () end
										
							},
							BuildingTimerTextColor = {
										name = "Building Timer Text Color",
										type = "color",
										order = 10,
										get  = function() return MyGarrisons.db.global.Settings.BuildingTimerTextColor.R,MyGarrisons.db.global.Settings.BuildingTimerTextColor.G,MyGarrisons.db.global.Settings.BuildingTimerTextColor.B,1  end,
										set  = function(x, r,g,b,a) MyGarrisons.db.global.Settings.BuildingTimerTextColor.R = r  MyGarrisons.db.global.Settings.BuildingTimerTextColor.B = b MyGarrisons.db.global.Settings.BuildingTimerTextColor.G = g  MyGarrisons:UpdateColors () end
										
							},
							
							BuildingBarColor = {
										name = "Building Bar Color",
										type = "color",
										order = 10,
										get  = function() return MyGarrisons.db.global.Settings.BuildingBarColor.R,MyGarrisons.db.global.Settings.BuildingBarColor.G,MyGarrisons.db.global.Settings.BuildingBarColor.B,1  end,
										set  = function(x, r,g,b,a) MyGarrisons.db.global.Settings.BuildingBarColor.R = r  MyGarrisons.db.global.Settings.BuildingBarColor.B = b MyGarrisons.db.global.Settings.BuildingBarColor.G = g MyGarrisons:UpdateColors () end
										
							},FrameSizing = {type = "header", name = "FrameSizing", order = 11},
							FrameHeightChange = {type = "range", name = "Frame Height", order = 12, 
													get = function () return  MyGarrisonTimers.timerscroll:GetHeight() end,
													set = function (info, val) 
													MyGarrisonTimers.timerscroll:SetHeight(val)

		
													
													end,
													min = 0,
													max = 328}--,
--FrameWidthChange = {type = "range", name = "Frame Width", order = 12, 
--													get = function () return  MyGarrisonTimers:GetWidth() end,
	--												set = function (info, val) 
	--												MyGarrisonTimers:SetWidth(val)

		
													
		--											end,
	--												min = 0,
		--											max = 258}													
										
										
										
										}
			
			
			
	
	}
--This function can be called whenever changes to the color settings are done.
function MyGarrisons:UpdateColors ()
	
--CharacterHeaders[k].Timers[k2]
	for k,v in pairs (CharacterHeaders) do
		CharacterHeaders[k].Frame.charname:SetTextColor(MyGarrisons.db.global.Settings.CharacterHeaderTextColor.R, MyGarrisons.db.global.Settings.CharacterHeaderTextColor.G,MyGarrisons.db.global.Settings.CharacterHeaderTextColor.B, 1 )
		CharacterHeaders[k].Frame.classtexture:SetAtlas(classTextureNames[MyGarrisons.db.global.Garrisons[CharacterHeaders[k].Frame.charname:GetText()].Class])
		for k2, v2 in pairs (CharacterHeaders[k].Timers) do
		
			CharacterHeaders[k].Timers[k2].Frame.timebar.tx = CharacterHeaders[k].Timers[k2].Frame.timebar.tx or CharacterHeaders[k].Timers[k2].Frame.timebar:CreateTexture()
			--CharacterHeaders[k].Timers[k2].Frame.timebar
			
			CharacterHeaders[k].Timers[k2].Frame.timebar.tx:SetAllPoints(CharacterHeaders[k].Timers[k2].Frame.timebar);
			if CharacterHeaders[k].Timers[k2].TimerType == "Mission" then
				local r = MyGarrisons.db.global.Settings.MissionBarColor.R
				local b = MyGarrisons.db.global.Settings.MissionBarColor.B
				local g = MyGarrisons.db.global.Settings.MissionBarColor.G
				CharacterHeaders[k].Timers[k2].Frame.timebar.tx:SetTexture(r,b,g, 0.8);
				--local tes = CharacterHeaders[k].Timers[k2].Frame:CreateTexture("tes","BACKGROUND");
				--tes:SetAllPoints()
				
				CharacterHeaders[k].Timers[k2].Texture:SetAtlas("GarrLanding-Mission-InProgress")
				--"GarrLanding-Mission-InProgress"   Mission on
				--Interface\\Garrison\\Garr_TimerFill-Upgrade
				--GarrBuilding_LumberMill_1_A_Map  Icon for lumber mill
				--Garr_Building-AddFollowerPlus		
				--Garr_BuildIcon  Construction Icon
				--Garr_BuildingTimerGlow   Glow
				--Garr_BuildingIconTimerBG   Building Timer Circle
				--Garr_InfoBoxMission-BackgroundTile
				--Garr_WoodFrame-BackgroundTile
				--CharacterHeaders[k].Timers[k2].Frame.tex = tes
				--CharacterHeaders[k].Timers[k2].Frame:SetTexture("Interface\\CHARACTERFRAME\\TempPortrait")
				--GarrLanding-MissionListBG
				--CharacterHeaders[k].Timers[k2].Frame.timertext:SetTexture("Interface\\BlackMarket\\_WoodFrame-TileHorizontal")
				CharacterHeaders[k].Timers[k2].Frame.nameframe.namestring:SetTextColor(MyGarrisons.db.global.Settings.MissionHeaderTextColor.R, MyGarrisons.db.global.Settings.MissionHeaderTextColor.G,MyGarrisons.db.global.Settings.MissionHeaderTextColor.B, 1 )
				CharacterHeaders[k].Timers[k2].Frame.timertext:SetTextColor(MyGarrisons.db.global.Settings.MissionTimerTextColor.R, MyGarrisons.db.global.Settings.MissionTimerTextColor.G,MyGarrisons.db.global.Settings.MissionTimerTextColor.B, 1 )
			end
			if CharacterHeaders[k].Timers[k2].TimerType == "Building" then
				local r = MyGarrisons.db.global.Settings.BuildingBarColor.R
				local b = MyGarrisons.db.global.Settings.BuildingBarColor.B
				local g = MyGarrisons.db.global.Settings.BuildingBarColor.G
				CharacterHeaders[k].Timers[k2].Frame.timebar.tx:SetTexture(r,b,g, 0.8);
				--local tes = CharacterHeaders[k].Timers[k2].Frame:CreateTexture("tes","BACKGROUND");
				--tes:SetAllPoints()
				
				CharacterHeaders[k].Timers[k2].Texture:SetAtlas("GarrLanding-Building-InProgress")
				CharacterHeaders[k].Timers[k2].Frame.nameframe.namestring:SetTextColor(MyGarrisons.db.global.Settings.BuildingHeaderTextColor.R, MyGarrisons.db.global.Settings.BuildingHeaderTextColor.G,MyGarrisons.db.global.Settings.BuildingHeaderTextColor.B, 1 )
				CharacterHeaders[k].Timers[k2].Frame.timertext:SetTextColor(MyGarrisons.db.global.Settings.BuildingTimerTextColor.R, MyGarrisons.db.global.Settings.BuildingTimerTextColor.G,MyGarrisons.db.global.Settings.BuildingTimerTextColor.B, 1 )
			end
			if CharacterHeaders[k].Timers[k2].TimerType == "Shipment" then
				local r = MyGarrisons.db.global.Settings.WorkOrderHeaderTextColor.R
				local b = MyGarrisons.db.global.Settings.WorkOrderHeaderTextColor.B
				local g = MyGarrisons.db.global.Settings.WorkOrderHeaderTextColor.G
				CharacterHeaders[k].Timers[k2].Frame.timebar.tx:SetTexture(r,b,g, 0.8);
				--"GarrLanding-TradeskillTimer-ParchmentBG"
				CharacterHeaders[k].Timers[k2].Texture:SetAtlas("GarrLanding_Watermark-Tradeskill")
			end
			CharacterHeaders[k].Timers[k2].Frame.timebar:SetStatusBarTexture(CharacterHeaders[k].Timers[k2].Frame.timebar.tx);
		end
	end


end
function MyGarrisons:ParseBuildingTime(tim)


end
function MyGarrisons:AddConstruction(name, realm, plotInstanceID, buildingID)
	local buildingInfo = {C_Garrison.GetBuildingInfo(buildingID)}
	if MyGarrisons.db.global.Garrisons[name.."-"..realm].Constructions == nil then
		MyGarrisons.db.global.Garrisons[name.."-"..realm].Constructions = {}
	end
	local d2 = caldate:parse( date("%m_%d_%y/%H:%M:%S"))
	
	local buildingInfo = {C_Garrison.GetBuildingInfo(buildingID)};
	local timeStr = buildingInfo[10];
	d2.second = d2.second +(MyGarrisons:buildingTimeToSeconds(timeStr))
		--local missionTimeString = C_Garrison.GetMissionTimes(missionID)
		--print(strfind(C_Garrison.GetMissionTimes(missionID),missionTimeStringPattern))
		--print(strfind(C_Garrison.GetMissionTimes(missionID),"%d*%s?%l*%s?%d*%s?%l* (%d+) %l* %d*%s?%l*%s?%d*%s?%l* (%d+) %l*"))
		--local start, endS, num1, num2 = strfind(missionTimeString, missionTimeStringPattern)
	--	local a = {C_Garrison.GetMissionTimes(missionID)}
	--	local totalSeconds = tonumber(a[2]) + tonumber(a[5])
	--	d2.second = d2.second + totalSeconds
	
	--TODO compute end time.
		MyGarrisons.db.global.Garrisons[name.."-"..realm].Constructions[buildingID] = {
			PlotID = plotInstanceID,
			BuildingID = buildingID,
			StartTime = Meta.__tostring(caldate:parse(date("%m_%d_%y/%H:%M:%S"))),
			EndTimer  = Meta.__tostring(d2),
			BuildingName = buildingInfo[2]
		
		}
end
function MyGarrisons:AddCharacter (name, realm)
local classDisplayName, class, classID = UnitClass("player");
local englishFaction, localizedFaction = UnitFactionGroup("player")
MyGarrisons.db.global.Garrisons[name.."-"..realm] = {
														Faction = englishFaction,
														Class = classID,
														Buildings = {}, 
														Followers = {}, 
														Missions  = {},
														Constructions = {},
														Shipments = {}
														}
														
														
end

local minimized = false
function MyGarrisons:MinizerMaxi()
	if minimized == false then
		MyGarrisonTimers:SetHeight(29)
		MyGarrisonTimers:SetWidth(289)
		minimized = true
		MyGarrisonTimers.timerscroll:Hide()

		--Abs 289,378
	else
		MyGarrisonTimers:SetHeight(378)
		MyGarrisonTimers:SetWidth(289)
		MyGarrisonTimers.timerscroll:Show()

		
		minimized = false
	end
end




function MyGarrisons:ConvertSecondsToTime(secs)

	local nHours = string.format("%02.f", floor(secs/3600));
	local nMins  = string.format("%02.f", floor(secs/60 - (nHours*60)));
	local nSecs  = string.format("%02.f", (secs%60));

	return nHours..":"..nMins..":"..nSecs
end
function MyGarrisons:TimerCheckFunc()

	MyGarrisons:UpdateGBTimers()
	local d2 = caldate:parse( date("%m_%d_%y/%H:%M:%S"))
	for k,v in pairs (CharacterHeaders) do
		if CharacterHeaders[k].Used then
		for k2, v2 in pairs (CharacterHeaders[k].Timers) do
			if CharacterHeaders[k].Timers[k2].Used then
				if CharacterHeaders[k].Timers[k2].TimerType == "Mission" then

					local charname = CharacterHeaders[k].Name
					if MyGarrisons.db.global.Garrisons[charname].Missions[CharacterHeaders[k].Timers[k2].ID] ~= nil then
						--CharacterHeaders[k].Timers[k2].ID
						
						--print(MyGarrisons.db.global.Garrisons[k].Missions[k2].EndTimer)
						CharacterHeaders[k].Timers[k2].Frame.nameframe.namestring:SetText(C_Garrison.GetMissionName(CharacterHeaders[k].Timers[k2].ID))
					
						local endTim = MyGarrisons.db.global.Garrisons[charname].Missions[CharacterHeaders[k].Timers[k2].ID].EndTimer
						local remaining = Meta.__sub(caldate:parse(endTim),d2)
						if remaining > 0 then
							CharacterHeaders[k].Timers[k2].Frame.timertext:SetText(MyGarrisons:ConvertSecondsToTime(remaining))
						else
							CharacterHeaders[k].Timers[k2].Frame.timertext:SetText("Done")
						end
						--TODO:  Progress Bar
					else
						MyGarrisons:UnuseCharacterTimer(charname, "Mission", CharacterHeaders[k].Timers[k2].ID)
					end
					
				end
				if CharacterHeaders[k].Timers[k2].TimerType == "Building" then
					local charname = CharacterHeaders[k].Name
					--local buildingInfo = {C_Garrison.GetBuildingInfo(CharacterHeaders[k].Timers[k2].ID)}
					if MyGarrisons.db.global.Garrisons[charname].Constructions[CharacterHeaders[k].Timers[k2].ID].BuildingName ~= nil then
						CharacterHeaders[k].Timers[k2].Frame.nameframe.namestring:SetText(MyGarrisons.db.global.Garrisons[charname].Constructions[CharacterHeaders[k].Timers[k2].ID].BuildingName)
					else
					CharacterHeaders[k].Timers[k2].Frame.nameframe.namestring:SetText("UNKNOWN BUILDING")
					--Garr_WoodFrame-BackgroundTile
					CharacterHeaders[k].Timers[k2].Frame.timertext:SetTexture("Interface\\BlackMarket\\_WoodFrame-TileHorizontal")
					end
					--MyGarrisons.db.global.Garrisons[charname].Constructions[CharacterHeaders[k].Timers[k2].ID]
					
					local endTim = MyGarrisons.db.global.Garrisons[charname].Constructions[CharacterHeaders[k].Timers[k2].ID].EndTimer
					local remaining = Meta.__sub(caldate:parse(endTim),d2)
					if remaining > 0 then
						CharacterHeaders[k].Timers[k2].Frame.timertext:SetText(MyGarrisons:ConvertSecondsToTime(remaining))
					else
						CharacterHeaders[k].Timers[k2].Frame.timertext:SetText("Done")
					end
				end
				if CharacterHeaders[k].Timers[k2].TimerType == "Shipment" then
					local charname = CharacterHeaders[k].Name
					local endTim = MyGarrisons.db.global.Garrisons[charname].Shipments[CharacterHeaders[k].Timers[k2].ID].EndTimer
					local ScannedTime = caldate:parse(MyGarrisons.db.global.Garrisons[charname].Shipments[CharacterHeaders[k].Timers[k2].ID].StartTime)
					
				
					local remaining = Meta.__sub(caldate:parse(endTim),d2)
					
					--MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments[CharacterHeaders[k].Timers[k2].ID].StartTime = Meta.__tostring(caldate:parse(date("%m_%d_%y/%H:%M:%S")))
					
					--CharacterHeaders[k].Timers[k2].ID
				--	MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments [shipie[9]] = {	TotalMax = shipie[3],
					--																				TotalOrdered = shipie[5],
					--																				TotalDone = shipie[4],
					--																				StartTime = 0,
					--																				EndTime = 0}
					local endTim = MyGarrisons.db.global.Garrisons[charname].Shipments[CharacterHeaders[k].Timers[k2].ID].EndTime
					--CharacterHeaders[k].Timers[k2].Frame.timertext:SetTexture("Interface\\BlackMarket\\_WoodFrame-TileHorizontal")
					
					local NeoMessage = "Work Order "..CharacterHeaders[k].Timers[k2].ID.." "
					--..CharacterHeaders[k].Timers[k2].ID.." "..MyGarrisons.db.global.Garrisons[k].Shipments [CharacterHeaders[k].Timers[k2].ID].ReadyShipments.."/"..(MyGarrisons.db.global.Garrisons[k].Shipments [CharacterHeaders[k].Timers[k2].ID].PendingShipments + MyGarrisons.db.global.Garrisons[k].Shipments [CharacterHeaders[k].Timers[k2].ID].ReadyShipments).."("..MyGarrisons.db.global.Garrisons[k].Shipments [CharacterHeaders[k].Timers[k2].ID].TotalShipments..")"
					CharacterHeaders[k].Timers[k2].Frame.nameframe.namestring:SetText(NeoMessage)
					local NoneLeft = false
					
					local shipsLeft =  floor(remaining/MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].ShipmentDuration)
					if MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].PendingShipments ~= nil then
						if shipsLeft +1 < MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].PendingShipments then
							MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].ReadyShipments = (MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].ReadyShipments) +
							MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].PendingShipments - (shipsLeft +1)
							MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].PendingShipments = shipsLeft +1
						end
					end
					if MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].PendingShipments ~= nil then
						if remaining < 0 then
							CharacterHeaders[k].Timers[k2].Frame.timertext:SetText("Done  "..MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].ReadyShipments.."/"..(MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].PendingShipments + MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].ReadyShipments).."("..MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].TotalShipments..")" )
						else
							CharacterHeaders[k].Timers[k2].Frame.timertext:SetText(MyGarrisons:ConvertSecondsToTime(remaining).."  "..MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].ReadyShipments.."/"..(MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].PendingShipments + MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].ReadyShipments).."("..MyGarrisons.db.global.Garrisons[charname].Shipments [CharacterHeaders[k].Timers[k2].ID].TotalShipments..")" )
						end
					end
		
		--			MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments[buildingName] = {
		--	ReadyShipments = shipmentsReady,
		--	TotalShipments = shipmentTotal,
		--	StartTime = Meta.__tostring(caldate:parse(date("%m_%d_%y/%H:%M:%S"))),
		--	ShipmentTimeLeft = MyGarrisons:buildingTimeToSeconds(TimeLeftOnShipment),
		--	ShipmentDuration = duration,
	--		EndTimer  = Meta.__tostring(d2),
		--	PendingShipments = shipmentsPending
				end
			end
		end
		end
	end
	
end

function MyGarrisons:OnInitialize()
		-- Called when the addon is loaded

		-- Print a message to the chat frame
	self.db = LibStub("AceDB-3.0"):New("GAR", defaults)

	-- Hooks
	self:SecureHook(C_Garrison,"AddFollowerToMission","FollowerToMission")
	self:SecureHook(C_Garrison,"AssignFollowerToBuilding","FollowerToBuilding")
	self:SecureHook(C_Garrison,"RemoveFollowerFromBuilding","FollowerFromBuilding")
	self:SecureHook(C_Garrison,"UpgradeBuilding","UPGRADEBUILD")
	self:SecureHook(C_Garrison,"CancelConstruction","CANCELCONS")
	self:SecureHook(C_Garrison,"PlaceBuilding","PLACEBUILD")
	self:SecureHook(C_Garrison,"RemoveFollowerFromMission","RemoveFollowerMission")
	self:SecureHook(C_Garrison,"StartMission","StartGMission")
	self:SecureHook(C_Garrison,"MarkMissionComplete","MarkMissionCompleteHandler")
	
	
	--self:SecureHook(GarrisonMissionComplete,"OnMissionComplete", "NeoMissionComplete")
	--C_Garrison.CancelConstruction
--C_Garrison.PlaceBuilding
	--Register event  GARRISON_MISSION_COMPLETED
	
	self:RegisterEvent("GARRISON_MISSION_COMPLETED")
	self:RegisterEvent("GARRISON_MISSION_NPC_OPENED")
	self:RegisterEvent("GARRISON_BUILDING_REMOVED")
	self:RegisterEvent("GARRISON_BUILDING_ACTIVATED")
	self:RegisterEvent("SHIPMENT_CRAFTER_CLOSED")
	self:RegisterEvent("GARRISON_LANDINGPAGE_SHIPMENTS")
	--SHIPMENT_CRAFTER_INFO
	self:RegisterEvent("SHIPMENT_UPDATE")
	self:RegisterEvent("SHIPMENT_CRAFTER_INFO")
	
	local registry = LibStub("AceConfigRegistry-3.0")
	registry:RegisterOptionsTable("MyGarrisonsMain", main)
	
	local dialog = LibStub("AceConfigDialog-3.0")
	self.optionFrames = {
	main = dialog:AddToBlizOptions("MyGarrisonsMain", "MyGarrisons")
	
	}
	
	local nam, realmi = UnitName("player")
	
	if MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()] == nil then
		MyGarrisons:AddCharacter (nam, GetRealmName())
	end
	-- UI Set up.
	--MyGarrisonTimers.timerscroll
	--characterScrollContent
	characterScrollContent = CreateFrame("Frame", "CharacterScroll", GarrisonBuildings.charScroll)
	characterScrollContent:SetSize(128, 28)
	characterScrollContent:SetPoint("TOPLEFT", GarrisonBuildings.charScroll,10,-60 )
	characterScrollContent:Show()
		
	GarrisonBuildings.charScroll.characterScrollContent = characterScrollContent
 
	GarrisonBuildings.charScroll:SetScrollChild(characterScrollContent)
	
	
	garrisonBuildingScrollChild= CreateFrame("Frame", "GBScroll", GarrisonBuildings.garrbuildscroll)
	garrisonBuildingScrollChild:SetSize(278,250)
	garrisonBuildingScrollChild:SetPoint("TOPLEFT", GarrisonBuildings.garrbuildscroll,10,-60 )
	garrisonBuildingScrollChild:Show()
	
	GarrisonBuildings.garrisonBuildingScrollChild = garrisonBuildingScrollChild
 
	GarrisonBuildings.garrbuildscroll:SetScrollChild(garrisonBuildingScrollChild)
	
	
	GarrisonScrollContent = CreateFrame("Frame", "GarrisonScroll", MyGarrisonTimers.timerscroll)
	GarrisonScrollContent:SetSize(128, 28)
	GarrisonScrollContent:SetPoint("TOPLEFT", MyGarrisonTimers.timerscroll,10,-60 )
	GarrisonScrollContent:Show()
		
	MyGarrisonTimers.timerscroll.GarrisonScrollContent = GarrisonScrollContent
 
	MyGarrisonTimers.timerscroll:SetScrollChild(GarrisonScrollContent)
	
	local d2 = caldate:parse( "29_2_2000/10:52:44" )
	
	checkTimer = MyGarrisons:ScheduleRepeatingTimer("TimerCheckFunc", 1 )

	MyGarrisons:BuildRealmOptionPanel()
	MyGarrisons:ScanGarrison()
	
	MyGarrisons:FillCharacters()
	if MyGarrisons.db.global.Settings.HideTimerFrameOnStart then
		MyGarrisonTimers:Hide();
	else
		MyGarrisonTimers:Show();
	end
	
	MyGarrisons:FillFollowersEmpty()
	MyGarrisons:FillGarrisonBuildings()
	for k,v in pairs (MyGarrisons.db.global.Garrisons) do
	
	MyGarrisons:AddCharacterToGBRealmList (k)
	end
	MyGarrisons:SetUpCharacterProperties()
	MyGarrisons:FillGBBuildingUI()
	MyGarrisons:HideAllBuildings()
	MyGarrisons:SetUpGBTimerFrame()
	--MyGarrisons:SetBuildingListForCharacter(nam.."-"..GetRealmName())
end

function MyGarrisons:FollowerToBuilding(plotInstanceID,followerID)
	--print(plotInstanceID)
	--print(followerID)
	local nam, realmi = UnitName("player")
	--print(C_Garrison.GetFollowerInfo(followerID))
	--print(MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Followers[followerID])
	MyGarrisons:AddFollowerToBuilding(nam, GetRealmName(), plotInstanceID, followerID)
end
--FollowerFromBuilding
function MyGarrisons:FollowerFromBuilding(plotInstanceID,followerID)
	--print(plotInstanceID)
	--print(followerID) -- nil
	local nam, realmi = UnitName("player")
	
	MyGarrisons:RemoveFollowerToBuilding(nam, GetRealmName(), plotInstanceID)
	--MyGarrisons.db.global.Garrisons[nam.."-"..].Buildings[k].Follower
	MyGarrisons:HideAllBuildings()
end
function MyGarrisons:FillGBBuildingUI()
	for x = 1, 11 do

		local x2 = x
		GBBuildingUI[x] = {Used = false, ID = 0,
		Texture = nil,
		Frame = CreateFrame("Frame", "BuildingFrame",garrisonBuildingScrollChild,"BuildingFrame")
		}
		if x == 1 then
			GBBuildingUI[x].Frame:SetPoint("TOPLEFT",garrisonBuildingScrollChild,"TOPLEFT")
		
		else
			GBBuildingUI[x].Frame:SetPoint("TOPLEFT",GBBuildingUI[x-1].Frame,"BOTTOMLEFT" )
		end
		--TODO  Add setting for background for building list element.
		--GBBuildingUI[x].Texture = GBBuildingUI[x].Frame:CreateTexture("tes","BACKGROUND")
		--	GBBuildingUI[x].Texture:SetAllPoints()
			--GBBuildingUI[x].Texture:SetAtlas("Garr_InfoBox-BackgroundTile");
	
	end

end
function MyGarrisons:POrotoSnyc()
	--print("D")

end
function MyGarrisons:HideAllBuildings()
	for k,v in pairs (GBBuildingUI) do
		GBBuildingUI[k].Used = false
		GBBuildingUI[k].ID = 0
		GBBuildingUI[k].Frame:Hide()
	end
end
function MyGarrisons:SetBuildingListForCharacter(charname)
	for k,v in pairs (GBBuildingUI) do
		GBBuildingUI[k].Used = false
		GBBuildingUI[k].ID = 0
		GBBuildingUI[k].Frame:Hide()
	end
	for k,v in pairs (MyGarrisons.db.global.Garrisons[charname].Buildings) do
		GBBuildingUI[k].Used = true
		GBBuildingUI[k].ID =MyGarrisons.db.global.Garrisons[charname].Buildings[k].ID
		--/run for k,v in pairs({C_Garrison.GetBuildingInfo(25)}) do if k == 12 then for k2,v2 in pairs(v) do print(k2.." "..tostring(v2)) end  else print(k.." "..tostring(v)) end end
		--local buildTab = {C_Garrison.GetBuildingInfo(GBBuildingUI[k].ID)}
		GBBuildingUI[k].Frame.buildingname:SetText(MyGarrisons.db.global.Garrisons[charname].Buildings[k].BuildingName)
		GBBuildingUI[k].Frame.buildinglevel:SetText("Level "..MyGarrisons.db.global.Garrisons[charname].Buildings[k].Level)
		--local valos = {C_Garrison.GetBuildingInfo(MyGarrisons.db.global.Garrisons[charname].Buildings[k].buildingID)}
		--MyGarrisons.db.global.Garrisons[charname].Buildings[k].BuildingID
		--GBBuildingUI[k].Frame.buildingicon:SetAtlas(valos[3])
		
		GBBuildingUI[k].Frame.buildingicon:SetTexture(MyGarrisons.db.global.Garrisons[charname].Buildings[k].Icon)

		--SetPortraitTexture(GBFollowerUI[currentFrame].Frame.followerportrait.Portrait,v.DisplayID)
		if MyGarrisons.db.global.Garrisons[charname].Buildings[k].Follower~= nil then
			
			local follIndex = MyGarrisons.db.global.Garrisons[charname].Buildings[k].Follower
				
			if MyGarrisons.db.global.Garrisons[charname].Followers[follIndex] ~= nil then
				SetPortraitTexture(GBBuildingUI[k].Frame.followerframe.Portrait,MyGarrisons.db.global.Garrisons[charname].Followers[follIndex].DisplayID)
				local color = ITEM_QUALITY_COLORS[MyGarrisons.db.global.Garrisons[charname].Followers[follIndex].Quality]
				
				GBBuildingUI[k].Frame.followerframe.PortraitRingQuality:SetVertexColor(color.r, color.g, color.b);
				GBBuildingUI[k].Frame.followerframe.Level:SetText(MyGarrisons.db.global.Garrisons[charname].Followers[follIndex].Level);
			
				GBBuildingUI[k].Frame.followerframe.LevelBorder:SetVertexColor(color.r, color.g, color.b);
			else
		
				local color = ITEM_QUALITY_COLORS[1]
				GBBuildingUI[k].Frame.followerframe.PortraitRingQuality:SetVertexColor(color.r, color.g, color.b);
				GBBuildingUI[k].Frame.followerframe.Level:SetText("95");
				GBBuildingUI[k].Frame.followerframe.LevelBorder:SetVertexColor(color.r, color.g, color.b);
				SetPortraitTexture(GBBuildingUI[k].Frame.followerframe.Portrait,"GarrMission_PortraitRing_Empty")
			end
		else
		
			local color = ITEM_QUALITY_COLORS[1]
			
			GBBuildingUI[k].Frame.followerframe.PortraitRingQuality:SetVertexColor(color.r, color.g, color.b);
			GBBuildingUI[k].Frame.followerframe.Level:SetText("95");
			GBBuildingUI[k].Frame.followerframe.LevelBorder:SetVertexColor(color.r, color.g, color.b);
			SetPortraitTexture(GBBuildingUI[k].Frame.followerframe.Portrait,"GarrMission_PortraitRing_Empty")

		end
		GBBuildingUI[k].Frame:Show()
	end


end


function MyGarrisons:StartReSizing()
MyGarrisonTimers.timerscroll:StartSizing()
MyGarrisonTimers:StartSizing()
end
function MyGarrisons:StopReSizing()
MyGarrisonTimers.timerscroll:StopMovingOrSizing()
MyGarrisonTimers:StopMovingOrSizing()
--self:StartSizing()
end
function MyGarrisons:OnEnable()
		-- Called when the addon is enabled

		-- Print a message to the chat frame

end

function MyGarrisons:OnDisable()
		-- Called when the addon is disabled
		
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
local upgradesDetected = {}
function MyGarrisons:GetPlotsBuilding(plotID)
	local nam, realmi = UnitName("player")
	for k,v in pairs(MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Constructions)do
		if MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Constructions[k].PlotID == plotID then
			return k
		end
	end

end
function MyGarrisons:UPGRADEBUILD(plotID)
MyGarrisons:ScanGarrison()
	upgradesDetected[plotID] = true
	local buildingID =  0
	for k,v in pairs(C_Garrison.GetBuildings()) do
		if v.plotID == plotID then
			buildingID = v.buildingID
		end
	end

	local buildingInfo = {C_Garrison.GetBuildingInfo(buildingID)};
	local timeStr = buildingInfo[9];
	--print(MyGarrisons:buildingTimeToSeconds(timeStr))
	--TODO:  Add building to list
	local nam, realmi = UnitName("player")
	MyGarrisons:AddConstruction(nam, GetRealmName(), plotID, buildingID)
	MyGarrisons:AddCharacterTimer(nam.."-"..GetRealmName(), "Building", buildingID)
	if GBSelectedNameRealm ==nam.."-"..GetRealmName() then
			
			MyGarrisons:ClearGBTimers()
			MyGarrisons:FillGBForCharacter()
		end
end

function MyGarrisons:CANCELCONS(plotID)
	local nam, realmi = UnitName("player")

	MyGarrisons:ScanGarrison()
	local bid = MyGarrisons:GetPlotsBuilding(plotID)

				MyGarrisons:UnuseCharacterTimer(nam.."-"..GetRealmName(), "Building", bid)
				MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Constructions[ bid] = nil
				
	
end
function MyGarrisons:GARRISON_LANDINGPAGE_SHIPMENTS ()
	MyGarrisons:ShipmentScan()

end
function MyGarrisons:AddShipment(buildingName, shipmentTotal, shipmentsPending, shipmentsReady, startTime, duration, TimeLeftOnShipment)

local nam, realmi = UnitName("player")
	if MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments == nil then
		MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments = {}
	end
--	print("Adding/Updating shipment for "..buildingName.. " "..shipmentsPending.."/"..shipmentsReady.."  "..shipmentTotal.." | "..startTime.." _ " ..duration.." :: "..MyGarrisons:buildingTimeToSeconds(TimeLeftOnShipment))


	local d2 = caldate:parse( date("%m_%d_%y/%H:%M:%S"))
	
	--local buildingInfo = {C_Garrison.GetBuildingInfo(buildingID)};
	--local timeStr = buildingInfo[10];
	
		--local missionTimeString = C_Garrison.GetMissionTimes(missionID)
		--print(strfind(C_Garrison.GetMissionTimes(missionID),missionTimeStringPattern))
		--print(strfind(C_Garrison.GetMissionTimes(missionID),"%d*%s?%l*%s?%d*%s?%l* (%d+) %l* %d*%s?%l*%s?%d*%s?%l* (%d+) %l*"))
		--local start, endS, num1, num2 = strfind(missionTimeString, missionTimeStringPattern)
	--	local a = {C_Garrison.GetMissionTimes(missionID)}
	--	local totalSeconds = tonumber(a[2]) + tonumber(a[5])
	--	d2.second = d2.second + totalSeconds
	
	--TODO compute end time.
	
	local SecondsForOtherPendings = (shipmentsPending-1)*duration
	local TotalSeconds = SecondsForOtherPendings + MyGarrisons:buildingTimeToSeconds(TimeLeftOnShipment)
d2.second = d2.second +(TotalSeconds)
		MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Shipments[buildingName] = {
			ReadyShipments = shipmentsReady,
			TotalShipments = shipmentTotal,
			StartTime =  Meta.__tostring((startTime)),
			ShipmentTimeLeft = MyGarrisons:buildingTimeToSeconds(TimeLeftOnShipment),
			ShipmentDuration = duration,
		EndTimer  = Meta.__tostring(d2),
			PendingShipments = shipmentsPending
		
		}
		--TODO
		MyGarrisons:AddCharacterTimer(nam.."-"..GetRealmName(), "Shipment", buildingName)
end
function MyGarrisons:ShipmentScan()
local ShipmentsFound = {}
local shipmentIndex = 1;
    local buildings = C_Garrison.GetBuildings();
    for i = 1, #buildings do
        local buildingID = buildings[i].buildingID;
        if ( buildingID ) then
            local name, texture, MaxShipments, ReadyShipments, pendings, StartTime, Duration, TimeLeftString, itemIcon, itemQuality, itemID = C_Garrison.GetLandingPageShipmentInfo(buildingID);
           
            if ( name ) then
				if StartTime ~= nil and Duration ~= nil then
		
				StartTime = caldate:parse( date("%m_%d_%y/%H:%M:%S"))
				--StartTime  = caldate:parse( date("%m_%d_%y/%H:%M:%S")).second +(Duration - MyGarrisons:buildingTimeToSeconds(TimeLeftString))
				--	print(StartTime )
					--:new( year, month, day, hour, minute, second )
				
				--print("SCANNER "..name.." "..shipmentsReady.." "..shipmentsTotal.."  "..pendings.."  "..  duration.."  "..timeleftString)
				MyGarrisons:AddShipment(name, MaxShipments, pendings, ReadyShipments,  caldate:parse( date("%m_%d_%y/%H:%M:%S")), Duration, TimeLeftString)
				else
				
				end
			end
		end
		end
end
function MyGarrisons:PLACEBUILD(plotInstanceID, buildingID)

	--upgradesDetected[plotInstanceID] = true
	--TO GET TIME STRING
	local buildingInfo = {C_Garrison.GetBuildingInfo(buildingID)};
	for i =1, MyGarrisons:TableSize(buildingInfo) do
	--	print(i.."  "..buildingInfo[i])
	end
	local timeStr = buildingInfo[10];
	--print(MyGarrisons:buildingTimeToSeconds(timeStr))
	--TODO:  Add building to list
	local nam, realmi = UnitName("player")
	MyGarrisons:AddConstruction(nam, GetRealmName(), plotInstanceID, buildingID)
	MyGarrisons:AddCharacterTimer(nam.."-"..GetRealmName(), "Building", buildingID)
	if GBSelectedNameRealm ==nam.."-"..GetRealmName() then
			
			MyGarrisons:ClearGBTimers()
			MyGarrisons:FillGBForCharacter()
		end
	
	--TODO:  Add building timer
end
function MyGarrisons:GARRISON_BUILDING_ACTIVATED(en, plotID, num2)
MyGarrisons:ScanGarrison()
local nam, realmi = UnitName("player")
local buildID = MyGarrisons:GetPlotsBuilding(plotID)

	if MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Constructions[buildID] ~= nil then

--
		MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Constructions[buildID] = nil
		--TODO remove mission UI
		MyGarrisons:UnuseCharacterTimer(nam.."-"..GetRealmName(), "Building", buildID)
		if GBSelectedNameRealm ==nam.."-"..GetRealmName() then
			
			MyGarrisons:ClearGBTimers()
			MyGarrisons:FillGBForCharacter()
		end

	end
end
function MyGarrisons:GARRISON_BUILDING_REMOVED(en, plotID, num2)
MyGarrisons:ScanGarrison()
	if upgradesDetected[plotID] ~= true then

		local nam, realmi = UnitName("player")
		MyGarrisons:UnuseCharacterTimer(nam.."-"..GetRealmName(), "Building", num2)
		if GBSelectedNameRealm ==nam.."-"..GetRealmName() then

			MyGarrisons:ClearGBTimers()
			MyGarrisons:FillGBForCharacter()
		end
		MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Constructions[ num2] = nil
	end
	upgradesDetected[plotID] = false
end	
function MyGarrisons:SHIPMENT_CRAFTER_INFO(eventName, par1, par2, par3, par4)

if par1 ~= nil then
	--print(par1)
	--print(par2)
	--print(par3)
	--print(par4)
	end

end
function MyGarrisons:SHIPMENT_CRAFTER_CLOSED()
self:ScheduleTimer("ShipmentScan", 5)
	--MyGarrisons:ShipmentScan()
	--print("Update")
	--print(par1)
	--print(par2)
	--print(par3)
	
		--MyGarrisons:ShipmentScan()
	

end

function MyGarrisons:SHIPMENT_UPDATE(eventName, par1, par2, par3)
	MyGarrisons:ShipmentScan()
	if par1 ~= nil then
	--print("Update")
	--print(par1)
	--print(par2)
	--print(par3)
	
		local buildings = C_Garrison.GetBuildings();
		for i = 1, #buildings do
			local buildingID = buildings[i].buildingID;
			if ( buildingID ) then
				local name, texture, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, itemName, itemIcon, itemQuality, itemID = C_Garrison.GetLandingPageShipmentInfo(buildingID);
				if shipmentsTotal ~= nil and name ~= nil then
				--	print(name.."  "..shipmentsReady.." "..shipmentsTotal.." "..creationTime.." "..duration.." "..timeleftString)
				end
			end
		end
	end

end
function MyGarrisons:NeoMissionComplete(par1, par2, par3,par4)
print(par1)
	print(par2)
	print(par3)
	print(par4)

end
function MyGarrisons:MarkMissionCompleteHandler(par1, par2, par3, par4, par5)
	MyGarrisons:GARRISON_MISSION_COMPLETED("GARRISON_MISSION_COMPLETED", par1, "")

end
function MyGarrisons:GARRISON_MISSION_COMPLETED(eventName, missionID, bonus)
	
	local nam, realmi = UnitName("player")
	if MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Missions[missionID] ~= nil then

		MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Missions[missionID] = nil
		--TODO remove mission UI
		MyGarrisons:UnuseCharacterTimer(nam.."-"..GetRealmName(), "Mission", missionID)
		if GBSelectedNameRealm ==nam.."-"..GetRealmName() then
			--print("REFILL")
			MyGarrisons:ClearGBTimers()
			MyGarrisons:FillGBForCharacter()
		end
	end
	MyGarrisons:ScanFollowers()
	if currentSelectedLogFrame == 2 and nam.."-"..GetRealmName() == charname then
		MyGarrisons:SetUpFollowersForChar(charname)

	end

end
function MyGarrisons:GetFollowersAbilities(followerID)
local nam, realmi = UnitName("player")
local counter = 1
local tcounter = 1
	for x2,y2 in pairs (C_Garrison.GetFollowerAbilities(followerID)) do
		
			--print(x3.." "..tostring(y3))
			--description
			--counter table
			--id
			--name
			--isTrait
			--icon
			---------
			if y2.isTrait == false then
			 MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Followers[followerID].Abilities[counter] ={
																									Icon = y2.icon,
																									Name = y2.name,
																									Desc = y2.description,
																									ID = y2.id,
																									IsTrait = y2.isTrait
			 }
			 
			 counter = counter + 1
			 else
			  MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Followers[followerID].Traits[tcounter] ={
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
function MyGarrisons:ScanFollowers()
	local nam, realmi = UnitName("player")
	--/run for k,v in pairs(C_Garrison.GetFollowers())do if v.garrFollowerID ~= nil then strs = "" for k2,v2 in pairs (v) do  strs = strs .. (k2 .." = " ..tostring(v2).." | ")   end print (strs) end end
	for k,v in pairs(C_Garrison.GetFollowers())do 
		if v.garrFollowerID ~= nil then
			 MyGarrisons.db.global.Garrisons[nam.."-"..GetRealmName()].Followers[v.followerID] = {
				Class = v.className,
				iLevel = v.iLevel,
				Name = v.name,
				DisplayID = v.displayID,
				Level = v.level,
				XP = v.xp,
				LevelXP = v.levelXP,
				Quality = v.quality,
				Abilities = {},
				Traits = {}
			 }
			MyGarrisons:GetFollowersAbilities(v.followerID)
			 for x2,y2 in pairs (C_Garrison.GetFollowerAbilities(v.followerID)) do
				for x3, y3 in pairs(y2) do
				--	print(x3.." "..tostring(y3))
				end
			 end
			 
			-- print(str)
			--print(v.garrFollowerID)
		--	print("==============")
		end
	end
	

end
function MyGarrisons:GARRISON_MISSION_NPC_OPENED(event, ele1)
	local nam, realmi = UnitName("player")
	MyGarrisons:ScanFollowers()
	if currentSelectedLogFrame == 2 and nam.."-"..GetRealmName() == charname then
		MyGarrisons:SetUpFollowersForChar(charname)
	end
	
	--currentSelectedLogFrame = 2;
	--currentSelectedCharacter = charname

end

function MyGarrisons:splitAtFirst(str, pattern)

	local startIndex, endIndex = strfind(str,pattern)
	if startIndex ~= nil then
		return strsub(str,0,  startIndex-1), strsub(str, startIndex+strlen(pattern))
	end
	return str
end
function MyGarrisons:TableSize(tab)
	count = 0
	for key, val in pairs (tab) do
		count = count +1
	end
	return count
end


--local d3 = date:parse( "01.10.1582 11:11:11" )
--print(Meta.__sub( d3, date:now() ))
