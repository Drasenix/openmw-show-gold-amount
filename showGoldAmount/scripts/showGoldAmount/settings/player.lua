local core = require('openmw.core')
local I = require('openmw.interfaces')

local l10n = core.l10n('ShowGoldAmount')
local versionString = "1.0.0"

-- Settings page
I.Settings.registerPage {
    key = 'ShowGoldAmount',
    l10n = 'ShowGoldAmount',
    name = 'ConfigTitle',
    description = l10n('ConfigSummary'):gsub('%%{version}', versionString),
}

I.Settings.registerGroup {
    key = 'Settings/ShowGoldAmount/HUDOptions',
    page = 'ShowGoldAmount',
    l10n = 'ShowGoldAmount',
    name = 'ConfigCategoryHUDOptions',
    permanentStorage = true,
    settings = {        
        {
            key = 'OffsetXRelative',
            renderer = 'number',
            name = 'OffsetXRelative',
            argument = {
                min = 0.0,
                max = 1.0,
            },
            default = 0.01,
        },
        {
            key = 'OffsetYRelative',
            renderer = 'number',
            name = 'OffsetYRelative',
            argument = {
                min = 0.0,
                max = 1.0,
            },
            default = 0.985,
        },
        {
            key = 'TextSize',
            renderer = 'number',
            name = 'TextSize',
            argument = {
                min = 1.0,
                max = 50.0,
            },
            default = 20.0,
        },
        {
            key = 's_GoldName',
            renderer = 'select',
            name = 'GoldName',
            argument = {
                l10n = 'showGoldAmount',
                items = {
                    'Gold',
                    'Septim',
                    'Drake',
                    'None'
                }
            },
            default = 'Gold',
        }
    },
}

I.Settings.registerGroup {
    key = 'Settings/ShowGoldAmount/InterfaceOptions',
    page = 'ShowGoldAmount',
    l10n = 'ShowGoldAmount',
    name = 'ConfigCategoryInterfaceOptions',
    permanentStorage = true,
    settings = {
        {
            key = 'TextSize',
            renderer = 'number',
            name = 'TextSize',
            argument = {
                min = 1.0,
                max = 50.0,
            },
            default = 20.0,
        }
    }
}