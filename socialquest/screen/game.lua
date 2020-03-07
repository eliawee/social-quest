local conf = require("conf")
local Character = require("socialquest.character")
local Bank = require("bank")
local Navigator = require("navigator")

local GameScreen = Navigator.Screen:extend()

function GameScreen:open()
  self.bank = Bank.get("game")
  self.character = Character()
end

function GameScreen:update(dt)
  self.character:update(dt)
end

function GameScreen:draw()
  love.graphics.draw(self.bank.background, 0, 0, 0, conf.scale)
  self.character:draw()
end

return GameScreen