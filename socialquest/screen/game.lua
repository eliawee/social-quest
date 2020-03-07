local Character = require("socialquest.character")
local Bank = require("bank")
local Navigator = require("navigator")
local Smartphone = require("socialquest.smartphone")

local GameScreen = Navigator.Screen:extend()

function GameScreen:open()
  self.bank = Bank.get("game")
  self.character = Character()
  self.smartphone = Smartphone()
end

function GameScreen:update(dt)
  self.character:update(dt)
  self.smartphone:update(dt)
end

function GameScreen:draw()
  love.graphics.draw(self.bank.background)
  self.character:draw()
  self.smartphone:draw()
end

return GameScreen