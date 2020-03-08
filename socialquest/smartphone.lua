local conf = require("conf")
local Bank = require("bank")
local List = require("list")
local Object = require("classic")
local Card = require("socialquest.card")
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
    slot.card = Card("kiki", elements[1], slot, self)

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

return Smartphone