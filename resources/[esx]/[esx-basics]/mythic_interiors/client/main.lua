function DespawnInterior(objects, cb)
    Citizen.CreateThread(function()
        for k, v in pairs(objects) do
            if DoesEntityExist(v) then
                DeleteEntity(v)
            end
        end

        cb()
    end)
end

function TeleportToInterior(x, y, z, h)
    Citizen.CreateThread(function()
        DoScreenFadeOut(500)
        TriggerServerEvent('mythic_sounds:server:PlayOnSource', 'door_open', 0.1)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end

        SetEntityCoords(PlayerPedId(), x, y, z, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), h)

        Citizen.Wait(100)

        DoScreenFadeIn(1000)
    end)
end

function getRotation(input)
    return 360 / (10 * input)
end