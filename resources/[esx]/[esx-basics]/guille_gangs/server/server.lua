ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 



for _,v in pairs(Config.Gangs) do
    print("Gang Active: ^2" .. v.gangsociety .. "^0 Gang name: ^2" .. v.name .. "^0" )
    TriggerEvent('esx_society:registerSociety', v.name, v.name, v.gangsociety, v.gangsociety, v.gangsociety, {type = 'public'})
end

RegisterNetEvent('guille_gangs:societycheck')
AddEventHandler('guille_gangs:societycheck', function(job)
    xPlayer = ESX.GetPlayerFromId(source)
    for _,v in pairs (Config.Gangs) do
        if xPlayer.job.name == v.name then
            TriggerClientEvent("guille_gangs:bossactions", source, job)
        end
    end
end)
            
RegisterCommand('gangmessage', function(source, args)

    xPlayer = ESX.GetPlayerFromId(source)
    xPlayers = ESX.GetPlayers()
    local gang = args[1]
    if xPlayer.getGroup() == 'admin' then
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == args[1] and CheckGangs(xPlayer) then
                table.remove(args, 1)
                TriggerClientEvent('esx:showNotification', xPlayers[i], table.concat(args, " "))
                print(gang)
                TriggerClientEvent('guille_gangs:reglog', xPlayers[i], "gangmsg", gang, table.concat(args, " "))
            end
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Insufficcient perms')
    end
end, false)

RegisterCommand('addgangmission', function(source, args)

    xPlayer = ESX.GetPlayerFromId(source)
    local id = math.random(1,9999)
    if xPlayer.getGroup() == 'admin' then
        local gang = args[1]
        print(gang)
        MySQL.Async.execute('INSERT INTO gangmissions (gang, keyid) VALUES (@gang, @keyid)', {
            ["@gang"] = gang,
            ["@keyid"] = id,
        })
        table.remove(args, 1)
        print(table.concat(args, " "))
        Wait(500)
        MySQL.Async.execute("UPDATE gangmissions SET mission = @mission WHERE keyid = @keyid", {
            ["@mission"] = table.concat(args, " "),
            ["@keyid"] = id,
        })
        TriggerClientEvent('esx:showNotification', source, 'Added mission: ' .. table.concat(args, " ") .. '')
    end
end, false)

RegisterCommand('deletegangmission', function(source, args)

    xPlayer = ESX.GetPlayerFromId(source)

    local id = args[1]

    MySQL.Async.execute('DELETE FROM gangmissions WHERE keyid = @keyid', {
        ["@keyid"] = id,
    })

    TriggerClientEvent('esx:showNotification', source, 'Succefully deleted gang with id: ' .. id)

end, false)


ESX.RegisterServerCallback('getmissions', function(source,cb) 
    xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'admin' then
        MySQL.Async.fetchAll("SELECT * FROM gangmissions", {}, function(result)
            local missions = {}
            if result[1] ~= nil then
                for i = 1, #result, 1 do
                    Citizen.Wait(5)
                    table.insert(missions, { ["keyid"] = result[i]["keyid"], ["gang"] = result[i]["gang"], ["mission"] = result[i]["mission"] })
                end
            end
            Citizen.Wait(500)
            cb(missions)
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'No perms')
    end
end)


    

function CheckGangs(xPlayer) 
    for _,v in pairs(Config.Gangs) do
        if xPlayer.job.name == v.Job then
            return true
        else
            return false
        end
    end
end

function sendToDiscord(webhook, name, message, color)
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Gang-System",
                ["icon_url"] = "https://i.ibb.co/GdpN9Zh/Wack.png",
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "guillerp", embeds = connect, avatar_url = "https://i.ibb.co/GdpN9Zh/Wack.png"}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('guille_gangs:sendlog')
AddEventHandler('guille_gangs:sendlog', function(type, var, var2)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier(source)
    local name = GetPlayerName(source)
    local gang = xPlayer.job.name
    
    print("test")
    print(gang)
    print(var)
    if type == 'cardel' then
        sendToDiscord(Configw.Webhook, "Car delete", "**User: **"..name.."\n"..identifier.. "\n**Car:** ".. var .. "\n**Gang: **" .. gang .. "", 65280)
    elseif type == 'society' then
        sendToDiscord(Configw.Webhook, "Society menu opened", "**User: **"..name.."\n"..identifier.. "\n**Gang:** ".. var .. "", 65280)
    elseif type == 'carspawn' then
        sendToDiscord(Configw.Webhook, "Car spawned", "**User: **"..name.."\n"..identifier.. "\n**Car:** ".. var .. "\n**Gang: **" .. gang .. "", 65280)
    elseif type == 'gangmsg' then
        sendToDiscord(Configw.Webhook, "Message to a gang", "**User: **"..name.."\n"..identifier.. "\n**Gang: ** ".. var .. "\n**Message: **" .. var2 .. "", 65280)
    elseif type == 'stock' then
        sendToDiscord(Configw.Webhook, "Stock menu", "**User: **"..name.."\n"..identifier.. "\n**Gang: ** ".. gang .. "\n**Stock menu opened**", 65280)
    elseif type == 'weapons' then
        sendToDiscord(Configw.Webhook, "Stock menu", "**User: **"..name.."\n"..identifier.. "\n**Gang: ** ".. gang .. "\n**Weapons menu opened**", 65280)
    end
end)


