local Animation = require("animation")
local Navigator = require("navigator")

local bank = require("socialquest.bank")
local input = require("socialquest.input")
local Card = require("socialquest.card")
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
  self.monster = Monster(Constant.Monster.Catato)
  self.smartphone = Smartphone({
    Constant.Card.Floof,
    Constant.Card.Jlo,
    Constant.Card.Gudboy,
    Constant.Card.Bill,
    Constant.Card.Croak,
  })
  self.animation = self.monster:fallOnGroundAnimation()
  self.animation:start()

  self.animation.onComplete:listenOnce(
    function ()
      self.animation = nil
    end
  )
end

function GameScreen:onMonsterDies()
  self.animation = self.monster:dieAnimation()
  self.animation:start()
end

function GameScreen:invokeCardAnimation(card)
  self.tinyCard = TinyCard(card)

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
            self.monster:computedHitAnimation(card.element)
          })
        }),
        self.smartphone:replaceActiveCardAnimation(),
      })
    }),
  })
end

function GameScreen:monsterFightBackAnimation()
  return Animation.Series({
    self.monster:attackAnimation(),
    self.character:hitAnimation(5),
    self.smartphone:cardsCount() > 1 and self.smartphone.button:fadeInAnimation() or Animation.Nop()  
  })
end

function GameScreen:monsterDieAnimation()
  self.nextMonster = Monster(Constant.Monster.ZombieChicken)

  local animation = Animation.Series({
    self.monster:dieAnimation(),
    Animation.Wait(1),
    self.nextMonster:fallOnGroundAnimation(),
    self.smartphone:cardsCount() > 1 and self.smartphone.button:fadeInAnimation() or Animation.Nop()  
  })

  animation.onComplete:listenOnce(
    function ()
      self.monster = self.nextMonster
      self.nextMonster = nil
    end
  )

  return animation
end

function GameScreen:postAttack()
  self.animation = self.monster.lifeBar:isDead() and self:monsterDieAnimation() or self:monsterFightBackAnimation()

  self.animation.onComplete:listenOnce(
    function ()
      self.animation = nil        
    end
  )

  self.animation:start()
end

function GameScreen:pressButton()
  local activeCard = self.smartphone:activeCard()

  if activeCard and not self.animation then
    self.animation = self:invokeCardAnimation(activeCard)

    self.animation.onComplete:listenOnce(
      function ()
        self:postAttack()
      end
    )

    self.animation:start()
  end
end

function GameScreen:swipe(direction)
  if not self.animation then
    self.animation = self.smartphone:swipeAnimation(direction)

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
  elseif input:pressed("left") then
    self:swipe(Constant.Smartphone.Direction.Right)
  elseif input:pressed("right") then
    self:swipe(Constant.Smartphone.Direction.Left)
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

  if self.nextMonster then
    self.nextMonster:update(dt)
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

  if self.nextMonster then
    self.nextMonster:draw()
  end
end

return GameScreen