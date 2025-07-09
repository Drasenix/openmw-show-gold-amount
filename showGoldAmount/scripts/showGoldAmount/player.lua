local ui = require('openmw.ui')
local self = require('openmw.self')
local core = require('openmw.core')
local types = require('openmw.types')
local util = require("openmw.util")
local I = require('openmw.interfaces')
local async = require('openmw.async')
local configPlayer = require('scripts.showGoldAmount.config.player')
local l10n = core.l10n('showGoldAmount')


local selfObject = self
local element = nil
local goldMenu = nil
local NONE_L10N_ENTRY = "None"
local GOLD_L10N_ENTRY = "Gold"
local edition_mode = false

local mainWindow = nil
local screenSize = ui.screenSize()
local width_ratio = 0.15
local height_ratio = 0.05
local widget_width = screenSize.x * width_ratio
local widget_height = screenSize.y * height_ratio
local menu_block_width = widget_width * 0.30
local text_size = 18  


local mouse_edition_current_position_x
local mouse_edition_current_position_y

local function generateAmountText()
   local playerInventory = types.Actor.inventory(self.object)
   local goldAmount = playerInventory:countOf('gold_001')
   local goldName = l10n(configPlayer.options.s_GoldName)
   local amountText = tostring(goldAmount)   
   
   if goldName == l10n(NONE_L10N_ENTRY) then
      return amountText
   end

   amountText = amountText .. " " .. goldName
   
   if goldName == l10n(GOLD_L10N_ENTRY) then return amountText end

   return goldAmount > 1 and amountText .. "s" or amountText
end

local function renderGoldAmountUI()

   element = ui.create({
      template = I.MWUI.templates.textNormal,
      layer = "Windows",
      type = ui.TYPE.Text,
      props = {
         text = generateAmountText(),         
         textSize = configPlayer.options.n_TextSize,
         relativePosition = util.vector2(configPlayer.options.n_InfoWindowOffsetXRelative, configPlayer.options.n_InfoWindowOffsetYRelative),         
         visible = true,
      },
   })
end

local function handleFocusWon() 
   return
end

local function handleFocusChildrenWon() 
   return
end

local function handleMouseMove(MouseEvent)
   if edition_mode then
      mouse_position_x = MouseEvent.position.x
      mouse_position_y = MouseEvent.position.y
      delta_x = mouse_position_x - mouse_edition_current_position_x
      delta_y = mouse_position_y - mouse_edition_current_position_y
      
      widget_width = widget_width + delta_x
      widget_height = widget_height + delta_y

      mouse_edition_current_position_x = mouse_position_x
      mouse_edition_current_position_y = mouse_position_y

   end
end

local function handleMousePress(MouseEvent)
   edition_mode = not edition_mode
   mouse_edition_current_position_x = MouseEvent.position.x
   mouse_edition_current_position_y = MouseEvent.position.y
   ui.showMessage(edition_mode and "Enter edition mode" or "Leaving edition mode")
end


local function createGoldMenu()
   local menu_block_path = "Textures\\menu_head_block_middle.dds"

   mainWindow = {
      type = ui.TYPE.Container,
      layer = "Windows",
      template = I.MWUI.templates.boxTransparentThick,
      props = {
         name = "mainWindow",
         relativePosition = util.vector2(0.5, 0.5)
      },
      content = ui.content {
         {
            type = ui.TYPE.Widget,
            props = {
               name = "mainWindowWidget",
               size = util.vector2(widget_width, widget_height)
            },
            content = ui.content {
               {
                  type = ui.TYPE.Text,
                  template = I.MWUI.templates.textNormal,             
                  props = {
                     anchor = util.vector2(.5, .5),
                     relativePosition = util.vector2(.5, .5),
                     text = generateAmountText(),
                     textSize = text_size,                          
                  }
               }     
            },
            events = {
               focusGain = async:callback(handleFocusChildrenWon)
            }
         }
      },
      events = {
         focusGain = async:callback(handleFocusWon),
         mousePress = async:callback(handleMousePress),
         mouseMove = async:callback(handleMouseMove)


      } 
   }

   goldMenu = ui.create(mainWindow)
end

local function isInventoryOpen()
   return I.UI.getMode() == 'Interface'
end

local function destroyUiElements()
   if goldMenu ~= nil then         
      goldMenu:destroy()
   end
   
   if element ~= nil then
      element:destroy()
   end
end

local function onFrame(dt)
   
   destroyUiElements()

   if isInventoryOpen() then
      createGoldMenu()   
   end   

   local hudVisible = I.UI.isHudVisible()
   
   if not hudVisible then return end
   
   if not isInventoryOpen() then
      renderGoldAmountUI()
   end
end

return {
   engineHandlers = {
      onFrame = onFrame      
   }
}
