local ui = require('openmw.ui')
local self = require('openmw.self')
local types = require('openmw.types')
local util = require("openmw.util")
local I = require('openmw.interfaces')




local selfObject = self
local element = nil
local function onUpdate(dt)
   if element ~= nil then
      element:destroy()
   end
   local playerInventory = types.Actor.inventory(self.object)
   local goldAmount = playerInventory:countOf('gold_001')
   element = ui.create({
      template = I.MWUI.templates.textNormal,
      layer = "Windows",
      type = ui.TYPE.Text,
      props = {
         text = tostring(goldAmount) .. " gold",         
         textSize = 20,
         relativePosition = util.vector2(0.16, 0.95),
         
         visible = true,
      },
   })
end


return {
   engineHandlers = {
      onUpdate = onUpdate
   }
}
