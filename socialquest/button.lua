local peachy = require("peachy")
local Bank = require("bank")
local Object = require("classic")
local Constant = require("socialquest.constant")

local Button = Object:extend()

function Button:new(name, smartphone)
  self.bank = Bank.get("game")
  self.name = name

  self.sprites = {
    idle = peachy.new(self.bank.button[name].spec, self.bank.button[name].image, "Idle"),
    push = peachy.new(self.bank.button[name].spec, self.bank.button[name].image, "Push"),
  }

  self.position = {
    x = smartphone.position.x + smartphone:getWidth() / 2 - self.sprites.idle:getWidth() / 2,
    y = smartphone.position.y + smartphone:getHeight() - self.sprites.idle:getHeight() - Constant.Smartphone.ToButtonSpace
  }


  self.sprite = self.sprites.idle
end

function Button:update(dt)
  self.sprite:update(dt)
end

function Button:draw()
  self.sprite:draw(self.position.x, self.position.y)
end

return Button