print("DWAP HWFF StashDesc.lua loaded")
LootMaps.Init.DWAP_HWFFStashMap1 = function(mapUI)
    print("Initializing DWAP_HWFFStashMap1")
    local mapAPI = mapUI.javaObject:getAPIv1()
    MapUtils.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
    MapUtils.initDefaultStyleV1(mapUI)
    mapAPI:setBoundsInSquares(5400, 12296, 5959, 12695)
end
