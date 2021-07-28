-- Vars --

local users_cache = {}
local jobs = {}
local MySQL_Ready = false
ESX = nil
CachedPlayers = {}
players = {}
-- Vars --

-- Server functions --


function loadJobs ()
    if string.lower(Config.CheckJobType) == "sql" then
        local jobs_name_sql = MySQL.Sync.fetchAll("SELECT * FROM jobs")
        local jobs_grades_sql = MySQL.Sync.fetchAll("SELECT * FROM job_grades")

        for job in pairs(jobs_name_sql) do
            local grades = {}
            
            local job_name = jobs_name_sql[job]["name"]

            for grade in pairs(jobs_grades_sql) do
                local grade_job_name = jobs_grades_sql[grade]["job_name"]
                local grade_job = jobs_grades_sql[grade]["grade"]

                if grade_job_name == job_name then
                    table.insert(grades, grade_job)
                end
            end

            table.insert(jobs, {["job"] = job_name, ["grades"] = grades})
        end
    end
end

function getTime ()
    return os.time(os.date("!*t"))
end

function array2string(array)
    string = ""
    for a in pairs(array) do
        string = string .. " " .. tostring(array[a])
    end

    return string
end

function dateFromTimestamp (timestamp)
    return os.date("%Y-%m-%d %H:%M:%S", timestamp)
end

