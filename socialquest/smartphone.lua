local conf = require("conf")
local List = require("list")
local Object = require("classic")

local bank = require("socialquest.bank")
local Button = require("socialquest.button")
local Card = require("socialquest.card")
local Constant = require("socialquest.constant")

local Smartphone = Object:extend()

function Smartphone:new()
  self:initPositions()
  self:initCards()
  self.button = Button("follow", self)
end

function Smartphone:getSlot(index)
  return self.slots:get(index)
end

function Smartphone:getWidth()
  return bank.smartphone.image:getWidth()
end

function Smartphone:getHeight()
  return bank.smartphone.image:getHeight()
end

function Smartphone:initPhonePositions()
  self.position = {
    x = (conf.exports.width - bank.smartphone.image:getWidth()) / 2,
    y = conf.exports.height - bank.smartphone.image:getHeight() - Constant.Smartphone.ScreenBottom,
  }

  self.backgroundPosition = {
    x = self.position.x + bank.smartphone.image:getWidth() / 2 - bank.smartphone.background:getWidth() / 2,
    y = self.position.y + bank.smartphone.image:getHeight() / 2 - bank.smartphone.background:getHeight() / 2,
  }
end

function Smartphone:initSlotsPositions()
  self.slots = List({
    {
      index = 1,
      position = {
        x = self.position.x - Constant.Smartphone.ToCardSpace - Constant.Card.ToCardSpace - 2 * bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.kiki:getHeight(),
      }
    },
    {
      index = 2,
      position = {
        x = self.position.x - Constant.Smartphone.ToCardSpace - bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.kiki:getHeight(),
      }
    },
    {
      index = 3,
      active = true,
      position = {
        x = self.backgroundPosition.x,
        y = self.backgroundPosition.y,
      }
    },
    {
      index = 4,
      position = {
        x = self.position.x + Constant.Smartphone.ToCardSpace + bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.kiki:getHeight(),
      }
    },
    {
      index = 5,
      position = {
        x = self.position.x + Constant.Smartphone.ToCardSpace + Constant.Card.ToCardSpace + 2 * bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.kiki:getHeight(),
      }
    }
  })
end

function Smartphone:initPositions()
  self:initPhonePositions()
  self:initSlotsPositions()

  self.patch = {
    x = self.backgroundPosition.x,
    y = self.backgroundPosition.y + bank.smartphone.background:getHeight() - Constant.Smartphone.PatchHeight,
    width = bank.smartphone.background:getWidth(),
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
    slot.card = Card("kiki", elements[1], slot, self)

    table.remove(elements, 1)
  end
end

function Smartphone:pushButtonAnimation()
  return self.button:pushAnimation()
end

function Smartphone:update(dt)
  for slot in self.slots:values() do
    if slot.card then
      slot.card:update(dt)
    end
  end

  self.button:update(dt)
end

function Smartphone:draw()
  love.graphics.draw(bank.smartphone.background, self.backgroundPosition.x, self.backgroundPosition.y)
  
  for slot in self.slots:values() do
    if slot.card then
      slot.card:draw()
    end
  end

  love.graphics.setColor(203 / 255, 219 / 255, 252 / 255, 1)
  love.graphics.rectangle("fill", self.patch.x, self.patch.y, self.patch.width, self.patch.height)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(bank.smartphone.image, self.position.x, self.position.y)

  self.button:draw()
end

return Smartphone