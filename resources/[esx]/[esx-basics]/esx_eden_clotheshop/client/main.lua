ESX = nil
local GUI, CurrentActionData = {}, {}
GUI.Time = 0
local LastZone, CurrentAction, CurrentActionMsg
local HasPayed, HasLoadCloth, HasAlreadyEnteredMarker = false, false, false

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenShopMenu()
  local elements = {}

  table.insert(elements, {label = _U('shop_clothes'),  value = 'shop_clothes'})
  table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})
  table.insert(elements, {label = _U('suppr_cloth'), value = 'suppr_cloth'})

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
      title    = _U('shop_main_menu'),
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
	menu.close()

      if data.current.value == 'shop_clothes' then
			HasPayed = false

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title = _U('valid_this_purchase'),
				align = 'top-left',
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			}, function(data, menu)

				menu.close()

				if data.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_eden_clotheshop:checkMoney', function(hasEnoughMoney)

						if hasEnoughMoney then

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							TriggerServerEvent('esx_eden_clotheshop:pay')

							HasPayed = true

							ESX.TriggerServerCallback('esx_eden_clotheshop:checkPropertyDataStore', function(foundStore)

								if foundStore then

									ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing', {
											title = _U('save_in_dressing'),
											align = 'top-left',
											elements = {
												{label = _U('yes'), value = 'yes'},
												{label = _U('no'),  value = 'no'},
											}
										}, function(data2, menu2)

											menu2.close()

											if data2.current.value == 'yes' then

												ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
														title = _U('name_outfit'),
													}, function(data3, menu3)

														menu3.close()

														TriggerEvent('skinchanger:getSkin', function(skin)
															TriggerServerEvent('esx_eden_clotheshop:saveOutfit', data3.value, skin)
														end)

														ESX.ShowNotification(_U('saved_outfit'))

													end, function(data3, menu3)
														menu3.close()
													end)
											end
										end)
								end
							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))
						end
					end)
				end

				if data.current.value == 'no' then

					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}

			end, function(data, menu)

				menu.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}

			end)
	end, function(data, menu)

			menu.close()

			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}

	end, {
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
		'chain_1',
		'chain_2',
		'helmet_1',
		'helmet_2',
		'glasses_1',
		'glasses_2',
		'bags_1',
		'bags_2',
	})
      end

      if data.current.value == 'player_dressing' then
		
        ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)
          local elements = {}

          for i=1, #dressing, 1 do
            table.insert(elements, {label = dressing[i], value = i})
          end

          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
              title    = _U('player_clothes'),
              align    = 'top-left',
              elements = elements,
            }, function(data, menu)

              TriggerEvent('skinchanger:getSkin', function(skin)

                ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerOutfit', function(clothes)

                  TriggerEvent('skinchanger:loadClothes', skin, clothes)
                  TriggerEvent('esx_skin:setLastSkin', skin)

                  TriggerEvent('skinchanger:getSkin', function(skin)
                    TriggerServerEvent('esx_skin:save', skin)
                  end)
				  
				  ESX.ShowNotification(_U('loaded_outfit'))
				  HasLoadCloth = true
                end, data.current.value)
              end)
            end, function(data, menu)
              menu.close()
			  
			  CurrentAction     = 'shop_menu'
			  CurrentActionMsg  = _U('press_menu')
			  CurrentActionData = {}
            end
          )
        end)
      end
	  
	  if data.current.value == 'suppr_cloth' then
		ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)
			local elements = {}

			for i=1, #dressing, 1 do
				table.insert(elements, {label = dressing[i], value = i})
			end
			
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'supprime_cloth', {
              title    = _U('suppr_cloth'),
              align    = 'top-left',
              elements = elements,
            }, function(data, menu)
			menu.close()
				TriggerServerEvent('esx_eden_clotheshop:deleteOutfit', data.current.value)
				  
				ESX.ShowNotification(_U('supprimed_cloth'))

            end, function(data, menu)
              menu.close()
			  
			  CurrentAction     = 'shop_menu'
			  CurrentActionMsg  = _U('press_menu')
			  CurrentActionData = {}
            end)
		end)
	  end
    end, function(data, menu)

      menu.close()

      CurrentAction     = 'room_menu'
      CurrentActionMsg  = _U('press_menu')
      CurrentActionData = {}
    end)
end

AddEventHandler('esx_eden_clotheshop:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {}
end)

AddEventHandler('esx_eden_clotheshop:hasExitedMarker', function(zone)
	
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil

	if not HasPayed then
		if not HasLoadCloth then 

			TriggerEvent('esx_skin:getLastSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()

	for i=1, #Config.Shops, 1 do

		local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

		SetBlipSprite (blip, 73)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 47)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('clothes'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_eden_clotheshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_eden_clotheshop:hasExitedMarker', LastZone)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 300 then

				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		end
	end
end)