function ArrayLength (table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count

end

function inArray (target, table)
    for a,b in ipairs(table) do
        if target == b then
            return true
        end
    end

    return false

end

function getIdentifier (id)
    return GetPlayerIdentifiers(id)[1]
end

function getLicense (id)
    return GetPlayerIdentifiers(id)[2]
end

function getIpAddress(id)
    return GetPlayerEndpoint(id)
end

function getName(id)
    local name = GetPlayerName(id)
    return name
end

function getGroup (id) 
    if id == Groups.Server then
        return id
    end

    local player_steamid = getIdentifier(id)
    local group = nil

    for a, b in pairs(users_cache) do
        if a == player_steamid then
            group = b
            break
        end
    end 

    if group ~= nil then
        return group
    end

    local mysql_query = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier=@identifier", {["@identifier"] = player_steamid})
    local user_query = mysql_query[1]

    if user_query == nil then
        return "user"
    else 
        group = user_query["group"]
    end

    if group == nil then
        return "user"
    end

    users_cache[player_steamid] = group

    return group
end

function isBan (license)
    
    local isban_mysql = MySQL.Sync.fetchAll("SELECT * FROM kc_bans WHERE license = @license", {["@license"] = license})

    if not MySQL_Ready then
        return {true, Lang.MySQL}
    end

    if ArrayLength(isban_mysql) == 0 then
        return {false}
    end

    for ban in pairs(isban_mysql) do
        local mysql_reason = isban_mysql[ban]["reason"]
        local mysql_admin_name = isban_mysql[ban]["admin_name"]
        local mysql_time = isban_mysql[ban]["time"]

        if mysql_time == "permanent" then
            local reason = string.format(Lang.PermaBan, mysql_reason, mysql_admin_name)
            return {true, reason}
        else
            mysql_time = tonumber(mysql_time)
            if getTime() < mysql_time then
                local date_time = dateFromTimestamp(mysql_time)
                local reason = string.format(Lang.BannedFor, mysql_reason, date_time, mysql_admin_name)
                return {true, reason}
            end
        end

    end

    return {false}

end

function lowerGroup (local_group, target_group)
    local local_group_level = Groups.Levels[local_group]
    local target_group_level = Groups.Levels[target_group]

    if local_group_level == target_group_level then
        return false
    end

    if local_group_level <= target_group_level then
        return true
    end

    return false

end

function checkJob (job, grade)
    if string.lower(Config.CheckJobType) == "sql" then
        for i in pairs(jobs) do
            if jobs[i]["job"] == job then
                if inArray(tonumber(grade), jobs[i]["grades"]) then
                    return true
                end
            end
        end
        return false
    elseif string.lower(Config.CheckJobType) == "esx" then
        return ESX.DoesJobExist(job, grade)
    end

    return true

end

function getJob (id)
    local identifier = getIdentifier(id)

    local job_sql = MySQL.Sync.fetchAll("SELECT job, job_grade FROM users WHERE identifier = @identifier", {["@identifier"] = identifier})

    if ArrayLength(job_sql) <= 0 then
        return nil
    end

    return job_sql[1]

end

function defaultJob (id)
    local identifier = getIdentifier(id)

    print("^1" .. Lang.FixJob .. identifier .. "^0.")

    MySQL.Async.execute("UPDATE users SET job = @job, job_grade = @grade WHERE identifier = @identifier", {["@job"] = Config.DefaultJob[1], ["@grade"] = Config.DefaultJob[2], ["@identifier"] = identifier}, function (rows)
        if rows ~= 1 then
            print("^1No se pudo cambiar el trabajo de " .. identifier .. "^0.")
        end
    end)

end

-- Server functions --

-- ESX thread --

ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 


-- ESX thread --

-- Infinity Players --

ESX.RegisterServerCallback('kc_admin:getPlayers', function(source,cb) 
    local plys = GetPlayers()
    players = {}
    local xAll = ESX.GetPlayers()
    for i=1, #xAll, 1 do
        local xPlayer = ESX.GetPlayerFromId(xAll[i])
        table.insert( players,{id = xPlayer.source, name = xPlayer.getName()} ) 
    end
    cb(players)
end)

-- Infinity Players


-- Server Events --

RegisterServerEvent("kc_admin:global_message")
AddEventHandler("kc_admin:global_message", function (security_code, message)
    TriggerClientEvent("kc_admin:send_message", -1, message)
end)

RegisterServerEvent("kc_admin:remote_group")
AddEventHandler("kc_admin:remote_group", function (id, callback)
    local group = getGroup(id)
    callback(group)
end)

AddEventHandler("playerConnecting", function (user, setKickReason, deferrals)
    local Source = source

    deferrals.defer()

    deferrals.update("Revisando baneos...")

    local player_license = getLicense(Source)
    local bans = isBan(player_license)

    if bans[1] then
        deferrals.done(bans[2])
        CancelEvent()
        return
    end

    local job = getJob(Source)

    if job ~= nil then

        local job_name = job["job"]
        local grade = job["job_grade"]

        if string.lower(Config.CheckJobType) == "sql" then
    
            if not checkJob(job_name, grade) then
                defaultJob(Source)
            end
    
        elseif string.lower(Config.CheckJobType) == "esx" then
            if ESX.DoesJobExist(job_name, grade) then
                defaultJob(Source)
            end
        end

    end

    deferrals.done()

end)

AddEventHandler("esx:playerLoaded", function (Source, user)
    local user_identifier = getIdentifier(Source)
    local user_license = getLicense(Source)

    TriggerClientEvent("kc_admin:get_group", Source, user.getGroup())

    users_cache[user_identifier] = user.getGroup()

end)

RegisterServerEvent("kc_admin:get_bans")
AddEventHandler("kc_admin:get_bans", function (days, name)
    local Source = source

    if not inArray(getGroup(Source), Permissions.GetBans) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    local filter = {false, false}

    name = string.lower(name)

    if days ~= '' then
        days = days * 24 * 60 * 60
        filter[1] = true
    end

    if name ~= '' then
        filter[2] = true
    end

    local bans = MySQL.Sync.fetchAll("SELECT * FROM kc_bans", {})

    local filtered_bans = {}

    for ban in pairs(bans) do
        local ban_obj = bans[ban]

        local user = ban_obj["name"]
        local admin_name = ban_obj["admin_name"]
        local reason = ban_obj["reason"]
        local time = ban_obj["time"]
        local date = ban_obj["date"]

        if filter[1] then
            if math.floor(getTime() - days) < tonumber(date) then
                table.insert(filtered_bans, ban_obj)
            end
        end

        if filter[2] then
            local low_name = string.lower(user)

            if string.find(low_name, name) ~= nil then
                table.insert(filtered_bans, ban_obj)
            end
        end

        if filter[1] == false and filter[2] == false then
            table.insert(filtered_bans, ban_obj)
        end

    end

    filtered_bans = json.encode(filtered_bans)

    TriggerClientEvent("kc_admin:recv_bans", Source, filtered_bans)

end)

RegisterServerEvent("kc_admin:set_group")
AddEventHandler("kc_admin:set_group", function (mod_source, target_id, group)
    local Source = source

    if Source ~= "" then
        mod_source = Source
    end

    local local_group = getGroup(mod_source)
    local player_steamid = getIdentifier(target_id)

    if not inArray(local_group, Permissions.Group) then
        TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", mod_source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    if lowerGroup(group, local_group) then
        -- TriggerEvent("es:setPlayerData", tonumber(target_id), "group", group, function(response, success)
            -- if success then
                targetPlayer = ESX.GetPlayerFromId(tonumber(target_id))
                targetPlayer.setGroup(group)
                if mod_source ~= Groups.Server then
                    users_cache[player_steamid] = group
                    TriggerClientEvent("kc_admin:get_group", target_id, group)
                    TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Success, Lang.Group, "success")
                    TriggerClientEvent("kc_admin:send_message", target_id, Lang.GroupUpgraded .. group)
                end
            -- else
                -- if mod_source ~= Groups.Server then
                    -- TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.GroupError, "danger")
                -- end
            -- end
        -- end)
    else
        TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", mod_source, "^1" .. Lang.InsufficientPrivileges)
    end

