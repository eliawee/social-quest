local Animation = require("animation")
local Navigator = require("navigator")

local bank = require("socialquest.bank")
local input = require("socialquest.input")
local Character = require("socialquest.character")
local Constant = require("socialquest.constant")
local Finger = require("socialquest.finger")
local Monster = require("socialquest.monster")
local Smartphone = require("socialquest.smartphone")
local TinyCard = require("socialquest.tinycard")

local GameScreen = Navigator.Screen:extend()

function GameScreen:open()
  self.character = Character()
  self.finger = Finger()
  self.monster = Monster(Constant.Monster.ZombieChicken)
  self.smartphone = Smartphone()
end

function GameScreen:invokeCardAnimation(card)
  self.tinyCard = TinyCard(card.name)

  return Animation.Series({
    self.finger:moveToButtonAnimation(),
    Animation.Parallel({
      self.character:pushButtonAnimation(),
      self.smartphone.button:pushAnimation(),
      Animation.Series({
        Animation.Wait(0.1),
        Animation.Parallel({
          card.symbol:fadeOutAnimation(),
          self.finger:hideAnimation(),
          self.smartphone.button:fadeOutAnimation(),
          card:slideUpAnimation(),
        }),
        Animation.Parallel({
          card.symbol:fadeInSmartphoneAnimation(),
          self.tinyCard:slideDownAnimation()
        }),
        Animation.Wait(0.1),
        Animation.Parallel({
          self.tinyCard:scaleFadeOutAnimation(),
          Animation.Series({
            Animation.Wait(0.5),
            self.monster:hitAnimation()
          })
        }),
        Animation.Series({
          self.smartphone:replaceActiveCardAnimation(),
          self.smartphone:cardsCount() > 1 and self.smartphone.button:fadeInAnimation() or Animation.Nop(),
        })
      })
    }),
  })
end

function GameScreen:pressButton()
  local activeCard = self.smartphone:activeCard()

  if activeCard and not self.animation then
    self.animation = self:invokeCardAnimation(activeCard)

    self.animation.onComplete:listenOnce(
      function ()
        self.animation = nil
      end
    )

    self.animation:start()
  end
end

function GameScreen:update(dt)
  if input:pressed("action") then
    self:pressButton()
  end

  if self.animation then
    self.animation:update(dt)
  end

  self.character:update(dt)
  self.monster:update(dt)
  self.smartphone:update(dt)
  self.finger:update(dt)

  if self.tinyCard then
    self.tinyCard:update(dt)
  end
end

function GameScreen:draw()
  love.graphics.draw(bank.background)
  self.character:draw()
  self.monster:draw()
  self.smartphone:draw()
  self.finger:draw()

  if self.tinyCard then
    self.tinyCard:draw()
  end
end

return GameScreen