local conf = require("conf")
local Animation = require("animation")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")

local Finger = Object:extend()

function Finger:new()
  self.meta = {
    opacity = 1
  }

  self.position = self:getInitialPosition()
end

function Finger:getInitialPosition()
  return {
    x = (conf.exports.width - bank.finger:getWidth()) / 2 + Constant.Finger.ToCenterSpace + 5,
    y = conf.exports.height - 10
  }
end

function Finger:moveToButtonAnimation()
  return Animation.Tween(0.05, self.position, {y = self:getButtonY()})
end

function Finger:hideAnimation()
  return Animation.Tween(0.05, self.position, self:getInitialPosition())
end

function Finger:getButtonY()
  return conf.exports.height - Constant.Finger.ButtonBottom
end

function Finger:update(dt) end

function Finger:draw()
  love.graphics.draw(bank.finger, self.position.x, self.position.y)
end

return Finger