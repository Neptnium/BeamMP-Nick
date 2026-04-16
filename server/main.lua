-- Made by: Neptnium
-- discord: @neptnium
-- github: https://github.com/Neptnium

local nicknames = {}

function playerDisconnectHandler(playerID)
    nicknames[playerID] = nil
end

function getNickHandler(playerID, vehicleID)
    local targetPlayerID, _ = vehicleID:match("(%d+)-(%d+)")
    if not targetPlayerID then return end
    targetPlayerID = tonumber(targetPlayerID)
    if not nicknames[targetPlayerID] then return end
    MP.TriggerClientEvent(playerID, "setVehicleNick", vehicleID .. ";" .. nicknames[targetPlayerID])
end

function chatMessageHandler(playerID, _, message)
    local prefix, nick = message:match("^(%S+)%s+(.*)")
    if not prefix then return end
    if prefix == "/nick" and nick then
        nicknames[playerID] = nick
        MP.SendChatMessage(playerID, "You new nickname is: ^b" .. nicknames[playerID])

        for vehicle_id, _ in pairs(MP.GetPlayerVehicles(playerID) or {}) do
            MP.TriggerClientEvent(-1, "setVehicleNick", playerID .. "-".. vehicle_id .. ";" .. nick)
        end
        return 1
    end
end

MP.RegisterEvent("onPlayerDisconnect", "playerDisconnectHandler")
MP.RegisterEvent("getNick", "getNickHandler")
MP.RegisterEvent("onChatMessage", "chatMessageHandler")