end)

RegisterServerEvent("kc_admin:set_job")
AddEventHandler("kc_admin:set_job", function (target_id, job_name, job_grade)
    local Source = source

    if not inArray(getGroup(Source), Permissions.Jobs) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    if ESX ~= nil then
        local xPlayer = ESX.GetPlayerFromId(target_id)

        if xPlayer ~= nil then
            
            if Config.CheckJobExist then
                if ESX.DoesJobExist(job_name, job_grade) then
                    xPlayer.setJob(job_name, job_grade)
                    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Job .. job_name, "success")
                else
                    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.JobFail, "danger")
                end
            else
                xPlayer.setJob(job_name, job_grade)
                TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Job .. job_name, "success")
            end

        else
            TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.ESX, "danger")
        end
    else
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.ESX, "danger")
    end

end)

RegisterServerEvent("kc_admin:set_money")
AddEventHandler("kc_admin:set_money", function (target_id, money_amount, money_type)
    local Source = source

    if not inArray(getGroup(Source), Permissions.Money) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    if ESX ~= nil then
        local xPlayer = ESX.GetPlayerFromId(target_id)
        if xPlayer ~= nil then
            if money_type == "cash" then
                xPlayer.setMoney(money_amount)
                TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Money .. money_type, "success")
            else
                xPlayer.setAccountMoney(money_type, money_amount)
                TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Money .. money_type, "success")
            end
        else
            TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.ESX, "danger")
        end
    else
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.ESX, "danger")
    end

end)

RegisterServerEvent("kc_admin:check_jail")
AddEventHandler("kc_admin:check_jail", function()
    local Source = source

    Citizen.Wait(2000)

    local user_license = getLicense(Source)

    local mysql_jails = MySQL.Sync.fetchAll("SELECT * FROM kc_jails WHERE license = @license", {["@license"] = user_license})

    if ArrayLength(mysql_jails) ~= 0 then
        local time = mysql_jails[1]["time_s"]
        local id = mysql_jails[1]["id"]
        local result = MySQL.Sync.execute("UPDATE users SET time = @time WHERE id = @id", {["@time"] = getTime() + time, ["@id"] = id})
        time = tonumber(time)
        TriggerClientEvent("kc_admin:jail_player", Source, time)
    end

end)

