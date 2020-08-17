VEHICLES = {
--example:
--vehicledisplayname - {up = extra#, down = extra#}
pd1 = {up = 5, down = 6}, 
pd2 = {up = 5, down = 6}
}

local KEYCOMBO1 = 326  -- set to nil to disable  DEFAULT: LEFT CTRL
local KEYCOMBO2 = 99   -- set to nil to disable  DEFAULT: X on Controller OR SCROLL WHEEL UP  OR TAB 
local KEY = 74		   -- DEFAULT: H / R-DPAD headlight key

local ped = nil
local inVehicle = false

-- SLOW ISPEDINVEHICLE CALLS INCREASE EFFICENCY -- 
Citizen.CreateThread(function()
	while true do
		ped = GetPlayerPed(PlayerId())
		inVehicle = IsPedInAnyVehicle(ped, true)
		Citizen.Wait(500)
	end
end)

-- DISABLE HEADLIGHT SWITCH WHILE KEYCOMBO IS DEPRESSED -- 
Citizen.CreateThread(function()
	while true do
		if IsControlPressed(0, KEYCOMBO1) or IsControlPressed(0, KEYCOMBO2) then 
			DisableControlAction(0, KEY, true) 
		end
		Citizen.Wait(0)
	end
end)

-- CHANGE VEHICLE EXTRAS -- 
Citizen.CreateThread(function()
	local vehid = nil
	local vehName = nil
	local toggle = false
    while true do
        if inVehicle then
			if IsDisabledControlJustPressed(0,KEY) and (IsControlPressed(0, KEYCOMBO1) or IsControlPressed(0, KEYCOMBO2)) then
				vehid = GetVehiclePedIsUsing(ped)
				vehName = GetDisplayNameFromVehicleModel(GetEntityModel(vehid))
				if ped == GetPedInVehicleSeat(vehid, -1) or ped == GetPedInVehicleSeat(vehid, 0) then
					if IsPoliceVehicle(vehName) then
						if toggle then
							SetVehicleExtra(vehid, VEHICLES[vehName].down, false)		--removes down facing
							SetVehicleExtra(vehid, VEHICLES[vehName].up, true)			--add up facing							
						else
							SetVehicleExtra(vehid, VEHICLES[vehName].up, false)			--removes up facing
							SetVehicleExtra(vehid, VEHICLES[vehName].down, true)		--add down facing								
						end
						toggle = not toggle
						Citizen.Wait(500)
					end
				end
			end
		end
		Citizen.Wait(0)
	end
end)


-- IS VEHICLE IN TABLE -- 
function IsPoliceVehicle(veh)
	if VEHICLES[veh] ~= nil then 
		return true
	else
		return false
	end
end
