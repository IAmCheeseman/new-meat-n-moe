local connectDiscord, discordRpc, discordAppId = pcall(function()
  return require("discord_rpc"), require("app_id")
end)

local discord = {}
local nextUpdate = 0
local start = os.time(os.date("*t"))
discord.presence = {
  largeImageKey = "mnm_rpc",
  largeImageText = "Meat n' Moe",
  state = "<unnamed level>",
  details = "00:00 elapsed",
}

if connectDiscord then

function discordRpc.ready(_, username, _, _)
  print("Discord connected to " .. username)
end

function discordRpc.disconnected(errorCode, message)
  print(string.format("Discord disconnected (%d: %s)", errorCode, message))
end

function discordRpc.errored(errorCode, message)
  print(string.format("Discord error (%d: %s)", errorCode, message))
end

function discord.init()
  discordRpc.initialize(discordAppId, true)
end

core.event.connect("update", function()
  if nextUpdate < love.timer.getTime() then
    discordRpc.updatePresence(discord.presence)
    nextUpdate = love.timer.getTime() + 1
  end

  -- Update elapsed time
  local time = os.difftime(os.time(os.date("*t")), start)
  local seconds = tostring(time % 60)
  if #seconds == 1 then
    seconds = "0" .. seconds
  end
  local minutes = tostring(math.floor(time % 3600 / 60))
  if #minutes == 1 then
    minutes = "0" .. minutes
  end
  local hours = tostring(math.floor(time / 3600))
  discord.presence.details = ("%s:%s elapsed"):format(minutes, seconds)
  if hours ~= "0" then
    discord.presence.details = hours .. ":" .. discord.presence.details
  end

  discordRpc.runCallbacks()
end)

function discord.quit()
  discordRpc.shutdown()
end

else

print("Incorrect discord rpc setup. Make sure you set up the app id and included the discord-rpc library.")
print("To fix an app id, make a file in the root directory called `app_id.lua`, which just returns the discord app id as a string.")
print("Error: " .. discordRpc)

function discord.init() end
function discord.quit() end

end

return discord
