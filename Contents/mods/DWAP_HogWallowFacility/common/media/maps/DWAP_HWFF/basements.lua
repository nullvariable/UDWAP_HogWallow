local basements = {
}

local basement_access = {
    ba_dwap_generator = { width=1, height=1, stairx=0, stairy=0, stairDir="N" },
}

local fullConfig = table.newarray()
fullConfig[1] = {
    locations = {
        {x=5568, y = 12444, z=-18, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5573, y = 12474, z=-18, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5547, y = 12495, z=-18, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5548, y = 12463, z=-18, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5564, y = 12412, z=-18, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},

        {x=5591, y = 12495, z=-14, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5554, y = 12504, z=-14, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5521, y = 12500, z=-14, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5541, y = 12469, z=-14, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},

        {x=5550, y = 12468, z=-8, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5550, y = 12468, z=-2, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5537, y = 12439, z=-2, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5594, y = 12434, z=-2, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5536, y = 12505, z=-2, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5569, y = 12505, z=-2, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
        {x=5584, y = 12475, z=-2, stairDir="N", choices={"dummy"}, access="ba_dwap_generator"},
    },
}


local locations = {}

for i = 1, #fullConfig do
    for j = 1, #fullConfig[i].locations do
        table.insert(locations, fullConfig[i].locations[j])
    end
end

local api = Basements.getAPIv1()
api:addAccessDefinitions('Muldraugh, KY', basement_access)
api:addBasementDefinitions('Muldraugh, KY', basements)
api:addSpawnLocations('Muldraugh, KY', locations)


if getActivatedMods():contains("\\Taylorsville") then
    print("DWAP Taylorsville support loading")
    api:addAccessDefinitions('Taylorsville', basement_access)
    api:addBasementDefinitions('Taylorsville', basements)
    api:addSpawnLocations('Taylorsville', locations)
end

print("DWAP Hog Wallow basements.lua loaded")
