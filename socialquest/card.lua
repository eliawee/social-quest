local Animation = require("animation")
local Object = require("classic")

local bank = require("socialquest.bank")
local Symbol = require("socialquest.symbol")

local Card = Object:extend()

function Card:new(name, element, slot, smartphone)
  self.name = name
  self.element = element
  self.slot = slot
  self.position = self:cloneSlotPosition(slot)

  self.meta = {
    opacity = 1
  }

  self.symbol = Symbol(element, self, smartphone)
end

function Card:cloneSlotPosition(slot)
  return {
    x = slot.position.x,
    y = slot.position.y
  }
end

function Card:gotoSlotAnimation(slot)
  return Animation.Parallel({
    self.symbol:fadeOutAnimation(),
    Animation.Tween(0.3, self.position, self:cloneSlotPosition(slot), "outSine")
  })
end

function Card:slideUpAnimation()
  return Animation.Parallel({
    Animation.Tween(0.6, self.position, {y = self.position.y - bank.card[self.name]:getHeight()}),
    Animation.Tween(0.3, self.meta, {opacity = 0})
  })
  
end

function Card:update(dt)
  self.symbol:update(dt)
end

function Card:draw()
  love.graphics.setColor(1, 1, 1, self.meta.opacity)
  love.graphics.draw(bank.card[self.name], self.position.x, self.position.y)
  love.graphics.setColor(1, 1, 1, 1)
end

return Card