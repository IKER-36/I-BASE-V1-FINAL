ESX = nil

local food = 0
local thirst = 0

Citizen.CreateThread(function()
  while ESX == nil do 
    TriggerEvent('esx:getSharedObject', function(obj)
      ESX = obj 
    end)
    Wait(0)
  end
end)

RegisterNetEvent("esx_status:onTick")
AddEventHandler("esx_status:onTick", function(status)
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        food = status.val / 10000
    end)
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        thirst = status.val / 10000
    end)
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)

      HideHudComponentThisFrame(3)
      HideHudComponentThisFrame(4)
      HideHudComponentThisFrame(13)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(400)

    local ply = PlayerPedId()
    local sPly = PlayerId()

    TriggerEvent("esx_status:onTick")
  
    ESX.TriggerServerCallback('aq_hud:getAccounts', function(label, grade, cash, bank, dirty)
      SendNUIMessage({
        type = 'update',
        values = {
          isShowing = not IsPauseMenuActive(),
          id = GetPlayerServerId(sPly),
          name = GetPlayerName(sPly),
          health = GetEntityHealth(ply) - 100,
          armor = GetPedArmour(ply),
          hunger = food,
          thirst = thirst,
          isTalking = NetworkIsPlayerTalking(sPly),
          label = label,
          grade = grade,
          cash = comma_value(cash),
          bank = comma_value(bank),
          dirty = comma_value(dirty),
        }
      })
    end)
  end
end)

function comma_value(amount)
  local formatted = amount
  
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    
    if k == 0 then
      break
    end
  end
  
  return formatted
end