ESX.RegisterServerCallback('guille_gangs:getPlayerInventory', function(source, cb)
	xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory


	cb({items = items, weapons = xPlayer.getLoadout()})
end)

ESX.RegisterServerCallback('guille_gangs:getStockItems', function(source, cb)
    xPlayer = ESX.GetPlayerFromId(source)
    local gang = xPlayer.job.name

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. gang, function(inventory)
        cb(inventory.items)
	end)

    --cb(inventory.items)

    
end)

ESX.RegisterServerCallback('guille_gangs:getWeapons', function(source, cb)
    xPlayer = ESX.GetPlayerFromId(source)
    local gang = xPlayer.job.name
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'.. gang .. '', function(store)
		local weapons = store.get('weapons')
		if weapons == nil then
			weapons = {}
		end
		cb(weapons)
	end)
end)

RegisterServerEvent('guille_gangs:putStockItems')
AddEventHandler('guille_gangs:putStockItems', function(type, itemName, count)
	local xPlayer = nil
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(source)
		Wait(10)
	end
    local gang = xPlayer.job.name

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'.. gang ..'', function(inventory)
			local item = inventory.getItem(itemName)
			local playerItemCount = xPlayer.getInventoryItem(itemName).count

			if item.count >= 0 and count <= playerItemCount then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
			else
				TriggerClientEvent('esx:showNotification', source, 'invalid_quantity')
			end

			TriggerClientEvent('esx:showNotification', source, ('Deposited item: ' .. count .. '' ..item.label.. ''))
		end)

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(itemName).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(itemName, count)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'.. gang ..'', function(account)
			end)
		else
			TriggerClientEvent('esx:showNotification', source, 'amount_invalid')
		end

	elseif type == 'item_weapon' then

		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'.. gang ..'', function(store)
			local storeWeapons = store.get('weapons') or {}

			table.insert(storeWeapons, {
				name = itemName,
				ammo = count
			})

			store.set('weapons', storeWeapons)
			xPlayer.removeWeapon(itemName)
		end)
    end

end)

RegisterNetEvent('guille_gangs:getStockItem')
AddEventHandler('guille_gangs:getStockItem', function(itemName, count)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local gang = xPlayer.job.name

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. gang .. '', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then

			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification('Withdrawn item: ' .. count .. '' ..inventoryItem.label.. '')
			else
				xPlayer.showNotification('Invalid quantity')
			end
		else
			xPlayer.showNotification('Invalid quantity')
		end
	end)
end)

ESX.RegisterServerCallback('guille_gangs:removeweapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local gang = xPlayer.job.name
    print('society_'.. gang .. '')
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_'.. gang .. '', function(store)
        local storeWeapons = store.get('weapons') or {}
        local ammo = nil
        for i=1, #storeWeapons, 1 do
            
            if storeWeapons[i].name == weaponName  then
                weaponName = storeWeapons[i].name
                ammo       = storeWeapons[i].ammo
                print(storeWeapons[i].ammo)
                table.remove(storeWeapons, i)
                break
            end
        end

        store.set('weapons', storeWeapons)
        xPlayer.addWeapon('' .. weaponName .. '', ammo)
    end)
end)

ESX.RegisterServerCallback('guille_gangs:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

	if notify then
		xPlayer.showNotification("You are being searched")
	end
    print("test")
	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}
        data.dob = xPlayer.get('dateofbirth')
        data.height = xPlayer.get('height')

        if xPlayer.get('sex') == 'm' then data.sex = 'male' else data.sex = 'female' end

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = ESX.Math.Round(status.percent)
			end

            TriggerEvent('esx_license:getLicenses', target, function(licenses)
                data.licenses = licenses
                cb(data)
            end)
		end)
	end
end)

RegisterServerEvent('guille_gangs:handcuff')
AddEventHandler('guille_gangs:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
    print(target)
    if target == 0 then
        TriggerClientEvent('esx:showNotification', source, 'No players nerby')
	else
        TriggerClientEvent('esx_policejob:handcuff', target)
    end
end)

RegisterServerEvent('guille_gangs:outfromveh')
AddEventHandler('guille_gangs:outfromveh', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    print(target)
    if target == 0 then
        TriggerClientEvent('esx:showNotification', source, 'No players nerby')
    else
        TriggerClientEvent('esx_policejob:OutVehicle', target)
    end
end)


RegisterServerEvent('guille_gangs:putinvehicle')
AddEventHandler('guille_gangs:putinvehicle', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if target == 0 then
        TriggerClientEvent('esx:showNotification', source, 'No players nerby')
    else
        TriggerClientEvent('esx_policejob:putInVehicle', target)
    end
end)

RegisterServerEvent('guille_gangs:escort')
AddEventHandler('guille_gangs:escort', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if target == 0 then
        TriggerClientEvent('esx:showNotification', source, 'No players nerby')
    else
        TriggerClientEvent('esx_policejob:drag', target, source)
    end
end)
