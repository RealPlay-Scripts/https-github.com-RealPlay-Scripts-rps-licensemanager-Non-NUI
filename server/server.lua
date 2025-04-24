local QBCore = exports['qb-core']:GetCoreObject()

-- ✅ Permission check: police (grade ≥ 4) or admin
local function hasPermission(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end

    local job = Player.PlayerData.job
    local isPolice = job.name == "police" and job.grade.level >= 4
    local isAdmin = QBCore.Functions.HasPermission(src, 'admin')

    return isPolice or isAdmin
end

-- ✅ Notification using ox_lib
local function notify(src, message, type)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'License Manager',
        description = message,
        type = type or 'info',
        duration = 5000
    })
end

-- 🔧 Handle license updates
local function updateLicense(src, targetId, licenseType, status)
    if not hasPermission(src) then
        notify(src, 'You must be a police officer (grade 4+) or an admin to use this command.', 'error')
        return
    end

    local Target = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not Target then
        notify(src, 'Target player not found or not online.', 'error')
        return
    end

    local metadata = Target.PlayerData.metadata
    metadata.licences = metadata.licences or {}
    metadata.licences[licenseType] = status

    Target.Functions.SetMetaData("licences", metadata.licences)

    local newMeta = json.encode(Target.PlayerData.metadata)
    exports.oxmysql:execute('UPDATE players SET metadata = ? WHERE citizenid = ?', {
        newMeta, Target.PlayerData.citizenid
    })

    local msg = status and "granted" or "revoked"
    local type = status and "success" or "warning"
    notify(src, string.format('Successfully %s the "%s" license for ID %s.', msg, licenseType, targetId), type)
end

-- ✅ Grant license command
RegisterCommand('grantlicense', function(source, args)
    if #args < 2 then
        notify(source, 'Usage: /grantlicense [playerId] [licenseType]\nExample: /grantlicense 2 driver', 'error')
        return
    end

    local targetId = args[1]
    local licenseType = args[2]
    updateLicense(source, targetId, licenseType, true)
end)

-- ❌ Revoke license command
RegisterCommand('revokelicense', function(source, args)
    if #args < 2 then
        notify(source, 'Usage: /revokelicense [playerId] [licenseType]\nExample: /revokelicense 2 weapon', 'error')
        return
    end

    local targetId = args[1]
    local licenseType = args[2]
    updateLicense(source, targetId, licenseType, false)
end)
