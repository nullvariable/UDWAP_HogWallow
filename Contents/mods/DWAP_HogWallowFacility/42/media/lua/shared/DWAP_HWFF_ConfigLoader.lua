local DWAPUtils = require "DWAPUtils"
Events.OnLoadRadioScripts.Add(function()

    local config = {
        minimumVersion = 17,
        file = "DWAP_HWFF/configs/DWAP_HogWallowFacility",
        overrides = {
            makePrimary = SandboxVars.DWAP_HWFF.MakePrimary,
            keyAndMap = SandboxVars.DWAP_HWFF.KeyAndMap,
            essentialLoot = SandboxVars.DWAP_HWFF.EssentialLoot,
            regularLoot = SandboxVars.DWAP_HWFF.RegularLoot,
        },
    }
    if SandboxVars.DWAP_HWFF.ExtraLoot then
        config.file = "DWAP_HWFF/configs/HWFF_ExtraLoot"
    end
    DWAPUtils.dprint("Loading DWAP_HogWallowFacility config")
    DWAPUtils.addExternalConfig(config)
end)


local spawns = {
    { x = 5591, y = 12437, z = 0 },
    { x = 5557, y = 12480, z = 1 },
    { x = 5541, y = 12443, z = 1 },
    { x = 5588, y = 12483, z = 0 },
    { x = 5578, y = 12500, z = -13 },
    { x = 5550, y = 12486, z = -13 },
    { x = 5582, y = 12472, z = -17 },
    { x = 5567, y = 12432, z = -17 },
    { x = 5831, y = 12491, z = 0 },
}

DWAP_HWFF_Random = function()
    local random = newrandom()
    local seed = WGParams.instance:getSeedString()
    random:seed(seed)
    return random:random(1, #spawns)
end

DWAP_HWFF_SelectedSpawn = function()
    local index = SandboxVars.DWAP_HWFF.SpawnLocation - 1
    if index == 0 then
        index = DWAP_HWFF_Random()
    end
    return index
end

function DWAP_HWFF_beforeTeleport(coords)
    Events.OnZombieCreate.Add(function(zombie)
        local x, y, z = coords.x, coords.y, coords.z
        if zombie then
            local zombieX, zombieY, zombieZ = zombie:getX(), zombie:getY(), zombie:getZ()
            if zombieX >= x - 15 and zombieX <= x + 15 and
            zombieY >= y - 15 and zombieY <= y + 15 and
            (zombieZ == z or zombieZ == z - 1) then
                print("Removing zombie: " .. zombieX .. ", " .. zombieY)
                -- prevent zombie spawns
                zombie:removeFromWorld()
                zombie:removeFromSquare()
            end
        end
    end)
end

function DWAP_HWFF_afterTeleport(coords)
    for x = coords.x - 15, coords.x + 15 do
        for y = coords.y - 15, coords.y + 15 do
            for z = coords.z - 1, coords.z do
                local square = getSquare(x, y, z)
                if square then
                    local movingObjects = square:getLuaMovingObjectList()
                    for i = 1, #movingObjects do
                        local movingObject = movingObjects[i]
                        if instanceof(movingObject, "IsoZombie") then
                            movingObject:removeFromWorld()
                            movingObject:removeFromSquare()
                            print("Removed zombie at: " .. x .. ", " .. y)
                        end
                    end
                end
            end
        end
    end
    local result = DWAPUtils.lightsOnCurrentRoom(nil, -120)
    if not result then
        DWAPUtils.DeferMinute(function()
            DWAPUtils.lightsOnCurrentRoom()
        end)
    end
end

Events.OnNewGame.Add(function(player)
    local spawnRegion = MapSpawnSelect.instance.selectedRegion
    if not spawnRegion then
        spawnRegion = MapSpawnSelect.instance:useDefaultSpawnRegion()
    end
    DWAPUtils.dprint("OnNewGame DWAP_HWFF Lights spawn region: " .. tostring(spawnRegion.name))

    local modData = player:getModData()
    if not modData.DWAPHWFF_Spawn then
        if spawnRegion.name == "DWAP_HWFF" then
            if SandboxVars.DWAP_HWFF.Flashlight then
                local flashlight = instanceItem("Base.HandTorch")
                player:getInventory():AddItem(flashlight)
            end
            local index = DWAP_HWFF_SelectedSpawn()
            local coords = spawns[index]
            if not coords then
                DWAPUtils.dprint("DWAP_HWFF: Invalid spawn index, defaulting to 1")
                coords = spawns[1]
            end
            DWAPUtils.dprint("DWAP_HWFF: Spawning at index " .. tostring(index))
            DWAP_HWFF_beforeTeleport(coords)
            if isClient() then
                SendCommandToServer("/teleportto " .. coords.x .. "," .. coords.y .. "," .. coords.z);
            else
                getPlayer():teleportTo(coords.x, coords.y, coords.z)
            end
            DWAPUtils.Defer(function()
                DWAP_HWFF_afterTeleport(coords)
            end)
        end
        modData.DWAPHWFF_Spawn = true
    end
end)
