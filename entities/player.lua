-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local level = require("level")
local Sprite = require("entities.sprite")
local Player = Sprite:extend()

function Player:new(x, y)
  Player.super.new(self, x, y)
  self:set_order(ORDER_PLAYER)
  self:set_image(assets.player_car)

  self.spd_x = 0
  self.spd_y = 0
  self.max_spd = 300
  self.accel = 500
  self.frict = 50

  self.trail_timer = 0
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

  -- normalize controls
  if dx ~= 0 and dy ~= 0 then
    dx = dx * 0.7071
    dy = dy * 0.7071
  end

  -- apply acceleration
  self.spd_x = approach(self.spd_x, dx * self.max_spd, self.accel * dt)
  self.spd_y = approach(self.spd_y, dy * self.max_spd, self.accel * dt)

  -- apply friction
  if dx == 0 then self.spd_x = approach(self.spd_x, 0, self.frict * dt) end
  if dy == 0 then self.spd_y = approach(self.spd_y, 0, self.frict * dt) end

  -- look to the angle of movement
  if dx ~= 0 or dy ~= 0 then
    self.rotation = math.atan2(self.spd_y, self.spd_x)

    if love.timer.getTime() - self.trail_timer >= 0.01 then
      self.trail_timer = love.timer.getTime()
      self:spawn_wheel_trails()    
    end
  end

  -- update position
  self.x = self.x + self.spd_x * dt
  self.y = self.y + self.spd_y * dt

  -- warp position
  if self.x < 0 then self.x = WIDTH end
  if self.x > WIDTH then self.x = 0 end
  if self.y < 0 then self.y = HEIGHT end
  if self.y > HEIGHT then self.y = 0 end

  -- engine sound
  do
    local strn = self:spd_strn()
    local volume = strn
    local mutation = love.math.noise(love.timer.getTime()) * 2 - 1
    local pitch = math.min(math.max(strn * 1.6 + mutation * 0.5, 0.5), 2)

    assets.engine_sfx:play()
    assets.engine_sfx:setVolume(volume)
    assets.engine_sfx:setPitch(pitch)
  end
end

function Player:spd_strn()
  return math.sqrt(self.spd_x * self.spd_x + self.spd_y * self.spd_y) / self.max_spd
end

function Player:spawn_wheel_trails()
  local strn = self:spd_strn()
  local t1_x = self.x + math.cos(self.rotation - math.pi / 2) * 7
  local t1_y = self.y + math.sin(self.rotation - math.pi / 2) * 7
  local t2_x = self.x + math.cos(self.rotation + math.pi / 2) * 7
  local t2_y = self.y + math.sin(self.rotation + math.pi / 2) * 7

  -- two trails for each wheel
  level.add_entity("trail", t1_x, t1_y, strn)
  level.add_entity("trail", t2_x, t2_y, strn)
end

return Player

