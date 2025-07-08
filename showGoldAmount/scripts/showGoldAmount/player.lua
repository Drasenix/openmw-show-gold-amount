local ui = require('openmw.ui')
local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local util = require("openmw.util")
local I = require('openmw.interfaces')
local configPlayer = require('scripts.showGoldAmount.config.player')
local l10n = core.l10n('showGoldAmount')


local selfObject = self
local element = nil
local function onFrame(dt)
   if element ~= nil then
      element:destroy()
   end
   local windowOpened = core.isWorldPaused()
   local hudVisible = I.UI.isHudVisible()
   local shouldDisplayOnPause = configPlayer.options.b_ShowGoldAmountOnGamePaused
   
   if not hudVisible then return end
   if not windowOpened then
      local playerInventory = types.Actor.inventory(self.object)
      local goldAmount = playerInventory:countOf('gold_001')
      local goldName = l10n(configPlayer.options.s_GoldName)
      local amountText = goldName ~= "None" and tostring(goldAmount) .. " " .. goldName or tostring(goldAmount)
      
      element = ui.create({
         template = I.MWUI.templates.textNormal,
         layer = "Windows",
         type = ui.TYPE.Text,
         props = {
            text = amountText,         
            textSize = configPlayer.options.n_TextSize,
            relativePosition = util.vector2(configPlayer.options.n_InfoWindowOffsetXRelative, configPlayer.options.n_InfoWindowOffsetYRelative),         
            visible = true,
         },
      })
      return
   end 
   
   if not shouldDisplayOnPause then return end 

   local playerInventory = types.Actor.inventory(self.object)
   local goldAmount = playerInventory:countOf('gold_001')
   local goldName = l10n(configPlayer.options.s_GoldName)
   local amountText = goldName ~= "None" and tostring(goldAmount) .. " " .. goldName or tostring(goldAmount)
   
   element = ui.create({
      template = I.MWUI.templates.textNormal,
      layer = "Windows",
      type = ui.TYPE.Text,
      props = {
         text = amountText,         
         textSize = configPlayer.options.n_TextSize,
         relativePosition = util.vector2(configPlayer.options.n_InfoWindowOffsetXRelative, configPlayer.options.n_InfoWindowOffsetYRelative),         
         visible = true,
      },
   })   
end


return {
   engineHandlers = {
      onFrame = onFrame
   }
}
