function notifyForkertKode()
    lib.notify({
        id = 'biler2',
        title = 'Forkert pinkode',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'thumbtack',
        iconColor = '#C53030'
    })
end

function notifyKodeSkiftet(kode)
    lib.notify({
        id = 'biler2',
        title = 'Du har skiftet din pinkode til '..kode,
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'laptop-code',
        iconColor = '#32a852'
    })
end
