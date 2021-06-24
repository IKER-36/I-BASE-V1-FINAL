local loaded = false

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        loaded = true
        Citizen.Wait(1000)
        SendNUIMessage(
            {
                type = "toggle",
                value = true
            }
        )
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)

            if loaded and not IsPauseMenuActive() then
                ESX.TriggerServerCallback(
                    "core_logohud:getInfo",
                    function(job, money, bank, online)
                        SendNUIMessage(
                            {
                                type = "update",
                                online = online or 0,
                                id = GetPlayerServerId(PlayerId()) or 0,
                                money = ("$" .. money) or "0",
                                bank = ("$" .. bank) or "0",
                                job = string.upper(job) or ""
                            }
                        )
                    end
                )
            else
                SendNUIMessage(
                    {
                        type = "toggle",
                        value = false
                    }
                )
            end
        end
    end
)
