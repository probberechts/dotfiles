---
-- Generic app keybinds

print("== launcher.apps")

hs.hotkey.bind(hyper, "b", function()
  hs.application.launchOrFocus("Bitwarden")
end)

hs.hotkey.bind(hyper, "g", function()
  hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(hyper, "n", function()
  hs.application.launchOrFocus("Joplin")
end)

hs.hotkey.bind(hyper, "s", function()
  hs.application.launchOrFocus("Slack")
end)

hs.hotkey.bind(hyper, "t", function()
  hs.application.launchOrFocus("iTerm")
end)

return nil
