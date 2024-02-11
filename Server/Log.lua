function logs(title, message, footer)
    local embed = {}
    embed = {
        {
            -- ["color"] = '34c7b1',
            ["title"] = "**" .. title .. "**",
            ["description"] = ''.. message ..'',
            ["footer"] = {
                ["text"] = footer
            },
        }
    }
    PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed, content = ""}), { ['Content-Type'] = 'application/json' })
end
