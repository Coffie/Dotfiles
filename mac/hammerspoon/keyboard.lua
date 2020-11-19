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
     app = hs.application.find("Google Chrome")
     if app == nil then
         hs.application.launchOrFocus("Google Chrome")
     end
     app:selectMenuItem("New Window")
 end


 hs.hotkey.bind({}, "f8", function()
     hs.spotify.playpause()
 end)
 hs.hotkey.bind({}, "f9", function()
     hs.spotify.next()
 end)
 hs.hotkey.bind({}, "f7", function()
     hs.spotify.previous()
 end)
 hs.hotkey.bind({}, "f11", function()
  playing = hs.spotify.isPlaying()

  if playing then
    hs.spotify.volumeDown()
  else
    output = hs.audiodevice.defaultOutputDevice()
    output:setVolume(output:volume() - 10)
  end
end)

hs.hotkey.bind({}, "f12", function()
  playing = hs.spotify.isPlaying()

  if playing then
    hs.spotify.volumeUp()
  else
    output = hs.audiodevice.defaultOutputDevice()
    output:setVolume(output:volume() + 10)
  end
end)

 -- ⌘ + ⏎ Opens New Terminal
hs.hotkey.bind({"cmd", "alt"}, "T", openTerminal)

-- ⌘ + ⇧ + ⏎ Opens New Browser Window
hs.hotkey.bind({"cmd","shift"}, "return", openBrowser)
-- Hyper+V types contents of clipboard
hs.hotkey.bind(hyper, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- Hyper+` Brings up Hammerspoon console
hs.hotkey.bind(hyper, "`", function() hs.openConsole() end)

-- Launch or Focus Activity Monitor
hs.hotkey.bind(hyper, "M", function() hs.application.launchOrFocus("Activity Monitor") end)

-- Launch or Focus Activity Monitor
hs.hotkey.bind(hyper, "S", function() hs.application.launchOrFocus("Spotify") end)

-- Provides a keyboard based window switcher (instead of app switcher)
hs.hotkey.bind({"cmd", "alt"}, "tab", function() hs.hints.windowHints() end)

-- Hyper+F makes toggles app zoom
hs.hotkey.bind(hyper, "F", function() hs.window.focusedWindow():toggleZoom() end)

-- Ctrl+Cmd + Escape -- Sleeps the Computer
hs.hotkey.bind({"ctrl", "cmd"}, "escape", function() hs.caffeinate.systemSleep() end)

-- Ctrl+Shift + Escape -- Sleeps the displays
hs.hotkey.bind({"ctrl", "shift"}, "escape", function() os.execute("pmset displaysleepnow") end)

-- Ctrl+Cmd+Alt + P -- Toggle Caps Lock
hs.hotkey.bind({"ctrl", "cmd", "alt"}, "P", function() hs.hid.capslock.toggle() end)
