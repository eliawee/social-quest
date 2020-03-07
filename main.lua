local Bank = require("bank")
local Event = require("event")
local GameScreen = require("socialquest.screen.game")
local Navigator = require("navigator")

local bank = Bank.save("game", {
  background = Bank.Asset.Image("assets/images/game_bg.png"),
  character = {
    image = Bank.Asset.Image("assets/sprites/character/character.png"),
    spec = Bank.Asset.JSON("assets/sprites/character/character.json"),
  }
})

local navigator = Navigator({
  game = GameScreen
})

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  bank:load()
end

function love.update(dt)
  if not bank:isLoaded() and bank:update() then
    navigator:navigate("game")
  else
    navigator:update(dt)
  end

  Event.scheduler:update()
end

function love.draw()
  navigator:draw()
end