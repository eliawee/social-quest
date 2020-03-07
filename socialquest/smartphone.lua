local conf = require("conf")
local Bank = require("bank")
local Object = require("classic")

local Smartphone = Object:extend()

function Smartphone:new()
  self.bank = Bank.get("game")

  self.position = {
    x = (conf.exports.width - self.bank.smartphone.image:getWidth()) / 2,
    y = conf.exports.height - self.bank.smartphone.image:getHeight() - 10,
  }

  self.backgroundPosition = {
    x = self.position.x + self.bank.smartphone.image:getWidth() / 2 - self.bank.smartphone.background:getWidth() / 2,
    y = self.position.y + self.bank.smartphone.image:getHeight() / 2 - self.bank.smartphone.background:getHeight() / 2,
  }
end

function Smartphone:update(dt)
end

function Smartphone:draw()
  love.graphics.draw(self.bank.smartphone.background, self.backgroundPosition.x, self.backgroundPosition.y)
  love.graphics.draw(self.bank.smartphone.image, self.position.x, self.position.y)
end

return Smartphone