local peachy = require("peachy")
local Animation = require("animation")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")

local Symbol = Object:extend()

function Symbol:new(element, card, smartphone)
  self.element = element
  self.card = card
  self.smartphone = smartphone
  self.meta = {
    opacity = 1,
    scale = 1
  }

  self.sprite = peachy.new(bank.element.spec, bank.element.image, self:getFramesTag())
  self.centerPosition = {
    x = self.card.position.x + bank.card[card.name]:getWidth() / 2,
    y = (self.card.slot.active and smartphone.position.y or self.card.position.y) - Constant.Card.ToElementSpace - self.sprite:getHeight() / 2
  }

  self:computePosition()
end

function Symbol:fadeOutAnimation()
 return Animation.Tween(0.1, self.meta, {opacity = 0})
end

function Symbol:fadeInSmartphoneAnimation()
  local animation = Animation.Parallel({
    Animation.Tween(0.3, self.meta, {opacity = 1}),

    Animation.Series({
      Animation.Tween(0.2, self.meta, {scale = 2}, "outBack"),
      Animation.Tween(0.2, self.meta, {scale = 1}, "outBack")
    })
  })
  

  animation.onStart:listenOnce(
    function ()
      self.meta.scale = 0
      self.centerPosition = {
        x = self.smartphone.position.x + self.smartphone:getWidth() / 2,
        y = self.smartphone.position.y + self.smartphone:getHeight() / 2
      }    
    end
  )

  return animation
 end
 
function Symbol:getFramesTag()
  if self.element == Constant.Element.Fire then
    return "fire"
  elseif self.element == Constant.Element.Water then
    return "water"
  elseif self.element == Constant.Element.Electricity then
    return "thunder"
  elseif self.element == Constant.Element.Wind then
    return "wind"
  elseif self.element == Constant.Element.Plant then
    return "plant"
  end
end

function Symbol:update(dt)
  self.sprite:update(dt)
  self:computePosition()
end

function Symbol:computePosition()
  self.position = {
    x = self.centerPosition.x - (self.sprite:getWidth() / 2) * self.meta.scale,
    y = self.centerPosition.y - (self.sprite:getHeight() / 2) * self.meta.scale,
  }
end

function Symbol:draw()
  love.graphics.setColor(1, 1, 1, self.meta.opacity)
  self.sprite:draw(self.position.x, self.position.y, 0, self.meta.scale, self.meta.scale)
  love.graphics.setColor(1, 1, 1, 1)
end

return Symbol