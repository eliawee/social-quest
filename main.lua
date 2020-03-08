local conf = require("conf")
local Bank = require("bank")
local Event = require("event")
local Navigator = require("navigator")

local Constant = require("socialquest.constant")
local GameScreen = require("socialquest.screen.game")

local bank = Bank.save("game", {
  background = Bank.Asset.Image("assets/images/game_bg.png"),
  button = {
    follow = {
      image = Bank.Asset.Image("assets/sprites/follow_btn/follow_btn.png"),
      spec = Bank.Asset.JSON("assets/sprites/follow_btn/follow_btn.json"),  
    }
  },
  character = {
    image = Bank.Asset.Image("assets/sprites/character/character.png"),
    spec = Bank.Asset.JSON("assets/sprites/character/character.json"),
  },
  smartphone = {
    background = Bank.Asset.Image("assets/images/smartphone_bg.png"),
    image = Bank.Asset.Image("assets/images/smartphone.png"),
  },
  card = {
    kiki = Bank.Asset.Image("assets/images/kiki_card.png"),
  },
  element = {
    image = Bank.Asset.Image("assets/sprites/elements/elements.png"),
    spec = Bank.Asset.JSON("assets/sprites/elements/elements.json"),
  },
  monster = {
    zombieChicken = {
      image = Bank.Asset.Image("assets/sprites/zombie-chicken/zombie-chicken.png"),
      spec = Bank.Asset.JSON("assets/sprites/zombie-chicken/zombie-chicken.json"),
    }
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
  love.graphics.scale(conf.scale, conf.scale)
  navigator:draw()
end