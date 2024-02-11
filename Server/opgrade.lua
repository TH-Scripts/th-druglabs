RegisterNetEvent('th-druglab:callPolice', function(channelName)
    exports["lb-phone"]:SendDarkChatMessage('Alarmsystem', channelName, 'Politiet er igang med at bryde ind i druglabbet ! Skynd jer at komme !!')
end)