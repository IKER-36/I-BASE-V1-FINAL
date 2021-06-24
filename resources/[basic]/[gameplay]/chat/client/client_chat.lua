local a = false
local b = false
local c = true
local d = false
s = 100
_s = 2000
RegisterNetEvent("chatMessage")
RegisterNetEvent("chat:addTemplate")
RegisterNetEvent("chat:addMessage")
RegisterNetEvent("chat:addSuggestion")
RegisterNetEvent("chat:addSuggestions")
RegisterNetEvent("chat:removeSuggestion")
RegisterNetEvent("chat:clear")
RegisterNetEvent("__cfx_internal:serverPrint")
RegisterNetEvent("_chat:messageEntered")
print (
    "^7[^5Chat^7] ^1Started"
)
AddEventHandler(
    "chatMessage",
    function(e, f, g)
        local h = {g}
        if e ~= "" then
            table.insert(h, 1, e)
        end
        SendNUIMessage({type = "ON_MESSAGE", message = {color = f, multiline = true, args = h}})
    end
)
AddEventHandler(
    "__cfx_internal:serverPrint",
    function(i)
        print(i)
        SendNUIMessage({type = "ON_MESSAGE", message = {templateId = "print", multiline = true, args = {i}}})
    end
)
AddEventHandler(
    "chat:addMessage",
    function(j)
        j.bgcolor = j.color
        SendNUIMessage({type = "ON_MESSAGE", message = j})
    end
)
AddEventHandler(
    "chat:addSuggestion",
    function(k, l, m)
        SendNUIMessage({type = "ON_SUGGESTION_ADD", suggestion = {name = k, help = l, params = m or nil}})
    end
)
AddEventHandler(
    "chat:addSuggestions",
    function(n)
        for o, p in ipairs(n) do
            SendNUIMessage({type = "ON_SUGGESTION_ADD", suggestion = p})
        end
    end
)
AddEventHandler(
    "chat:removeSuggestion",
    function(k)
        SendNUIMessage({type = "ON_SUGGESTION_REMOVE", name = k})
    end
)
AddEventHandler(
    "chat:addTemplate",
    function(q, r)
        SendNUIMessage({type = "ON_TEMPLATE_ADD", template = {id = q, html = r}})
    end
)
AddEventHandler(
    "chat:clear",
    function(k)
        SendNUIMessage({type = "ON_CLEAR"})
    end
)
RegisterNUICallback(
    "chatResult",
    function(t, u)
        a = false
        SetNuiFocus(false)
        if not t.canceled then
            local q = PlayerId()
            local v, w, x = 0, 0x99, 255
            if t.message:sub(1, 1) == "/" then
                ExecuteCommand(t.message:sub(2))
                TriggerServerEvent("DiscordBot:LogExecuteCommand", q, t.message)
            else
                TriggerServerEvent("_chat:messageEntered", GetPlayerName(q), {v, w, x}, t.message)
            end
        end
        u("ok")
    end
)
local function y()
    if GetRegisteredCommands then
        local z = GetRegisteredCommands()
        local n = {}
        for o, A in ipairs(z) do
            if IsAceAllowed(("command.%s"):format(A.name)) then
                table.insert(n, {name = "/" .. A.name, help = ""})
            end
        end
        TriggerEvent("chat:addSuggestions", n)
    end
end
local function B()
    local C = {}
    for D = 0, GetNumResources() - 1 do
        local E = GetResourceByFindIndex(D)
        if GetResourceState(E) == "started" then
            local F = GetNumResourceMetadata(E, "chat_theme")
            if F > 0 then
                local G = GetResourceMetadata(E, "chat_theme")
                local H = json.decode(GetResourceMetadata(E, "chat_theme_extra") or "null")
                if G and H then
                    H.baseUrl = "nui://" .. E .. "/"
                    C[G] = H
                end
            end
        end
    end
    SendNUIMessage({type = "ON_UPDATE_THEMES", themes = C})
end
AddEventHandler(
    "onClientResourceStart",
    function(I)
        Wait(_s)
        y()
        B()
    end
)
AddEventHandler(
    "onClientResourceStop",
    function(I)
        Wait(_s)
        y()
        B()
    end
)
RegisterNUICallback(
    "loaded",
    function(t, u)
        TriggerServerEvent("chat:init")
        y()
        B()
        d = true
        u("ok")
    end
)
Citizen.CreateThread(
    function()
        SetTextChatEnabled(false)
        SetNuiFocus(false)
        while true do
            Wait(s)
            if not a then
                if IsControlPressed(0, 245) then
                    a = true
                    b = true
                    SendNUIMessage({type = "ON_OPEN"})
                end
            end
            if b then
                if not IsControlPressed(0, 245) then
                    SetNuiFocus(true)
                    b = false
                end
            end
            if d then
                local J = false
                if IsScreenFadedOut() or IsPauseMenuActive() then
                    J = true
                end
                if J and not c or not J and c then
                    c = J
                    SendNUIMessage({type = "ON_SCREEN_STATE_CHANGE", shouldHide = J})
                end
            end
        end
    end
)