-- Register dummy command handlers (required to show suggestions)
RegisterCommand("grantlicense", function() end, false)
RegisterCommand("revokelicense", function() end, false)

-- Grant License Suggestion
TriggerEvent('chat:addSuggestion', '/grantlicense', 'Grant a license to a player', {
    { name = "playerId", help = "ID of the player you want to give the license to" },
    { name = "licenseType", help = "Type of license (e.g., driver, weapon, hunting)" }
})

-- Revoke License Suggestion
TriggerEvent('chat:addSuggestion', '/revokelicense', 'Revoke a license from a player', {
    { name = "playerId", help = "ID of the player you want to remove the license from" },
    { name = "licenseType", help = "Type of license (e.g., driver, weapon, hunting)" }
})

-- Optional: Cleanup on resource stop
AddEventHandler('onClientResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('chat:removeSuggestion', '/grantlicense')
        TriggerEvent('chat:removeSuggestion', '/revokelicense')
    end
end)
