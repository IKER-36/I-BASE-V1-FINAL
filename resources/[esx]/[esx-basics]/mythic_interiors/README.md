# Mythic Interiors - WIP
This is the basic frameworking for the spawnable interiors. Call any of the functions passing a spawn point and it will spawn objects there and then teleport the player.

You do need the custom objects in the stream folder along with the YTYP files defined in the resource manifest.

>NOTE: My properties script allows for me defining a backdoor so I am providing a boolean which handles if they spawn at the backdoor location or not. Fairly simple to remove if you don't want to use that.

>NOTE: As with most MythicRP releases at this point, this has several calls to Mythic Framework resources that have not (and may not) released publicly. This is intended as a dev resource at most and not a simple drag & drop to use on public servers. Do not make any issues asking for it to be made to work on a public framework or why it isn't plug n' play.

This release only has a few interiors added to it, I'll likely add more to it as I do them but if you want to create them  yourself I made a video explaining how to do so, can find it [here](https://forum.fivem.net/t/solved-question-duplicatiing-interiors-instacing/653922/26?u=alzar)

## Usage
Again, you just call one of the functions and pass a spawn point. Odds are if you're going to be using this on a public server you'd want to add some validation to counter script kiddies trying to LUA inject but that'd be on you. All the functions that spawn an interior returns a list that has all the entity IDs of the objects spawned (You want to store this and call it when the interior is no longer needed and call the despawn function) as well as a list that has the entrance & exit locations of that interior in off-set form.

There's 2 different sets of functions, ones that spawn just the bare minimum shells that're intended to be used for custom player housing. And ones that're spawning the entirety of the objects in the original interior

For best results, I suggest you disable any time & weather syncing you're doing while they're in the interior and setting it to EXTRASUNNY & 24:00 so colors aren't messed up and there isn't water in the building (If it was raining, there will be puddles. There's way to disable it)

Example of how I'm spawning interiors in my realestate script;

```LUA
SetRainFxIntensity(0.0) -- May not be needed, just doing it in-case
TriggerEvent('mythic_sync:client:DisableSync') -- This is my sync script for syncing time & weather. While they're in an interior I'm disabling the sync
Citizen.Wait(100) -- Wait to ensure my syncing was stopped
SetWeatherTypePersist('EXTRASUNNY') -- initial set weather
SetWeatherTypeNow('EXTRASUNNY') -- initial set weather
SetWeatherTypeNowPersist('EXTRASUNNY') -- initial set weather
NetworkOverrideClockTime(23, 0, 0) -- initial set time

local coords = property.enter -- This is from data that I am storing in my realestate script for properties that're player ownable. Just door locations really
coords = { x = coords['x'], y = coords['y'], z = (coords['z'] - 25) } -- We're than getting the offset from the property coords so we can spawn it underground. Offsets may need to be tweaked depending on terrain & interior
local data = exports['mythic_interiors']:CreateTier1House(coords, isBackdoor) -- Spawning the interior
houseObj = data[1] -- Due to exports not returning 2 things correct, gotta return it in a single object then set it after value is returned
POIOffsets = data[2] -- Due to exports not returning 2 things correct, gotta return it in a single object then set it after value is returned
property.spawn = coords -- Storing a reference to the spawn locale
PlayerEnteredHouse(property, hasKey) -- Calling function that handles anything that I want to be done while they're in the property. IE inventory, clothes, logout, etc

Citizen.Wait(1000) -- Delay to ensure all spawning stuff is done and handled
enteringHouse = false -- Set a control boolean to false to indicate the player is no longer in the process of entering an interior
```

[Here's](https://www.youtube.com/watch?v=7HFvGctxOTc) a video showcasing what can be done with these interiors. This script is not released, just a showcase showing what's possible.