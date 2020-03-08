local conf = require("conf")
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
        x = self.position.x - Constant.Smartphone.PhoneToCardBorder - Constant.Smartphone.CardToCardBorder - 2 * self.bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - self.bank.card.kiki:getHeight(),
      }
    },
    {
      position = {
        x = self.position.x - Constant.Smartphone.PhoneToCardBorder - self.bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - self.bank.card.kiki:getHeight(),
      }
    },
    {
      position = {
        x = self.backgroundPosition.x,
        y = self.backgroundPosition.y,
      }
    },
    {
      position = {
        x = self.position.x + Constant.Smartphone.PhoneToCardBorder + self.bank.card.kiki:getWidth(),
        y = conf.exports.height - Constant.Card.ScreenBottom - self.bank.card.kiki:getHeight(),
      }
    },
    {
      position = {
        x = self.position.x + Constant.Smartphone.PhoneToCardBorder + Constant.Smartphone.CardToCardBorder + 2 * self.bank.card.kiki:getWidth(),
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
  for slot in self.slots:values() do
    slot.card = Smartphone.Card("kiki", Constant.Element.Fire)
    slot.card.position = slot.position
  end
end

function Smartphone:update(dt) end

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

function Smartphone.Card:new(name, element)
  self.bank = Bank.get("game")
  self.name = name
  self.element = element
  self.position = {x = 0, y = 0}
end

function Smartphone.Card:update(dt) end

function Smartphone.Card:draw(position)
  love.graphics.draw(self.bank.card[self.name], self.position.x, self.position.y)
end


return Smartphone