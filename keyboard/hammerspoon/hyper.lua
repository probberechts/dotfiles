-- A global variable for Hyper Mode
hyperMode = hs.hotkey.modal.new({}, 'F18')

-- Keybindings for launching apps in Hyper Mode
hyperModeAppMappings = {
  { 'i', 'iTunes' },                -- "I" for "iTunes"
  { 'b', 'Safari' },                -- "B" for "Browser"
  { 'c', 'Calendar' },              -- "C" for "Calendar"
  { 'e', 'Atom' },                  -- "E" for "Editor"
  { 'f', 'Finder' },                -- "F" for "Finder"
  { 'm', 'Mail' },                  -- "M" for "Mail"
  { 't', 'iTerm' },                 -- "T" for "Terminal"
}

for i, mapping in ipairs(hyperModeAppMappings) do
  hyperMode:bind({}, mapping[1], function()
    hs.application.launchOrFocus(mapping[2])
  end)
end

-- Enter Hyper Mode when F17 (right option key) is pressed
pressedF17 = function()
  hyperMode:enter()
end

-- Leave Hyper Mode when F17 (right option key) is released.
releasedF17 = function()
  hyperMode:exit()
end

-- Bind the Hyper key
f17 = hs.hotkey.bind({}, 'F17', pressedF17, releasedF17)
