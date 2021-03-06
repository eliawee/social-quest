local conf = require("conf")
local Animation = require("animation")
local List = require("list")
local Object = require("classic")

local bank = require("socialquest.bank")
local Card = require("socialquest.card")
local Button = require("socialquest.button")
local Constant = require("socialquest.constant")

local Smartphone = Object:extend()

function Smartphone:new(cardsProps)
  self:initPositions()
  self:initCards(cardsProps)
  self.button = Button("invoke", self)
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

function Smartphone:computeAciveSlotIndex(count)
  return math.ceil(count / 2)
end

function Smartphone:computeSlotPosition(index, activeSlotIndex)
  if index <= activeSlotIndex - 3 then
    return {
      x = -bank.card.gudboy:getWidth(),
      y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.gudboy:getHeight(),
    }
  elseif index == activeSlotIndex - 2 then
    return {
      x = self.position.x - Constant.Smartphone.ToCardSpace - Constant.Card.ToCardSpace - 2 * bank.card.gudboy:getWidth(),
      y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.gudboy:getHeight(),
    }
  elseif index == activeSlotIndex - 1 then
    return {
      x = self.position.x - Constant.Smartphone.ToCardSpace - bank.card.gudboy:getWidth(),
      y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.gudboy:getHeight(),
    }
  elseif index == activeSlotIndex then
    return {
      x = self.backgroundPosition.x,
      y = self.backgroundPosition.y,
    }
  elseif index == activeSlotIndex + 1 then
    return {
      x = self.position.x + Constant.Smartphone.ToCardSpace + bank.card.gudboy:getWidth(),
      y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.gudboy:getHeight(),
    }
  elseif index == activeSlotIndex + 2 then
    return {
      x = self.position.x + Constant.Smartphone.ToCardSpace + Constant.Card.ToCardSpace + 2 * bank.card.gudboy:getWidth(),
      y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.gudboy:getHeight(),
    }
  elseif index >= activeSlotIndex + 3 then
    return {
      x = conf.exports.width,
      y = conf.exports.height - Constant.Card.ScreenBottom - bank.card.gudboy:getHeight(),
    }
  end
end

function Smartphone:initSlots(count)
  local activeSlotIndex = self:computeAciveSlotIndex(count)
  local extraSideSlotsCount = math.ceil(count / 2)

  self.slots = List.range(1, count + 2 * extraSideSlotsCount):map(
    function (index)
      local realIndex = index - extraSideSlotsCount

      if realIndex < 1 then
        realIndex = 1
      elseif realIndex > count then
        realIndex = count
      end

      return {
        active = realIndex == activeSlotIndex,
        index = index,
        position = self:computeSlotPosition(realIndex, activeSlotIndex)
      }
    end
  ):list()
end

function Smartphone:initPositions()
  self:initPhonePositions()
  self:initPatchesPositions()
end

function Smartphone:initPatchesPositions()
  self.patch = {
    x = self.backgroundPosition.x,
    y = self.backgroundPosition.y + bank.smartphone.background:getHeight() - Constant.Smartphone.PatchHeight,
    width = bank.smartphone.background:getWidth(),
    height = Constant.Smartphone.PatchHeight
  }

  self.upPatch = {
    x = self.position.x,
    y = Constant.GroundTop + Constant.GroundHeight,
    width = bank.smartphone.image:getWidth(),
    height = self.backgroundPosition.y - (Constant.GroundTop + Constant.GroundHeight)
  }
end

function Smartphone:getEmptySlotForSwiping(direction)
  local emptySlot = nil

  for slot in (direction == Constant.Smartphone.Direction.Left and self.slots or self.slots:reverse()):values() do
    if slot.card then
      return emptySlot
    else
      emptySlot = slot
    end
  end
end

function Smartphone:swipeAnimation(direction)
  local slot = self:getEmptySlotForSwiping(direction)
  local animation = slot and self:recursiveGotoAnimation(slot, direction)

  if animation then
    animation.onComplete:listenOnce(
      function ()
        self:updateSlotsAfterSwiping(slot, direction)
      end
    )
  end

  return animation or Animation.Nop()
end

function Smartphone:initCards(cardsProps)
  self:initSlots(table.getn(cardsProps))

  for index, cardProps in pairs(cardsProps) do
    local slot = self.slots:get(index + math.floor(table.getn(cardsProps) / 2))

    slot.card = Card(cardProps, slot, self)
  end
end

function Smartphone:activeCard()
  local activeSlot = self.slots:find(
    function (slot)
      return slot.active
    end
  )

  return activeSlot and activeSlot.card
end

function Smartphone:cardsCount()
  local sum = function (acc, slot)
    return slot.card and acc + 1 or acc
  end

  return self.slots:reduce(sum, 0)
end

function Smartphone:update(dt)
  for slot in self.slots:values() do
    if slot.card then
      slot.card:update(dt)
    end
  end

  self.button:update(dt)
end

function Smartphone:getSwipeDirection(card)
  if card.slot.index == 1 then
    return Constant.Smartphone.Direction.Left
  elseif card.slot.index == self.slots:size() then
    return Constant.Smartphone.Direction.Right
  elseif self.slots:get(card.slot.index + 1).card then
    return Constant.Smartphone.Direction.Left
  else
    return Constant.Smartphone.Direction.Right
  end
end

function Smartphone:recursiveGotoAnimation(slot, direction)
  local nextSlot = self.slots:get(direction == Constant.Smartphone.Direction.Left and slot.index + 1 or slot.index - 1)
  local nextCard = nextSlot and nextSlot.card

  local animation = nextCard and Animation.Parallel({
    nextCard:gotoSlotAnimation(slot),
    self:recursiveGotoAnimation(nextCard.slot, direction)
  })

  return animation or Animation.Nop()
end

function Smartphone:updateSlotsAfterSwiping(slot, direction)
  local nextSlot = self.slots:get(direction == Constant.Smartphone.Direction.Left and slot.index + 1 or slot.index - 1)
  local nextCard = nextSlot and nextSlot.card

  slot.card = nil

  if nextCard then
    local previousSlot = nextCard.slot

    previousSlot.card = nil
    slot.card = nextCard
    nextCard:setSlot(slot)
    self:updateSlotsAfterSwiping(previousSlot, direction)
  end
end

function Smartphone:replaceActiveCardAnimation()
  local activeCard = self:activeCard()
  local direction = activeCard and self:getSwipeDirection(activeCard)
  local animation = Animation.Parallel({
    activeCard.symbol:fadeOutAnimation(),
    direction and self:recursiveGotoAnimation(activeCard.slot, direction) or Animation.Nop()
  })

  if direction then
    animation.onComplete:listenOnce(
      function ()
        self:updateSlotsAfterSwiping(activeCard.slot, direction)
      end
    )
  end

  return animation
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
  love.graphics.setColor(226 / 255, 237 / 255, 252 / 255, 1)
  love.graphics.rectangle("fill", self.upPatch.x, self.upPatch.y, self.upPatch.width, self.upPatch.height)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(bank.smartphone.image, self.position.x, self.position.y)

  for slot in self.slots:values() do
    if slot.card then
      slot.card.symbol:draw()
    end
  end

  self.button:draw()
end

return Smartphone