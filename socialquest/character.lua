local peachy = require("peachy")
local Animation = require("animation")
local Object = require("classic")

local bank = require("socialquest.bank")

local Character = Object:extend()

function Character:new()
  self.sprites = {
    idle = peachy.new(bank.character.spec, bank.character.image, "idle"),
    attack = peachy.new(bank.character.spec, bank.character.image, "attack"),
  }

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

function Character:update(dt)
  self.sprite:update(dt)
end

function Character:draw()
  self.sprite:draw(60, 20)
end

return Character