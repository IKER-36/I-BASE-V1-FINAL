_s = 1000
RegisterServerEvent("chat:init")
RegisterServerEvent("chat:addTemplate")
RegisterServerEvent("chat:addMessage")
RegisterServerEvent("chat:addSuggestion")
RegisterServerEvent("chat:removeSuggestion")
RegisterServerEvent("_chat:messageEntered")
RegisterServerEvent("chat:clear")
RegisterServerEvent("__cfx_internal:commandFallback")
print(
    "^7[^4cs_chat^7]^7 ^1 Started!"
)
AddEventHandler(
    "_chat:messageEntered",
    function(a, b, c)
        if not c or not a then
            return
        end
        TriggerEvent("chatMessage", source, a, c)
        if not WasEventCanceled() then
            TriggerClientEvent("chatMessage", -1, a, {255, 255, 255}, c)
        end
        print(a .. "^7: " .. c .. "^7")
    end
)
AddEventHandler(
    "__cfx_internal:commandFallback",
    function(d)
        local e = GetPlayerName(source)
        TriggerEvent("chatMessage", source, e, "/" .. d)
        if not WasEventCanceled() then
            TriggerClientEvent("chatMessage", -1, e, {255, 255, 255}, "/" .. d)
        end
        CancelEvent()
    end
)
local function f(g)
    if GetRegisteredCommands then
        local h = GetRegisteredCommands()
        local i = {}
        for j, d in ipairs(h) do
            if IsPlayerAceAllowed(g, ("command.%s"):format(d.name)) then
                table.insert(i, {name = "/" .. d.name, help = ""})
            end
        end
        TriggerClientEvent("chat:addSuggestions", g, i)
    end
end
AddEventHandler(
    "chat:init",
    function()
        f(source)
    end
)
AddEventHandler(
    "onServerResourceStart",
    function(k)
        Wait(_s)
        for j, g in ipairs(GetPlayers()) do
            f(g)
        end
    end
)