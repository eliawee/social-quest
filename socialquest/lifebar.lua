local Animation = require("animation")
local Event = require("event")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")

local LifeBar = Object:extend()

function LifeBar:new(life, position)
  self.core = {
    life = life
  }

  self.meta = {
    opacity = 1
  }

  self.maxLife = life
  self.position = position
  self.progressMaxWidth = bank.lifebar:getWidth() - 2 * Constant.LifeBar.BorderSize
  self.progress = {
    x = position.x + Constant.LifeBar.BorderSize,
    y = position.y + Constant.LifeBar.BorderSize,
    width = self:computeProgressWidth(),
    height = bank.lifebar:getHeight() - 2 * Constant.LifeBar.BorderSize
  }
end

function LifeBar:hitAnimation(hit)
  local target = self.core.life > 0 and {life = hit < self.core.life and self.core.life - hit or 0}
  local animation = target and Animation.Tween(0.5, self.core, target)

  return animation or Animation.Nop
end

function LifeBar:isDead()
  return self.core.life == 0
end

function LifeBar:fadeOutAnimation()
  return Animation.Tween(0.1, self.meta, {opacity = 0})
end

function LifeBar:fadeInAnimation()
  return Animation.Tween(0.1, self.meta, {opacity = 1})
end

function LifeBar:hide()
  self.meta.opacity = 0
end

function LifeBar:computeProgressWidth()
  return math.ceil(self.core.life * self.progressMaxWidth / self.maxLife)
end

function LifeBar:update(dt)
  if self.animation then
    self.animation:update(dt)
  end

  self.progress.width = self:computeProgressWidth()
end

function LifeBar:draw()
  love.graphics.setColor(1, 1, 1, self.meta.opacity)
  love.graphics.draw(bank.lifebar, self.position.x, self.position.y)
  love.graphics.setColor(153 / 255, 229 / 255, 80 / 255, self.meta.opacity)
  love.graphics.rectangle("fill", self.progress.x, self.progress.y, self.progress.width, self.progress.height)
  love.graphics.setColor(1, 1, 1, 1)
end

return LifeBar

