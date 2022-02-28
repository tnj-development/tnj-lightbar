local lightbarCars = {}
local lightbarCars2 = {}

RegisterNetEvent('addLightbar', function(hostVehPlate, lightbarNetworkID, hvp)
	local source = source
	for k,v in pairs(lightbarCars) do 
		if v["LP"] == hostVehPlate then
			table.insert(v.lights, lightbarNetworkID)
			return
		end
	end
	table.insert(lightbarCars, {["hostVehiclePointer"] = hvp, ["LP"] = hostVehPlate, ["lights"] = {lightbarNetworkID}, ["lightStatus"] = false, ["sirenStatus"] = false} )
end)			

RegisterNetEvent('toggleLights', function(hostVehPlate)
	local source = source
	local veh = nil
	for k,v in pairs(lightbarCars) do 
		if v["LP"] == hostVehPlate then
			TriggerClientEvent("clientToggleLights", source, v.lights, v.lightStatus, v.hostVehiclePointer) 
			v.lightStatus = not v.lightStatus
		end
	end
end)

RegisterNetEvent("ToggleSound1Server", function(plate)
	local source = source
	local toggle = nil
	for k,v in pairs(lightbarCars) do 
		if v["LP"] == plate then
			toggle = not v.sirenStatus
			v.sirenStatus = toggle
			TriggerClientEvent("sound1Client", -1, source, toggle)
		end
	end
end)

RegisterNetEvent('returnLightBarVehiclePlates', function()
	local source = source
	local plates = {}
	for k,v in pairs(lightbarCars) do 
		table.insert(plates, v.LP)
	end
	TriggerClientEvent("sendLightBarVehiclePlates", source, plates) 
end)

RegisterNetEvent('returnLightbarsForMainVeh', function(mainVehPlate)
	local source = source
	local plates = {}
	for k,v in pairs(lightbarCars) do 
		if v.LP == mainVehPlate then
			plates = v.lights
			lightbarCars[k] = nil
		end
	end
	TriggerClientEvent("updateLightbarArray", source, plates) 
end)

function removeKey(key)
	lightbarCars[key] = nil
end

function removeAllFromTable(mainVehPlate)
	for k,v in pairs(lightbarCars) do 
		if v.LP == mainVehPlate then
			table.remove(k)
			return
		end
	end
end