ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('aq_hud:getAccounts', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local job = xPlayer.getJob()

  cb(job.label, job.grade_label, xPlayer.getMoney(), xPlayer.getAccount("bank").money, xPlayer.getAccount("black_money").money)
end)
