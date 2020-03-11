local peachy = require("peachy")
local Animation = require("animation")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")
local LifeBar = require("socialquest.lifebar")

local Character = Object:extend()

function Character:new()
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
  return self.lifeBar:hitAnimation(hit)
end

function Character:update(dt)
  self.sprite:update(dt)
  self.lifeBar:update(dt)
end

function Character:draw()
  self.sprite:draw(Constant.Character.PositionX, Constant.Character.PositionY)
  self.lifeBar:draw()
end

return Character