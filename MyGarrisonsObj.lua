MGBuilding = {}
MGBuilding._index = MGBuilding

function MGBuilding.create()
	local bui = {}
	setmetatable(bui,MGBuilding)
	bui.BuildingID = 0;
	bui.Follower = 0;
	bui.PlotId = 0
	bui.Special = {}
	bui.Constructing = false;
	bui.Shipments = {Max = 0, Pending = 0, Done = 0, Start = {Day = 0, Month =0, Year = 0, Hour = 0, Minute = 0}}
	return bui
end
function MGBuilding:AddShipment ()

end
------------------------------------------------------------------------------------------------------
MyGarrisonObject = {}
MyGarrisonObject.__index = MyGarrisonObject

function MyGarrisonObject.create()
	
   local garr = {}             -- our new object
   setmetatable(garr,MyGarrisonObject)  -- make Account handle lookup
   garr.buildings = {};
	garr.followers = {};
	garr.missions = {};

   return garr
end

function MyGarrisonObject:AddBuilding(id)



end
function MyGarrisonObject:UpgradeBuilding()


end

function MyGarrisonObject:RemoveBuilding()


end

function MyGarrisonObject:SwapBuilding()


end

function MyGarrisonObject:AddFollowerToBuilding()


end

function MyGarrisonObject:RemoveFollowerFromBuilding()


end



