local peachy = require("peachy")
local Animation = require("animation")
local Object = require("classic")

local bank = require("socialquest.bank")
local Constant = require("socialquest.constant")
local LifeBar = require("socialquest.lifebar")

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

  self.meta = {
    drawColor = {1, 1, 1},
    opacity = 1
  }

  self.sprite = self.sprites.idle
  self.position = {
    x = Constant.Monster.Left,
    y = Constant.GroundTop - self.sprites.idle:getHeight()
  }

  self.lifeBar = LifeBar(props.Life, {
    x = self.position.x + props.ToLeftEdgeSpace,
    y = Constant.LifeBar.PositionY
  })
end

function Monster:hitAnimation()
  local redDrawColor = {1, 0.6, 0.6}
  local resetColor = {1, 1, 1}

  return Animation.Series({
    Animation.Tween(0.05, self.meta, {drawColor = redDrawColor}, "inQuint"),
    Animation.Tween(0.05, self.meta, {drawColor = resetColor}, "inQuint"),
    Animation.Tween(0.05, self.meta, {drawColor = redDrawColor}, "inQuint"),
    Animation.Tween(0.05, self.meta, {drawColor = resetColor}, "inQuint"),
    Animation.Tween(0.05, self.meta, {drawColor = redDrawColor}, "inQuint"),
    Animation.Tween(0.05, self.meta, {drawColor = resetColor}, "inQuint"),
  })
end

function Monster:update(dt)
  self.sprite:update(dt)
  self.lifeBar:update(dt)
end

function Monster:draw()
  love.graphics.setColor(self.meta.drawColor[1], self.meta.drawColor[2], self.meta.drawColor[3], self.meta.opacity)
  self.sprite:draw(self.position.x, self.position.y)
  love.graphics.setColor(1, 1, 1, 1)
  self.lifeBar:draw()
end

return Monster