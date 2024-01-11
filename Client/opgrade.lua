function buy_opgrade(opgrade, index)
    if not opgrade then
        return print('[Kritisk Fejl] Der er opstået en kritisk fejl i druglabbet, kontakt en udvikler omgående !')
    elseif opgrade == "speed" then
        return
    elseif opgrade == "police" then
        TriggerServerEvent('arp-druglab:callPolice', index)
    end
end