local conf = require("conf")
local Bank = require("bank")
local Navigator = require("navigator")

local GameScreen = Navigator.Screen:extend()

function GameScreen:open()
  self.bank = Bank.get("game")
end

function GameScreen:draw()
  love.graphics.draw(self.bank.background, 0, 0, 0, conf.scale)
end

return GameScreen