local peachy = require("peachy")
local Animation = require("animation")
local Event = require("event")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")
local LifeBar = require("socialquest.lifebar")
local ShieldBar = require("socialquest.shieldbar")

local Monster = Object:extend()

function Monster:new(props)
  self.name = props.Name
  self.sprites = {
    idle = peachy.new(
      bank.monster[self.name].spec,
      bank.monster[self.name].image,
      "idle"
    ),
    attack = peachy.new(
      bank.monster[self.name].spec,
      bank.monster[self.name].image,
      "attack"
    ),
  }

  self.sprites.attack:onLoop(
    function ()
      self.sprites.attack:stop()
      self.sprite = self.sprites.idle
    end
  )

  self.meta = {
    drawColor = {1, 1, 1},
    opacity = 1
  }

  self.sprite = self.sprites.idle

  self.position = {
    x = Constant.Monster.Left,
    y = - self.sprites.idle:getHeight()
  }

  self.maxLife = props.Life
  self.lifeBar = LifeBar(props.Life, {
    x = self.position.x + props.ToLeftEdgeSpace,
    y = Constant.LifeBar.PositionY
  })

  self.shieldBar = ShieldBar(props.Shields, {
    x = self.position.x + props.ToLeftEdgeSpace,
    y = Constant.ShieldBar.PositionY
  })

  self.lifeBar:hide()
  self.shieldBar:hide()
end

function Monster:computedHitAnimation(element)
  local isBreakingShield = self.shieldBar:isBreakingActiveShield(element)

  return self.shieldBar:hasShield() and Animation.Parallel({
    isBreakingShield and  self.shieldBar:breakShieldAnimation(element) or Animation.Nop(),
    isBreakingShield and self:hitAnimation(self.maxLife / 6) or Animation.Nop()
  }) or self:hitAnimation(self.maxLife)
end

function Monster:fallOnGroundAnimation()
  return Animation.Series({
    Animation.Tween(0.3, self.position, {y = Constant.GroundTop - self.sprites.idle:getHeight()}),
    Animation.Wait(0.3),
    Animation.Parallel({
      self.lifeBar:fadeInAnimation(),
      self.shieldBar:fadeInAnimation(),
    })
  })
end

function Monster:dieAnimation()
  return Animation.Parallel({
    Animation.Parallel({
      self.lifeBar:fadeOutAnimation(),
      self.shieldBar:fadeOutAnimation(),
    }),
    Animation.Series({
      Animation.Tween(0.15, self.meta, {opacity = 0}, "inQuint"),
      Animation.Tween(0.15, self.meta, {opacity = 1}, "inQuint"),
      Animation.Tween(0.07, self.meta, {opacity = 0}, "inQuint"),
      Animation.Tween(0.07, self.meta, {opacity = 1}, "inQuint"),
      Animation.Tween(0.03, self.meta, {opacity = 0}, "inQuint"),
      Animation.Tween(0.03, self.meta, {opacity = 1}, "inQuint"),
      Animation.Tween(0.01, self.meta, {opacity = 0}, "inQuint"),
      Animation.Tween(0.01, self.meta, {opacity = 1}, "inQuint"),
      Animation.Tween(0.005, self.meta, {opacity = 0}, "inQuint"),
      Animation.Tween(0.005, self.meta, {opacity = 1}, "inQuint"),
      Animation.Tween(0.001, self.meta, {opacity = 0}, "inQuint"),
    })
  })
end

function Monster:attackAnimation()
  local animation = Animation.Sprite(self.sprites.attack)

  animation.onStart:listenOnce(
    function ()
      self.sprite = self.sprites.attack
    end
  )

  return animation
end

function Monster:hitAnimation(hit)
  local redDrawColor = {1, 0.6, 0.6}
  local resetColor = {1, 1, 1}

  return Animation.Parallel({
    Animation.Series({
      Animation.Tween(0.05, self.meta, {drawColor = redDrawColor}, "inQuint"),
      Animation.Tween(0.05, self.meta, {drawColor = resetColor}, "inQuint"),
      Animation.Tween(0.05, self.meta, {drawColor = redDrawColor}, "inQuint"),
      Animation.Tween(0.05, self.meta, {drawColor = resetColor}, "inQuint"),
      Animation.Tween(0.05, self.meta, {drawColor = redDrawColor}, "inQuint"),
      Animation.Tween(0.05, self.meta, {drawColor = resetColor}, "inQuint"),
    }),
    self.lifeBar:hitAnimation(hit)
  })
end

function Monster:update(dt)
  self.sprite:update(dt)
  self.lifeBar:update(dt)
  self.shieldBar:update(dt)
end

function Monster:draw()
  love.graphics.setColor(self.meta.drawColor[1], self.meta.drawColor[2], self.meta.drawColor[3], self.meta.opacity)
  self.sprite:draw(self.position.x, self.position.y)
  love.graphics.setColor(1, 1, 1, 1)
  self.lifeBar:draw()
  self.shieldBar:draw()
end

return Monster