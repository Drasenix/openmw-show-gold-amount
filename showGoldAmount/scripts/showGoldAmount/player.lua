local ui = require('openmw.ui')
local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local util = require("openmw.util")
local I = require('openmw.interfaces')
local configPlayer = require('scripts.showGoldAmount.config.player')



local selfObject = self
local element = nil
local function onFrame(dt)
   if element ~= nil then
      element:destroy()
   end
   local windowOpened = core.isWorldPaused()
   local hudVisible = I.UI.isHudVisible()
   local shouldDisplayOnPause = configPlayer.options.b_ShowGoldAmountOnGamePaused
   
   if hudVisible then
      if windowOpened then
         if shouldDisplayOnPause then
            local playerInventory = types.Actor.inventory(self.object)
            local goldAmount = playerInventory:countOf('gold_001')
            element = ui.create({
               template = I.MWUI.templates.textNormal,
               layer = "Windows",
               type = ui.TYPE.Text,
               props = {
                  text = tostring(goldAmount) .. " gold",         
                  textSize = configPlayer.options.n_TextSize,
                  relativePosition = util.vector2(configPlayer.options.n_InfoWindowOffsetXRelative, configPlayer.options.n_InfoWindowOffsetYRelative),         
                  visible = true,
               },
            })
         end
      else
         local playerInventory = types.Actor.inventory(self.object)
         local goldAmount = playerInventory:countOf('gold_001')
         element = ui.create({
            template = I.MWUI.templates.textNormal,
            layer = "Windows",
            type = ui.TYPE.Text,
            props = {
               text = tostring(goldAmount) .. " gold",         
               textSize = configPlayer.options.n_TextSize,
               relativePosition = util.vector2(configPlayer.options.n_InfoWindowOffsetXRelative, configPlayer.options.n_InfoWindowOffsetYRelative),         
               visible = true,
            },
         })
      end
   end   
end


return {
   engineHandlers = {
      onFrame = onFrame
   }
}
