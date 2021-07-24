local vehicle = nil
local isDriver = false
local fTractionLossMult = nil
local isModed = false
local class = nil
local isBlacklisted = false

local classMod = {
    [0]= 2.51, -- Compacts 
    [1] = 2.51, --Sedans
    [2] = 1.01, --SUVs
    [3] = 2.51, --Coupes
    [4] = 2.501, --Muscle
    [5] = 2.51, --Sports Classics
    [6] = 2.51, --Sports
    [7] = 2.51, --Super  
    [8] = 1.51, --Motorcycles  
    [9] = 0, --Off-road
    [10] = 0, --Industrial
    [11] = 0, --Utility
    [12] = 2.21, --Vans  
    [13] = 0, --Cycles  
    [14] = 0, --Boats  
    [15] = 0, --Helicopters  
    [16] = 0, --Planes  
    [17] = 0, --Service  
    [18] = 2.21, --Emergency  
    [19] = 0, --Military  
    [20] = 2.21, --Commercial  
    [21] = 0 --Trains  
}

local blackListed = {
    788045382, --"sanchez"
    -1453280962,--"sanchez2"
    1753414259, --"enduro"
     2035069708,--"esskey"
     86520421,--"bf400"
     -488123221,--"predator"
     -1536924937,--"policeold1"
     -1647941228,--"fbi2"
     353883353,--"polmav"
     469291905,--"lguard"
     1475773103, --Rumpo3
     1977528411, --Scoutpol
     1570619963, --ktm policia
     610904671,  -- insurgency
	 -561505450, --scpd4
	-1286617882, --scpd5
	 -271532569, --scpd7
     -879194100, --umkscout	
}

Citizen.CreateThread(function()
    while true do 
        local ped = GetPlayerPed(-1)      
        if IsPedInAnyVehicle(ped, false) then
            if vehicle == nil then
                vehicle = GetVehiclePedIsUsing(ped)
                if GetPedInVehicleSeat(vehicle, -1) == ped then
                    isDriver = true
                    if DecorExistOn(vehicle, 'fTractionLossMult') then
                        fTractionLossMult = DecorGetFloat(vehicle, 'fTractionLossMult')
                        --print("Existe valor por defecto: "..fTractionLossMult)
                    else
                        fTractionLossMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionLossMult')
                        DecorRegister('fTractionLossMult', 1)
                        DecorSetFloat(vehicle,'fTractionLossMult', fTractionLossMult)
                        --print("Se crea valor por defecto: "..fTractionLossMult)
                    end
                    class = GetVehicleClass(vehicle)
                    isBlacklisted = isModelBlacklisted(GetEntityModel(vehicle))
                end
            end
        else
            if vehicle ~= nil then
                if DoesEntityExist(vehicle) then
                    setTractionLost (fTractionLossMult)
                end
                Citizen.Wait(1000)
                vehicle = nil
                isDriver = false
                fTractionLossMult = nil
                isModed = false
                class = nil
                isBlacklisted = false
            end
        end
        Citizen.Wait(2000)
    end
end)

Citizen.CreateThread(function()
    while true do 
        if isBlacklisted == false then     
            if vehicle ~= nil and isDriver == true  then
                local speed = GetEntitySpeed(vehicle)*3.6
                if not pointingRoad(vehicle) then
                    if groundAsphalt() or speed <= 35.0 then
                        if isModed == true then
                            isModed = false
                            setTractionLost (fTractionLossMult)
                        end
                    else
                        if isModed == false and speed > 35.0 then
                            isModed = true
                            setTractionLost (fTractionLossMult + classMod[class])
                        end
                    end
                else
                    if isModed == true then
                        isModed = false
                        setTractionLost (fTractionLossMult)
                    end
                end
            end
        end
        Citizen.Wait(500)
    end
end)

function setTractionLost (value)
    if isBlacklisted == false and vehicle ~= nil and value ~= nil then
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionLossMult', value)
        print("fTractionLossMult: "..value)
    end
end

function isModelBlacklisted(model)
    local found = false
    for i = 1, #blackListed do
        if blackListed[i] == model then
            found = true
            break
        end
    end
    return found
end

function groundAsphalt()
    local ped = PlayerPedId()

    local playerCoord = GetEntityCoords(ped)
    local target = GetOffsetFromEntityInWorldCoords(ped, vector3(0,2,-3))
    local testRay = StartShapeTestRay(playerCoord, target, 17, ped, 7) -- This 7 is entirely cargo cult. No idea what it does.
    local _, hit, hitLocation, surfaceNormal, material, _ = GetShapeTestResultEx(testRay)

    if hit then
        --print (material)
        if material == 282940568 then
            return true
        else
            return false
        end
    else
        return false
    end
end

function pointingRoad(veh)
    local pos = GetEntityCoords(veh, true)
    if IsPointOnRoad(pos.x,pos.y,pos.z-1,false) then
        return true
    end 
    local pos2 = GetOffsetFromEntityInWorldCoords(veh, 1.5, 0, 0)
    local pos3 = GetOffsetFromEntityInWorldCoords(veh, -1.5, 0, 0)
    if IsPointOnRoad(pos2.x,pos2.y,pos2.z-1,false) then
        return true
    end
    if IsPointOnRoad(pos3.x,pos3.y,pos3.z,false) then 
        return true
    end
    return false
end
