
ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('core_logohud:getInfo', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.getJob().label,xPlayer.getMoney(),xPlayer.getAccount('bank').money, GetNumPlayerIndices()  )

end)