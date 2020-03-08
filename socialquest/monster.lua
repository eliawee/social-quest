local peachy = require("peachy")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")

local Monster = Object:extend()

function Monster:new(props)
  self.name = props.name
  self.sprites = {
    idle = peachy.new(
      bank.monster[self.name].spec,
      bank.monster[self.name].image,
      "idle"
    ),
  }

  self.sprite = self.sprites.idle
  self.position = {
    x = Constant.Monster.Left,
    y = Constant.GroundTop - self.sprites.idle:getHeight()
  }
end

function Monster:update(dt)
  self.sprite:update(dt)
end

function Monster:draw()
  self.sprite:draw(self.position.x, self.position.y)
end

return Monster