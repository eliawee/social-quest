local Animation = require("animation")
local Navigator = require("navigator")

local bank = require("socialquest.bank")
local input = require("socialquest.input")
local Character = require("socialquest.character")
local Constant = require("socialquest.constant")
local Finger = require("socialquest.finger")
local Monster = require("socialquest.monster")
local Smartphone = require("socialquest.smartphone")

local GameScreen = Navigator.Screen:extend()

function GameScreen:open()
  self.character = Character()
  self.finger = Finger()
  self.monster = Monster(Constant.Monster.ZombieChicken)
  self.smartphone = Smartphone()
end

function GameScreen:pressButton()
  self.animation = Animation.Series({
    self.finger:moveToButtonAnimation(),
    Animation.Parallel({
      self.character:pushButtonAnimation(),
      self.smartphone:pushButtonAnimation(),
      Animation.Series({
        Animation.Wait(0.1),
        self.finger:hideAnimation()
      })
    })
  })

  self.animation:start()
end

function GameScreen:update(dt)
  if input:pressed("action") then
    self:pressButton()
  end

  if self.animation then
    self.animation:update(dt)
  end

  self.character:update(dt)
  self.monster:update(dt)
  self.smartphone:update(dt)
  self.finger:update(dt)
end

function GameScreen:draw()
  love.graphics.draw(bank.background)
  self.character:draw()
  self.monster:draw()
  self.smartphone:draw()
  self.finger:draw()
end

return GameScreen