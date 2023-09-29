local core = require('openmw.core')
if not core.contentFiles.has(require("scripts.an_unexpected_start.modData").addonFileName) then
    return
end

local names = require("scripts.an_unexpected_start.names")

local Actor = require('openmw.types').Actor
local self = require('openmw.self')
local time = require('openmw_aux.time')
local storage = require('openmw.storage').playerSection(names.storageName)

local levitationSpellName = "usbd_levitation_passive_spell"

local counter = 0
local notOnGroundCounter = 0
local levitationEnabled = false
local lockLevitation = false
local timer
timer = time.runRepeatedly(function()
    if not storage:get("applyLevitation") then
        Actor.spells(self):remove(levitationSpellName)
        return
    end
    local xAngle = self.rotation:getAnglesXZ()
    if xAngle and xAngle < -0.5 then
        counter = counter + 1
    else
        counter = 0
    end
    local onGround = Actor.isOnGround(self)
    local swimming = Actor.isSwimming(self)
    if not levitationEnabled and not onGround and not swimming then
        notOnGroundCounter = notOnGroundCounter + 1
    else
        notOnGroundCounter = 0
    end
    local function enableLevitation()
        Actor.spells(self):add(levitationSpellName)
        levitationEnabled = true
    end
    if counter > 20 then
        enableLevitation()
    elseif notOnGroundCounter > 13 then
        enableLevitation()
        lockLevitation = true
    elseif onGround or not lockLevitation then
        Actor.spells(self):remove(levitationSpellName)
        lockLevitation = false
        levitationEnabled = false
    end
end, 0.1 * time.second, {})

local function usbd_removeLevitationScript()
    Actor.spells(self):remove(levitationSpellName)
    timer()
    core.sendGlobalEvent("usbd_removeScript", {reference = self, scriptName = "scripts/an_unexpected_start/levitation.lua"})
end

return {
    eventHandlers = {
        usbd_removeLevitationScript = usbd_removeLevitationScript,
    },
}