RegisterServerEvent("kc_admin:unjail")
AddEventHandler("kc_admin:unjail", function (target_id, force)
    local Source = source

    local user_license = getLicense(target_id)

    if force then
        if inArray(getGroup(Source), Permissions.UnJail) then
            MySQL.Async.execute("DELETE FROM kc_jails WHERE license = @license", {["@license"] = user_license}, function (rows)
                if rows == 1 then
                    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.UnJail, "success")
                    TriggerClientEvent("kc_admin:unjail_player", target_id)
                else
                    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.UnJailError, "danger")
                end
            end)
            CancelEvent()
            return
        end
    end

    local jail_time_sql = MySQL.Sync.fetchAll("SELECT time FROM kc_jails WHERE license = @license", {["@license"] = user_license})


    if jail_time_sql[1] == nil then
        CancelEvent()
        return
    end 

    local jail_time = jail_time_sql[1]["time"]

    jail_time = tonumber(jail_time)

    if getTime() >= jail_time then
        local unjail_sql = MySQL.Sync.execute("DELETE FROM kc_jails WHERE license = @license", {["@license"] = user_license})
        TriggerClientEvent("kc_admin:unjail_player", target_id)
    end

end)

RegisterServerEvent("kc_admin:jail")
AddEventHandler("kc_admin:jail", function (target_id, time)
    local Source = source

    local local_group = getGroup(Source)
    local target_group = getGroup(target_id)

    if not inArray(local_group, Permissions.Jail) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    if lowerGroup(local_group, target_group) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    local user_name = getName(target_id)
    local user_license = getLicense(target_id)

    local admin_name = getName(Source)
    local admin_identifier = getIdentifier(Source)

    local time_m = tostring(time)
    local time = time * 60
    local timestamp = getTime() + time

    MySQL.Async.execute("INSERT INTO kc_jails (license, name, admin_name, admin_identifier, time, time_s) VALUES (@license, @name, @admin_name, @admin_identifier, @timestamp, @time)", {["@license"] = user_license, ["@name"] = user_name, ["@admin_name"] = admin_name, ["@admin_identifier"] = admin_identifier, ["@timestamp"] = timestamp, ["@time"] = time}, function(rows)
        if rows == 1 then
            TriggerClientEvent("kc_admin:jail_player", target_id, time)
            TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Jail, "success")
            TriggerEvent("kc_admin:global_message", Config.SecurityCode, string.format(Lang.Global.PlayerJailed, user_name, time_m))
        else
            TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.JailError, "danger")
        end
    end)

end)

RegisterServerEvent("kc_admin:freeze")
AddEventHandler("kc_admin:freeze", function (target_id)
    local Source = source

    if not inArray(getGroup(Source), Permissions.Freeze) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    TriggerClientEvent("kc_admin:freeze_player", target_id)
    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Freeze, "success")

end)

RegisterServerEvent("kc_admin:revive")
AddEventHandler("kc_admin:revive", function (target_id)
    local Source = source

    if not inArray(getGroup(Source), Permissions.Revive) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    TriggerClientEvent("kc_admin:revive_player", target_id)
    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.ReviveN, "success")

end)

RegisterServerEvent("kc_admin:slay")
AddEventHandler("kc_admin:slay", function (target_id)
    local Source = source
    
    if not inArray(getGroup(Source), Permissions.Slay) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    TriggerClientEvent("kc_admin:slay_player", target_id)
    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Slay, "success")

end)

RegisterServerEvent("kc_admin:visibility")
AddEventHandler("kc_admin:visibility", function (target_id)
    local Source = source

    if not inArray(getGroup(Source), Permissions.Visibility) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    TriggerClientEvent("kc_admin:visibility_player", target_id)
    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Visibility, "success")

end)

