local peachy = require("peachy")
local Object = require("classic")

local bank = require("socialquest.bank")

local Character = Object:extend()

function Character:new()
  self.sprite = peachy.new(bank.character.spec, bank.character.image, "idle")
end

function Character:update(dt)
  self.sprite:update(dt)
end

function Character:draw()
  self.sprite:draw(60, 20)
end

return Character