local conf = {
  exports = {
    width = 200,
    height = 150
  },
  window = {
    width = 800,
    height = 600
  }
}

conf.scale = conf.window.width / conf.exports.width

function love.conf(t)
  t.window.title = "Social Quest"
  t.window.width = conf.window.width
  t.window.height = conf.window.height
  love.filesystem.setRequirePath("?.lua;?/init.lua;lib/?.lua;lib/?/init.lua")
end

return conf