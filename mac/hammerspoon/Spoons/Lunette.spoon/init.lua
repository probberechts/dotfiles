-- luacheck: globals Command DefaultMapping hs
--
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Lunette"
obj.version = "0.1-beta"
obj.author = "Scott Hudson <scott.w.hudson@gmail.com>"
obj.license = "MIT"
obj.homepage = "https://github.com/scottwhudson/Lunette"

-- disable animation
hs.window.animationDuration = 0

-- Internal function used to find our location, so we know where to load files from
local function script_path()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end
obj.spoonPath = script_path()

Command = dofile(obj.spoonPath.."/command.lua")

DefaultMapping = {
  cycleWidth = {
    {{"ctrl", "cmd", "shift"}, "w"},
  },
  leftHalf = {
    {{"cmd", "alt"}, "left"},
  },
  rightHalf = {
    {{"cmd", "alt"}, "right"},
  },
  topHalf = {
    {{"cmd", "alt"}, "up"},
  },
  bottomHalf = {
    {{"cmd", "alt"}, "down"},
  },
  topLeft = {
    {{"ctrl", "cmd"}, "Left"},
  },
  topRight = {
    {{"ctrl", "cmd"}, "Right"},
  },
  bottomLeft = {
    {{"ctrl", "cmd", "shift"}, "Left"},
  },
  bottomRight = {
    {{"ctrl", "cmd", "shift"}, "Right"},
  },
  fullScreen = {
    {{"cmd", "alt"}, "F"},
  },
  center = {
    {{"cmd", "alt"}, "C"},
  },
  nextThird = {
    {{"ctrl", "alt"}, "Right"},
  },
  prevThird = {
    {{"ctrl", "alt"}, "Left"},
  },
  enlarge = {
    {{"ctrl", "alt", "shift"}, "Right"},
  },
  shrink = {
    {{"ctrl", "alt", "shift"}, "Left"},
  },
}

function obj.exec(commandName)
  local window = hs.window.focusedWindow()
  if window == nil then
    return
  end

  local windowFrame = window:frame()
  local screen = window:screen()
  local screenFrame = screen:frame()
  local newFrame = Command[commandName](windowFrame, screenFrame)
  window:setFrame(newFrame)
end

function obj:bindHotkeys(userBindings)
  print("Lunette: Binding Hotkeys")

  userBindings = userBindings or {}
  local bindings = DefaultMapping

  for command, mappings in pairs(userBindings) do
    bindings[command] = mappings
  end

  for command, mappings in pairs(bindings) do
    if mappings then
      for _, binding in ipairs(mappings) do
        hs.hotkey.bind(binding[1], binding[2], function()
          obj.exec(command)
        end)
      end
    end
  end

  return self
end

return obj
