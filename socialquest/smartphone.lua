local conf = require("conf")
local peachy = require("peachy")
local Bank = require("bank")
local List = require("list")
local Object = require("classic")
local Constant = require("socialquest.constant")

local Smartphone = Object:extend()

function Smartphone:new()
  self.bank = Bank.get("game")
  self:initPositions()
  self:initCards()
end

function Smartphone:initPhonePositions()
  self.position = {
    x = (conf.exports.width - self.bank.smartphone.image:getWidth()) / 2,
    y = conf.exports.height - self.bank.smartphone.image:getHeight() - Constant.Smartphone.ScreenBottom,
  }

  self.backgroundPosition = {
    x = self.position.x + self.bank.smartphone.image:getWidth() / 2 - self.bank.smartphone.background:getWidth() / 2,
    y = self.position.y + self.bank.smartphone.image:getHeight() / 2 - self.bank.smartphone.background:getHeight() / 2,
  }
end

function Smartphone:initSlotsPositions()
  self.slots = List({
    {
      position = {
        x = self.position.x - Constant.Smartphone.ToCardSpace - Constant.Card.ToCardSpace - 2 * self.bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - self.bank.card.kiki:getHeight(),
      }
    },
    {
      position = {
        x = self.position.x - Constant.Smartphone.ToCardSpace - self.bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - self.bank.card.kiki:getHeight(),
      }
    },
    {
      active = true,
      position = {
        x = self.backgroundPosition.x,
        y = self.backgroundPosition.y,
      }
    },
    {
      position = {
        x = self.position.x + Constant.Smartphone.ToCardSpace + self.bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - self.bank.card.kiki:getHeight(),
      }
    },
    {
      position = {
        x = self.position.x + Constant.Smartphone.ToCardSpace + Constant.Card.ToCardSpace + 2 * self.bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - self.bank.card.kiki:getHeight(),
      }
    }
  })
end

function Smartphone:initPositions()
  self:initPhonePositions()
  self:initSlotsPositions()

  self.patch = {
    x = self.backgroundPosition.x,
    y = self.backgroundPosition.y + self.bank.smartphone.background:getHeight() - Constant.Smartphone.PatchHeight,
    width = self.bank.smartphone.background:getWidth(),
    height = Constant.Smartphone.PatchHeight
  }
end

function Smartphone:initCards()
  local elements = {
    Constant.Element.Fire,
    Constant.Element.Water,
    Constant.Element.Electricity,
    Constant.Element.Wind,
    Constant.Element.Plant
  }

  for slot in self.slots:values() do
    slot.card = Smartphone.Card("kiki", elements[1], slot, self)

    table.remove(elements, 1)
  end
end

function Smartphone:update(dt)
  for slot in self.slots:values() do
    if slot.card then
      slot.card:update(dt)
    end
  end
end

function Smartphone:draw()
  love.graphics.draw(self.bank.smartphone.background, self.backgroundPosition.x, self.backgroundPosition.y)
  
  for slot in self.slots:values() do
    if slot.card then
      slot.card:draw()
    end
  end

  love.graphics.setColor(203 / 255, 219 / 255, 252 / 255, 1)
  love.graphics.rectangle("fill", self.patch.x, self.patch.y, self.patch.width, self.patch.height)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.bank.smartphone.image, self.position.x, self.position.y)
end

Smartphone.Card = Object:extend()

function Smartphone.Card:new(name, element, slot, smartphone)
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

function Smartphone.Card:getElementSymbolFramesTag()
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

function Smartphone.Card:update(dt)
  self.elementSymbolSprite:update(dt)
end

function Smartphone.Card:drawElementLine()
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


function Smartphone.Card:draw()
  love.graphics.draw(self.bank.card[self.name], self.position.x, self.position.y)

  self:drawElementLine()
  self.elementSymbolSprite:draw(self.symbolPosition.x, self.symbolPosition.y)
end


return Smartphone