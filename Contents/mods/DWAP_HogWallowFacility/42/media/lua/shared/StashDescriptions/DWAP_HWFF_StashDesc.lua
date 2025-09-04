require "StashDescriptions/StashUtil";

local configs = {
    [1] = {
        name = "Hog Wallow Forest Facility",
        stamps = {
            {"Police", nil, 5832, 12490, 0.50, 0.50, 0.0, 0.129, 0.129, 0.129},
            {"ArrowSouth", nil, 5592, 12428, 0.50, 0.50, 0.0, 0.00, 0.00, 0.000},
            {nil, "Stash_DWAP_HWFF_Seeds", 5560, 12408, 0.00, 0.00, 0.0, 0.129, 0.129, 0.129},

            {nil, "Stash_DWAP_HWFF_Parking", 5634, 12478, 0.00, 0.00, 0.0, 0.129, 0.129, 0.129},
        },
        buildingX = 5591,
        buildingY = 12437,
    },
}


if getActivatedMods():contains("\\Gelevator") then
    table.insert(configs[1].stamps, {"ArrowSouthEast", nil, 5533, 12496, 0.50, 0.50, 0.0, 0.129, 0.129, 0.129})
    table.insert(configs[1].stamps, {nil, "Stash_DWAP_HWFF_Elevator", 5495, 12574, 0.00, 0.00, 90.0, 0.129, 0.129, 0.129})
end

for i = 1, #configs do
    local config = configs[i]
    -- local DWAPStashMap = StashUtil.newStash("DWAP_HWFFStashMap" .. i, "Map", "Base.RosewoodMap", "Stash_AnnotedMap");
    local DWAPStashMap = StashUtil.newStash("DWAP_HWFFStashMap" .. i, "Map", "Base.RosewoodMap", config.name);
    for j = 1, #config.stamps do
        local stamp = config.stamps[j]
        if config.buildingX and config.buildingY then
            DWAPStashMap.buildingX = config.buildingX
            DWAPStashMap.buildingY = config.buildingY
        end
        -- DWAPStashMap.addStampV2 = function(symbol,text,mapX,mapY,anchorX,anchorY,rotation,r,g,b)
        --     if not DWAPStashMap.annotations then
        --         DWAPStashMap.annotations = {};
        --     end
        --     local annotation = {};
        --     annotation.symbol = symbol;
        --     annotation.text = text;
        --     annotation.x = mapX;
        --     annotation.y = mapY;
        --     annotation.anchorX = anchorX;
        --     annotation.anchorY = anchorY;
        --     annotation.rotation = rotation;
        --     annotation.r = r;
        --     annotation.g = g;
        --     annotation.b = b;
        --     table.insert(DWAPStashMap.annotations, annotation);
        -- end
        -- DWAPStashMap:addStampV2(stamp[1], stamp[2], stamp[3], stamp[4], stamp[5], stamp[6], stamp[7], stamp[8], stamp[9], stamp[10])
        if not DWAPStashMap.annotations then
            DWAPStashMap.annotations = {}
        end
        table.insert(DWAPStashMap.annotations, {
            symbol = stamp[1],
            text = stamp[2],
            x = stamp[3],
            y = stamp[4],
            anchorX = stamp[5],
            anchorY = stamp[6],
            rotation = stamp[7],
            r = stamp[8],
            g = stamp[9],
            b = stamp[10],
        })
    end
    DWAPStashMap.customName = config.name
    
    Events.OnInitGlobalModData.Add(function()
        print("SandboxVars.DWAP_HWFF.EssentialLoot: "..tostring(SandboxVars.DWAP_HWFF.EssentialLoot))
        print("SandboxVars.DWAP_HWFF.MakePrimary: "..tostring(SandboxVars.DWAP_HWFF.MakePrimary))
        print("SandboxVars.DWAP.Loot: "..tostring(SandboxVars.DWAP.Loot))
        if SandboxVars.DWAP_HWFF.EssentialLoot > 2 or (SandboxVars.DWAP_HWFF.MakePrimary and SandboxVars.DWAP.Loot < 4) then
            -- table.insert(configs[1].stamps, {"ArrowWest", nil, 5592, 12486, 0.50, 0.50, 0.0, 0.129, 0.129, 0.129})
            table.insert(DWAPStashMap.annotations, {
                symbol = "ArrowWest",
                text = nil,
                x = 5592,
                y = 12486,
                anchorX = 0.50,
                anchorY = 0.50,
                rotation = 0.0,
                r = 0.129,
                g = 0.129,
                b = 0.129,
            })
            table.insert(DWAPStashMap.annotations, {
                symbol = nil,
                text = "Stash_DWAP_HWFF_Main",
                x = 5601,
                y = 12489,
                anchorX = 0.00,
                anchorY = 0.00,
                rotation = 327.0,
                r = 0.129,
                g = 0.129,
                b = 0.129,
            })
        end
    end)
end
