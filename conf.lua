function love.conf(t)
  t.window.title = "Social Quest"
  love.filesystem.setRequirePath("?.lua;?/init.lua;lib/?.lua;lib/?/init.lua")
end

return {
  scale = 4
}