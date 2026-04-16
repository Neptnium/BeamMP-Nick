-- Made by: Neptnium
-- discord: @neptnium
-- github: https://github.com/Neptnium

local M = {}

local originOnVehicleReady = nil

local function setVehicleNick(data)
    local dataList = {}
    for elem in data:gmatch('([^;]+)') do table.insert(dataList, elem) end
    MPVehicleGE.getVehicleByServerID(dataList[1]):setDisplayName(dataList[2])
end

local function customOnVehicleReady(gameVehicleID)
    if not MPVehicleGE then return end
    if(MPVehicleGE.isOwn(gameVehicleID)) then return end 

    TriggerServerEvent("getNick", MPVehicleGE.getServerVehicleID(gameVehicleID))
    if originOnVehicleReady then originOnVehicleReady(vehicle) end
    MPVehicleGE.hideNicknames(false)
end

local function injectConfigCleanup()
    if extensions.MPVehicleGE and extensions.MPVehicleGE.onVehicleReady ~= customOnVehicleReady then
        log("E", "onExtensionLoaded", "loaded custom onVehicleReady")
        originOnVehicleReady = extensions.MPVehicleGE.onVehicleReady
        extensions.MPVehicleGE.onVehicleReady = customOnVehicleReady
    end
end

local function onExtensionLoaded()
    MPVehicleGE.hideNicknames(false)
    AddEventHandler("setVehicleNick", setVehicleNick)
    injectConfigCleanup()
end

M.onExtensionLoaded = onExtensionLoaded

return M