RegisterServerEvent("kc_admin:noclip")
AddEventHandler("kc_admin:noclip", function (target_id)
    local Source = source

    if not inArray(getGroup(Source), Permissions.Noclip) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    TriggerClientEvent("kc_admin:noclip_player", target_id)
    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Noclip, "success")

end)

RegisterServerEvent("kc_admin:return")
AddEventHandler("kc_admin:return", function (target_id)
    local Source = source

    local admin_name = getName(Source)

    if not inArray(getGroup(Source), Permissions.Return) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    TriggerClientEvent("kc_admin:return_player", target_id)
    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Return, "success")
    TriggerClientEvent("kc_admin:send_message", target_id, "^2" .. admin_name .. "^0" .. Lang.ReturnPlayer)

end)

RegisterServerEvent("kc_admin:goto")
AddEventHandler("kc_admin:goto", function (target_id, target_coords)
    local Source = source

    local admin_name = getName(Source)
    local user_name = getName(target_id)

    if not inArray(getGroup(Source), Permissions.Goto) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    TriggerClientEvent("kc_admin:send_message", target_id, "^2" .. admin_name .. "^0" .. Lang.Goto)
    TriggerClientEvent("kc_admin:teleport_player", Source, target_coords)
    TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.GotoN .. user_name, "success")

end)

RegisterServerEvent("kc_admin:bring")
AddEventHandler("kc_admin:bring", function(admin_coords, target_id)
    local Source = source

    local admin_name = getName(Source)

    if not inArray(getGroup(Source), Permissions.Bring) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    TriggerClientEvent("kc_admin:teleport_player", target_id, admin_coords)
    TriggerClientEvent("kc_admin:send_message", target_id, Lang.Bringed .. "^2" .. admin_name)

end)

RegisterServerEvent("kc_admin:delete_ban")
AddEventHandler("kc_admin:delete_ban", function (mod_source, id, license)
    local Source = source

    if Source ~= "" then
        mod_source = Source
    end

    if not inArray(getGroup(mod_source), Permissions.Ban) then
        TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", mod_source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    MySQL.Async.execute("DELETE FROM kc_bans WHERE id=@id AND license=@license", {["@id"] = id, ["@license"] = license}, function (rows)
        if rows == 1 then
            if mod_source ~= Groups.Server then
                TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Success, Lang.UnBan, "success")
            end
        else

            if mod_source ~= Groups.Server then
                TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.UnBanError, "danger")
            end

        end
    end)

end)

RegisterServerEvent("kc_admin:kick")
AddEventHandler("kc_admin:kick", function (mod_source, target_id, reason)
    local Source = source

    if Source ~= "" then
        mod_source = Source
    end

    local target_group = getGroup(target_id)
    local local_group = getGroup(mod_source)
    local target_name = getName(target_id)

    if mod_source == Groups.Server then
        local admin_name = Groups.Server
    else
        local admin_name = getName(mod_source)
    end

    if not inArray(local_group, Permissions.Kick) then
        TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", mod_source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    if lowerGroup(local_group, target_group) then
        TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", mod_source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    DropPlayer(target_id, reason)

    if mod_source ~= Groups.Server then
        TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.Kicked .. target_name, "success")
    end

end)

