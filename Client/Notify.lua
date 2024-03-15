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

function notifyIngenPenge()
    lib.notify({
        id = 'biler2',
        title = 'Ikke nok penge',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'money-bill',
        iconColor = '#C53030'
    })
end

function notifyBlipSendt()
    lib.notify({
        id = 'biler2',
        title = 'Køretøj lokaliseret',
        description = 'Kør hen til køretøjet hurtigst muligt! Husk at medbringe våben',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'car',
        iconColor = '#36a5d1'
    })
end

function notifyDuFejledeMinigamet()
    lib.notify({
        id = 'biler2',
        title = 'Minigame Fejlet',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'gamepad',
        iconColor = '#C53030'
    })
end


function notifyStoppetProgress()
    lib.notify({
        id = 'biler2',
        title = 'Hvad laver du?',
        description = 'Politiet er på vej!',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'eye',
        iconColor = '#C53030'
    })
end

function notifyMangler()
    lib.notify({
        id = 'biler2',
        title = 'Du mangler en lockpick',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'lock',
        iconColor = '#C53030'
    })
end

function notifyPoint()
    lib.notify({
        id = 'biler2',
        title = 'Du mangler en lockpick',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'lock',
        iconColor = '#C53030'
    })
end

function notifyCooldown()
    lib.notify({
        id = 'biler2',
        title = 'Cooldown',
        description = 'Du har allerede gennemført en mission!',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'clock',
        iconColor = '#36a5d1'
    })
end

function notifyIngenAdgang()
    lib.notify({
        id = 'biler2',
        title = 'Du har ikke adgang',
        description = 'Du kan ikke tilgå computeren, eftersom du ikke er medlem eller ejer druglabbet!',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'laptop',
        iconColor = '#C53030'
    })
end

function notifyNoPlayers()
    lib.notify({
        id = 'biler5',
        title = 'Ingen i nærheden',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'circle-xmark',
        iconColor = '#C53030'
    })
end
function notifyNotItem()
    lib.notify({
        id = 'biler5',
        title = 'Du har ikke det rigtige item',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'circle-xmark',
        iconColor = '#C53030'
    })
end

function TextUi(text, icon, color)
    lib.showTextUI(text, {
        position = "right-center",
        icon = icon,
        iconColor = color,
        style = {
            borderRadius = 5,
            backgroundColor = '#141517',
            color = 'white'
        }
    })
end