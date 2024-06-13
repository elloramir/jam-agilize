-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local Sprite = require("entities.sprite")
local Player = Sprite:extend()

function Player:new(x, y)
  Player.super.new(self, x, y)
  self:set_image(assets.player_car)

  self.spd_x = 0
  self.spd_y = 0
  self.max_spd = 200
  self.accel = 500
  self.frict = 100
end

local function approach(v1, v2, t)
  return v1 > v2 and math.max(v1 - t, v2) or math.min(v1 + t, v2)
end

function Player:update(dt)
  local dx, dy = 0, 0

  -- axis rotation
  if love.keyboard.isDown("d") then dx = dx + 1 end
  if love.keyboard.isDown("a") then dx = dx - 1 end

  -- accelerate
  if love.keyboard.isDown("s") then dy = dy + 1 end
  if love.keyboard.isDown("w") then dy = dy - 1 end

  -- apply acceleration
  self.spd_x = approach(self.spd_x, dx * self.max_spd, self.accel * dt)
  self.spd_y = approach(self.spd_y, dy * self.max_spd, self.accel * dt)

  -- apply friction
  if dx == 0 then self.spd_x = approach(self.spd_x, 0, self.frict * dt) end
  if dy == 0 then self.spd_y = approach(self.spd_y, 0, self.frict * dt) end

  -- look to the angle of movement
  if dx ~= 0 or dy ~= 0 then
    self.rotation = math.atan2(self.spd_y, self.spd_x)
  end

  -- update position
  self.x = self.x + self.spd_x * dt
  self.y = self.y + self.spd_y * dt
end

return Player

