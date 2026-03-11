--localization file for english/United States
local L = LibStub("AceLocale-3.0"):NewLocale("MyGarrisons", "enUS", true)
if ( not L ) then 
    return;
end




-- Command Line Strings
-- -- Show Timers Command
L["CMD_TIMERS"] = "Show timers"
L["CMD_TIMERS_DESC"] = "Shows the garrison timers."

-- -- Show Garrison Database/Record/Log Command
L["CMD_LOG"] = ""
L["CMD_LOG_DESC"] = ""

-- -- Clear Database Command
L["CMD_CLEAR"] = "Clear"
L["CMD_CLEAR_DESC"] = "Clears ALL of the characters in the database."


-- Interface Strings


-- -- MyGarrisonTimers Strings


-- -- -- Follower Strings

L["FOLLOWER_ABILITIES"] = "Abilities"
L["FOLLOWER_TRAITS"] = "Traits"
L["FOLLOWER_NAME"] = "Name"
L["FOLLOWER_CLASS"] = "Class"
L["FOLLOWER_GEAR"] = "Gear"
L["FOLLOWER_EXP"] = "EXP"


-- -- -- Building Strings

L["BUILDING_LEVEL"] = ""
L["BUILDING_ASSIGNED_FOLLOWER"] = ""
