local peachy = require("peachy")
local Animation = require("animation")
local Object = require("classic")
local List = require("list")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")

local ShieldBar = Object:extend()

function ShieldBar:new(elements, position)
  self.meta = {
    opacity = 1
  }

  local index = 0

  self.position = position
  self.shields = List(elements):map(
    function (element)
      index = index + 1

      local sprite = peachy.new(bank.shieldElement.spec, bank.shieldElement.image, self:getFramesTag(element))

      return {
        element = element,
        opacity = 1,
        position = {
          x = self.position.x + bank.shield:getWidth() + Constant.ShieldBar.BetweenShieldSpace * index + sprite:getWidth() * (index - 1),
          y = self.position.y + bank.shield:getHeight() / 2 - sprite:getHeight() / 2
        },
        sprite = sprite,
      }
    end
  ):list()
end

function ShieldBar:breakShieldAnimation()
  local activeShield = self.shields:last()
  local animation = activeShield and Animation.Tween(0.3, activeShield, {opacity = 0})

  if animation then
    animation.onComplete:listenOnce(
      function ()
        self.shields:pop()
      end
    )
  end

  return animation or Animation.Nop
end

function ShieldBar:hasShield()
  return self.shields:size() > 0
end

function ShieldBar:isBreakingActiveShield(element)
  local activeShield = self.shields:last()

  return activeShield and self:isBreakingShield(activeShield, element)
end

function ShieldBar:isBreakingShield(shield, element)
  return (shield.element == Constant.Element.Fire and element == Constant.Element.Water)
    or (shield.element == Constant.Element.Water and element == Constant.Element.Electricity)
    or (shield.element == Constant.Element.Electricity and element == Constant.Element.Ground)
    or (shield.element == Constant.Element.Ground and element == Constant.Element.Plant)
    or (shield.element == Constant.Element.Plant and element == Constant.Element.Fire)
end

function ShieldBar:fadeOutAnimation()
  return Animation.Tween(0.1, self.meta, {opacity = 0})
end

function ShieldBar:fadeInAnimation()
  return Animation.Tween(0.1, self.meta, {opacity = 1})
end

function ShieldBar:hide()
  self.meta.opacity = 0
end

function ShieldBar:getFramesTag(element)
  if element == Constant.Element.Fire then
    return "fire"
  elseif element == Constant.Element.Water then
    return "water"
  elseif element == Constant.Element.Electricity then
    return "thunder"
  elseif element == Constant.Element.Ground then
    return "ground"
  elseif element == Constant.Element.Plant then
    return "plant"
  end
end


function ShieldBar:update(dt)
end

function ShieldBar:draw()
  love.graphics.setColor(1, 1, 1, self.meta.opacity)
  love.graphics.draw(bank.shield, self.position.x, self.position.y)
  love.graphics.setColor(1, 1, 1, 1)

  for shield in self.shields:values() do
    love.graphics.setColor(1, 1, 1, self.meta.opacity * shield.opacity)
    shield.sprite:draw(shield.position.x, shield.position.y)
    love.graphics.setColor(1, 1, 1, 1)
  end

end

return ShieldBar