RegisterServerEvent("kc_admin:ban")
AddEventHandler("kc_admin:ban", function (mod_source, target_id, reason, time)
    local Source = source

    if Source ~= "" then
        mod_source = Source
    end

    if not inArray(getGroup(mod_source), Permissions.Ban) then
        TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", mod_source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    local target_group = getGroup(target_id)
    local local_group = getGroup(mod_source)

    if lowerGroup(local_group, target_group) then
        TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", mod_source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    local user_name = getName(target_id)
    local user_identifier = getIdentifier(target_id)
    local user_license = getLicense(target_id)
    local user_ip = getIpAddress(target_id)
    local date = getTime()

    local admin_name
    local admin_identifier

    if mod_source == Groups.Server then
        admin_name = "Server"
        admin_identifier = "Server"
    else
        admin_name = getName(mod_source)
        admin_identifier = getIdentifier(mod_source)
    end

    local reason_

    if time == "permanent" then
        reason_ = string.format(Lang.PermaBan, reason, admin_name)
    else
        time = getTime() + time
        reason_ = string.format(Lang.BannedFor, reason, dateFromTimestamp(time), admin_name)
    end

    MySQL.Async.execute("INSERT INTO kc_bans (identifier, license, reason, name, ip, admin_name, admin_identifier, time, date) VALUES(@identifier, @license, @reason, @name, @ip, @admin_name, @admin_identifier, @time, @date)", {["@identifier"] = user_identifier, ["@license"] = user_license, ["@reason"] = reason, ["@name"] = user_name, ["@ip"] = user_ip, ["@admin_name"] = admin_name, ["@admin_identifier"] = admin_identifier, ["@time"] = time, ["@date"] = date}, function(rows)
        if rows == 1 then
            if mod_source ~= Groups.Server then
                TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Success, Lang.BannedSuccessfully, "success")
            end
            TriggerClientEvent("kc_admin:send_message", target_id, "^1" .. Lang.Banned .. ".")
            Citizen.Wait(1000)
            TriggerEvent("kc_admin:set_group", Groups.Server, target_id, "user")
            TriggerEvent("kc_admin:kick", Groups.Server, target_id, Lang.Banned)

            TriggerEvent("kc_admin:global_message", -1, string.format(Lang.Global.PlayerBanned, user_name, reason))
        else
            if mod_source ~= Groups.Server then
                TriggerClientEvent("kc_admin:send_notify", mod_source, Lang.Error, Lang.BanError, "danger")
            end
        end
    end)


end)

RegisterServerEvent("kc_admin:reload_groups")
AddEventHandler("kc_admin:reload_groups", function ()
    users_cache = {}
    TriggerClientEvent("kc_admin:order_group", -1)
end)

RegisterServerEvent("kc_admin:request_group")
AddEventHandler("kc_admin:request_group", function ()
    local Source = source

    local group = getGroup(Source)
    local player_steamid = getIdentifier(Source)

    users_cache[player_steamid] = group

    TriggerClientEvent("kc_admin:get_group", Source, group)
end)

RegisterServerEvent("kc_admin:delete_warn")
AddEventHandler("kc_admin:delete_warn", function (warn_id)
    local Source = source

    if not inArray(getGroup(Source), Permissions.DeleteWarn) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
    end

    MySQL.Async.execute("DELETE FROM kc_warns WHERE id = @warn_id", {["warn_id"] = warn_id}, function(rows)
        if rows == 1 then
            TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.WarnDeleted .. getName(Source), "success")
        else
            TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.WarnDeletedError, "danger")
        end
    end)

end)

