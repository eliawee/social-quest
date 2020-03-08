local conf = require("conf")
local Event = require("event")
local Navigator = require("navigator")

local bank = require("socialquest.bank")
local input = require("socialquest.input")
local GameScreen = require("socialquest.screen.game")


local navigator = Navigator({
  game = GameScreen
})

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  bank:load()
end

function love.update(dt)
  input:update(dt)

  if not bank:isLoaded() and bank:update() then
    navigator:navigate("game")
  else
    navigator:update(dt)
  end

  Event.scheduler:update()
end

function love.draw()
  love.graphics.scale(conf.scale, conf.scale)
  navigator:draw()
end