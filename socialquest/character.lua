local conf = require("conf")
local peachy = require("peachy")
local Bank = require("bank")
local Object = require("classic")

local Character = Object:extend()

function Character:new()
  self.bank = Bank.get("game")
  self.sprite = peachy.new(self.bank.character.spec, self.bank.character.image, "idle")
end

function Character:update(dt)
  self.sprite:update(dt)
end

function Character:draw()
  self.sprite:draw(60, 20)
end

return Character