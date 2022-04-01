 -- Convenient Keyboard shortcut actions
 function openTerminal()
     -- iterm
     app = hs.application.find("iTerm2")
     if app == nil then
         hs.application.launchOrFocus("iTerm2")
     else
         app:selectMenuItem("New Window")
     end
 end

 function openBrowser()
     app = hs.application.find("Firefox Developer Edition")
     if app == nil then
         hs.application.launchOrFocus("Firefox Developer Edition")
     end
     app:selectMenuItem("New Window")
 end

 -- ⌘ + ⏎ Opens New Terminal
hs.hotkey.bind({"cmd", "alt"}, "return", openTerminal)

-- ⌘ + ⇧ + ⏎ Opens New Browser Window
hs.hotkey.bind({"cmd","shift"}, "return", openBrowser)

-- Hyper+V types contents of clipboard
hs.hotkey.bind(hyper, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- Hyper+` Brings up Hammerspoon console
hs.hotkey.bind(hyper, "`", function() hs.openConsole() end)

-- Launch or Focus Activity Monitor
hs.hotkey.bind(hyper, "M", function() hs.application.launchOrFocus("Activity Monitor") end)

-- Launch or Focus Spotify
-- hs.hotkey.bind(hyper, "S", function() hs.application.launchOrFocus("Spotify") end)

-- Provides a keyboard based window switcher (instead of app switcher)
hs.hotkey.bind({"cmd", "alt"}, "tab", function() hs.hints.windowHints() end)

-- Ctrl+Cmd + Escape -- Sleeps the Computer
hs.hotkey.bind({"ctrl", "cmd"}, "escape", function() hs.caffeinate.systemSleep() end)

-- Ctrl+Shift + Escape -- Sleeps the displays
hs.hotkey.bind({"ctrl", "shift"}, "escape", function() os.execute("pmset displaysleepnow") end)

-- Ctrl+Cmd+Alt + P -- Toggle Caps Lock
hs.hotkey.bind({"ctrl", "cmd", "alt"}, "P", function() hs.hid.capslock.toggle() end)
