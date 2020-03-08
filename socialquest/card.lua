local peachy = require("peachy")
local Bank = require("bank")
local Object = require("classic")
local Constant = require("socialquest.constant")

local Card = Object:extend()

function Card:new(name, element, slot, smartphone)
  self.bank = Bank.get("game")
  self.name = name
  self.element = element
  self.slot = slot
  self.position = slot.position
  self.elementSymbolSprite = peachy.new(self.bank.element.spec, self.bank.element.image, self:getElementSymbolFramesTag())
  self.symbolPosition = {
    x = self.position.x + self.bank.card[self.name]:getWidth() / 2 - self.elementSymbolSprite:getWidth() / 2,
    y = (slot.active and smartphone.position.y or self.position.y) - Constant.Card.ToElementSpace - self.elementSymbolSprite:getHeight()
  }
end

function Card:getElementSymbolFramesTag()
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

function Card:update(dt)
  self.elementSymbolSprite:update(dt)
end

function Card:drawElementLine()
  if self.element == Constant.Element.Fire then
    love.graphics.setColor(223 / 255, 113 / 255, 38 / 255, 1)
  elseif self.element == Constant.Element.Water then
    love.graphics.setColor(99 / 255, 155 / 255, 255 / 255, 1)
  elseif self.element == Constant.Element.Electricity then
    love.graphics.setColor(251 / 255, 242 / 255, 54 / 255, 1)
  elseif self.element == Constant.Element.Wind then
    love.graphics.setColor(1, 1, 1, 1)
  elseif self.element == Constant.Element.Plant then
    love.graphics.setColor(153 / 255, 229 / 255, 80 / 255, 1)
  end

  love.graphics.rectangle("fill", self.position.x, self.position.y + Constant.Card.ToLineSpace, self.bank.card[self.name]:getWidth() - 1, 1)
  love.graphics.setColor(1, 1, 1, 1)
end


function Card:draw()
  love.graphics.draw(self.bank.card[self.name], self.position.x, self.position.y)

  self:drawElementLine()
  self.elementSymbolSprite:draw(self.symbolPosition.x, self.symbolPosition.y)
end

return Card