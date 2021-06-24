ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = ESX.Math.Round(price)
	if price > 0 then
		xPlayer.removeMoney(amount)
	end
end)


RegisterServerEvent('dps_fuel:comprarBidon')
AddEventHandler('dps_fuel:comprarBidon', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.addWeapon("WEAPON_PETROLCAN", 4500)

end)

ESX.RegisterServerCallback('dps_fuel:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()
	cb(money >= Config.RefillCost, money)
end)