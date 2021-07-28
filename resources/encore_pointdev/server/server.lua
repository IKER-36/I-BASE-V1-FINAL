--
-- Functions
--

function mathRound(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10^numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    else
        return math.floor(value + 0.5)
    end
end

--
-- Events
--

RegisterNetEvent('encore_pointdev:points')
AddEventHandler('encore_pointdev:points', function(points)
    local textString = ''

    for k,v in pairs(points) do
        textString = textString .. ("vector3(%s, %s, %s),\n"):format(
            mathRound(v.x, 2),
            mathRound(v.y, 2),
            mathRound(v.z, 2)
        )
    end

    local time = os.time(os.date('*t'))

    SaveResourceFile(GetCurrentResourceName(), 'files/' .. time .. '.txt', textString)
end)