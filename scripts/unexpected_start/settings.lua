local storage = require("openmw.storage")
local async = require("openmw.async")
local I = require("openmw.interfaces")
local core = require('openmw.core')
local ui = require('openmw.ui')
local util = require('openmw.util')

local this = {}
this.storageName = "SettingsUnexpectedStartByDiject"
local l10nName = "unexpected_start"

local function boolSetting(args)
    return {
        key = args.key,
        renderer = "checkbox",
        name = args.name,
        description = args.description,
        default = args.default or false,
        trueLabel = args.trueLabel,
        falseLabel = args.falseLabel,
        disabled = args.disabled,
    }
end

I.Settings.registerPage({
    key = this.storageName,
    l10n = l10nName,
    name = "modName",
    description = "modDescription",
})

I.Settings.registerGroup({
    key = this.storageName,
    page = this.storageName,
    l10n = l10nName,
    name = "mainSettings",
    permanentStorage = true,
    order = 0,
    settings = {
        boolSetting({key = "enabled", name = "enabled", default = true}),
        boolSetting({key = "allowJustExit", name = "allowJustExit", default = true}),
        boolSetting({key = "onlyInACity", name = "onlyInACity", default = true}),
        boolSetting({key = "spawnGuards", name = "spawnGuards", default = true}),
    },
})

return this