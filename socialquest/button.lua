local peachy = require("peachy")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")

local Button = Object:extend()

function Button:new(name, smartphone)
  self.name = name

  self.sprites = {
    idle = peachy.new(bank.button[name].spec, bank.button[name].image, "Idle"),
    push = peachy.new(bank.button[name].spec, bank.button[name].image, "Push"),
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