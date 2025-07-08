local ui = require('openmw.ui')
local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local util = require("openmw.util")
local I = require('openmw.interfaces')




local selfObject = self
local element = nil
local function onFrame(dt)
   if element ~= nil then
      element:destroy()
   end
   local windowOpened = core.isWorldPaused()
   local hudVisible = I.UI.isHudVisible()
   if not windowOpened and hudVisible then 
      local playerInventory = types.Actor.inventory(self.object)
      local goldAmount = playerInventory:countOf('gold_001')
      element = ui.create({
         template = I.MWUI.templates.textNormal,
         layer = "Windows",
         type = ui.TYPE.Text,
         props = {
            text = tostring(goldAmount) .. " gold",         
            textSize = 20,
            relativePosition = util.vector2(0.925, 0.975),         
            visible = true,
         },
      })
   end
end


return {
   engineHandlers = {
      onFrame = onFrame
   }
}