RegisterServerEvent("kc_admin:warn")
AddEventHandler("kc_admin:warn", function (user_id, reason, date, table_id)
    local Source = source

    if not inArray(getGroup(Source), Permissions.Warn) then
        TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.InsufficientPrivileges, "danger")
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    local user_name = getName(user_id)
    local user_identifier = getIdentifier(user_id)
    local user_license = getLicense(user_id)

    local admin_name = getName(Source)
    local admin_identifier = getIdentifier(Source)

    MySQL.Async.execute("INSERT INTO kc_warns (name, identifier, license, admin_name, admin_identifier, reason, timestamp) VALUES (@user_name, @user_identifier, @user_license, @admin_name, @admin_identifier, @reason, @timestamp)", {["@user_name"] = user_name, ["@user_identifier"] = user_identifier, ["@user_license"] = user_license, ["@admin_name"] = admin_name, ["@admin_identifier"] = admin_identifier, ["@reason"] = reason, ["@timestamp"] = date}, function(rows)
        if rows == 1 then
            TriggerClientEvent("kc_admin:send_notify", Source, Lang.Success, Lang.Warn .. user_name, "success")
            TriggerClientEvent("kc_admin:send_message", user_id, "^2" .. admin_name .. Lang.Warned .. "^0" .. reason .. ".")

            MySQL.Async.fetchAll("SELECT id FROM kc_warns WHERE admin_identifier=@admin_identifier AND identifier=@identifier AND timestamp=@timestamp AND reason=@reason", {["@admin_identifier"] = admin_identifier, ["@identifier"] = user_identifier, ["@timestamp"] = date, ["@reason"] = reason}, function (result)
                if ArrayLength(result) ~= 0 then
                    TriggerClientEvent("kc_admin:fix_table", Source, table_id, result[1]["id"])
                end
                MySQL.Async.fetchAll("SELECT id FROM kc_warns WHERE identifier=@identifier", {["@identifier"] = user_identifier}, function(result)

                    warn_count = ArrayLength(result)

                    if warn_count >= Config.WarnPerma then
                        TriggerEvent("kc_admin:perma_ban", Groups.Server, user_id, Lang.WarnAccumulation .. warn_count)
                        return
                    end

                    if warn_count == Config.WarnWeek then
                        TriggerEvent("kc_admin:ban", Groups.Server, user_id, Lang.WarnAccumulation .. warn_count ,1468800)
                        return
                    end

                    if warn_count == Config.WarnDays then
                        TriggerEvent("kc_admin:ban", Groups.Server, user_id, Lang.WarnAccumulation  .. warn_count, 259200)
                        return
                    end

                end)
            end)

        else
            TriggerClientEvent("kc_admin:send_notify", Source, Lang.Error, Lang.WarnError, "danger")
            TriggerClientEvent("kc_admin:remove_table", Source, table_id)
            CancelEvent()
            return
        end
    end)
end)

RegisterServerEvent("kc_admin:get_warns")
AddEventHandler("kc_admin:get_warns", function (id) 
    local Source = source

    if not inArray(getGroup(Source), Permissions.GetWarns) then
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    local player = getLicense(id)
    local result = MySQL.Sync.fetchAll("SELECT id, reason, admin_name, timestamp FROM kc_warns WHERE license=@license", {["@license"] = player})
    
    result_json = json.encode(result)

    TriggerClientEvent("kc_admin:recv_warn", Source, id, result_json)

end)

RegisterServerEvent("kc_admin:message_to_group")
AddEventHandler("kc_admin:message_to_group", function (message, group)
    local players = GetPlayers()
    
    for i in pairs(players) do
        local r_group = getGroup(players[i])

        if not lowerGroup(r_group, group) then
            TriggerClientEvent("kc_admin:send_raw_message", players[i], message)
        end
    end

end)

-- Server Events --

MySQL.ready(function ()
    MySQL_Ready = true
    loadJobs()
end)

-- RconCommands --

RegisterCommand("kc_reload", function (source, args, rawCommand)
    print("Reloading all..")
    MySQL_Ready = true
    loadJobs()
    print("Done!")
end, true)

-- RconCommands -- 

-- Commands --

RegisterCommand("jail", function (Source, args, rawCommand)

    if not inArray(getGroup(Source), Permissions.Jail) then
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.InsufficientPrivileges)
        CancelEvent()
        return
    end

    if ArrayLength(args) < 2 then
        TriggerClientEvent("kc_admin:send_message", Source, "^1" .. Lang.ArgumentNeeded)
    end

    local target_id = args[1]
    local time = args[2]

    time = tonumber(time)

    TriggerClientEvent("kc_admin:request_jail", Source, target_id, time)
end, false)

RegisterCommand("report", function (Source, args, rawCommand)
    args_string = array2string(args)

    local playerName = GetPlayerName(Source)

    TriggerEvent("kc_admin:message_to_group", string.format(Lang.Report, playerName, tostring(Source), args_string), "mod")

end, false)

-- Commands --