local conf = require("conf")
local Animation = require("animation")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")
local Symbol = require("socialquest.symbol")

local TinyCard = Object:extend()

function TinyCard:new(name)
  self.name = name

  self.meta = {
    opacity = 0,
    scale = Constant.TinyCard.Scale
  }

  self.centerPosition = {
    x = Constant.TinyCard.InvocationX,
    y = -bank.card[self.name]:getHeight() / 2,
  }

  self:computePosition()
end

function TinyCard:slideDownAnimation()
  return Animation.Parallel({
    Animation.Tween(0.3, self.meta, {opacity = 1}),
    Animation.Tween(0.6, self.centerPosition, {y = Constant.TinyCard.InvocationY}, "outBack")
  })
end

function TinyCard:scaleFadeOutAnimation()
  return Animation.Parallel({
    Animation.Tween(0.6, self.meta, {opacity = 0}),
    Animation.Tween(0.6, self.meta, {scale = 2}, "inBack")
  })
end

function TinyCard:computePosition()
  self.position = {
    x = self.centerPosition.x - (bank.card[self.name]:getWidth() / 2) * self.meta.scale,
    y = self.centerPosition.y - (bank.card[self.name]:getHeight() / 2) * self.meta.scale,
  }
end

function TinyCard:update(dt)
  self:computePosition()
end

function TinyCard:draw()
  love.graphics.setColor(1, 1, 1, self.meta.opacity)
  love.graphics.draw(bank.card[self.name], self.position.x, self.position.y, 0, self.meta.scale, self.meta.scale)
  love.graphics.setColor(1, 1, 1, 1)
end


return TinyCard