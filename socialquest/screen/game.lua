local Navigator = require("navigator")

local bank = require("socialquest.bank")
local Character = require("socialquest.character")
local Constant = require("socialquest.constant")
local Monster = require("socialquest.monster")
local Smartphone = require("socialquest.smartphone")

local GameScreen = Navigator.Screen:extend()

function GameScreen:open()
  self.character = Character()
  self.monster = Monster(Constant.Monster.ZombieChicken)
  self.smartphone = Smartphone()
end

function GameScreen:update(dt)
  self.character:update(dt)
  self.monster:update(dt)
  self.smartphone:update(dt)
end

function GameScreen:draw()
  love.graphics.draw(bank.background)
  self.character:draw()
  self.monster:draw()
  self.smartphone:draw()
end

return GameScreen