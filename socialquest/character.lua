local peachy = require("peachy")
local Animation = require("animation")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")
local LifeBar = require("socialquest.lifebar")

local Character = Object:extend()

function Character:new()
  self.meta = {
    drawColor = {1, 1, 1},
    opacity = 1
  }

  self.sprites = {
    idle = peachy.new(bank.character.spec, bank.character.image, "idle"),
    attack = peachy.new(bank.character.spec, bank.character.image, "attack"),
  }

  self.lifeBar = LifeBar(Constant.Character.Life, {
    x = Constant.Character.PositionX + self.sprites.idle:getWidth() - bank.lifebar:getWidth() - Constant.Character.ToRightEdgeSpace,
    y = Constant.LifeBar.PositionY
  })

  self.sprites.attack:onLoop(
    function ()
      self.sprites.attack:stop()
      self.sprite = self.sprites.idle
    end
  )

  self.sprite = self.sprites.idle
end

function Character:pushButtonAnimation()
  local animation = Animation.Sprite(self.sprites.attack)

  animation.onStart:listenOnce(
    function ()
      self.sprite = self.sprites.attack
    end
  )

  return animation
end

function Character:hitAnimation(hit)
  local redDrawColor = {1, 0, 0}
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

function Character:update(dt)
  self.sprite:update(dt)
  self.lifeBar:update(dt)
end

function Character:draw()
  love.graphics.setColor(self.meta.drawColor[1], self.meta.drawColor[2], self.meta.drawColor[3], self.meta.opacity)
  self.sprite:draw(Constant.Character.PositionX, Constant.Character.PositionY)
  love.graphics.setColor(1, 1, 1, 1)
  self.lifeBar:draw()
end

return Character