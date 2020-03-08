local peachy = require("peachy")
local Animation = require("animation")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")

local Button = Object:extend()

function Button:new(name, smartphone)
  self.name = name

  self.meta = {
    opacity = 1
  }

  self.sprites = {
    idle = peachy.new(bank.button[name].spec, bank.button[name].image, "idle"),
    push = peachy.new(bank.button[name].spec, bank.button[name].image, "push"),
  }

  self.sprites.push:onLoop(
    function ()
      self.sprites.push:stop()
      self.sprite = self.sprites.idle
    end
  )

  self.position = {
    x = smartphone.position.x + smartphone:getWidth() / 2 - self.sprites.idle:getWidth() / 2,
    y = smartphone.position.y + smartphone:getHeight() - self.sprites.idle:getHeight() - Constant.Smartphone.ToButtonSpace
  }

  self.sprite = self.sprites.idle
end

function Button:fadeOutAnimation()
  return Animation.Tween(0.3, self.meta, { opacity = 0 })
end

function Button:pushAnimation()
  local animation = Animation.Sprite(self.sprites.push)

  animation.onStart:listenOnce(
    function ()
      self.sprite = self.sprites.push
    end
  )

  return animation
end

function Button:update(dt)
  self.sprite:update(dt)
end

function Button:draw()
  love.graphics.setColor(1, 1, 1, self.meta.opacity)
  self.sprite:draw(self.position.x, self.position.y)
  love.graphics.setColor(1, 1, 1, 1)
end

return Button