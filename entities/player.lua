-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local level = require("level")
local Dude = require("entities.dude")
local Player = Dude:extend()

function Player:new(x, y)
  Player.super.new(self, x, y, 15)
  self:set_order(ORDER_PLAYER)
  self:set_image(assets.player_car)

  self.spd_x = 0
  self.spd_y = 0
  self.accel = 500
  self.frict = 50

  self.bullets_per_shot = 1
  self.max_spd = 100
  self.fire_rate = 1
  self.life_still = 5
  self.max_life = 5
  self.damage = 5

  self.trail_timer = 0
  self.lost_control_for = 0
  self.blink_timer = 0
  self.forced_rotation = 0
  self.last_msg_time = 0
  self.last_shot_time = 0
end

function Player:update(dt)
  Player.super.update(self, dt)
  
  local dx, dy = 0, 0

  -- lost control
  if self.lost_control_for <= 0 then
    -- axis rotation
    if love.keyboard.isDown("d") then dx = dx + 1 end
    if love.keyboard.isDown("a") then dx = dx - 1 end

    -- accelerate
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("w") then dy = dy - 1 end
  else
    self.lost_control_for = self.lost_control_for - dt
  end

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
  self:engine_sound()

  -- query enemies around to check collisions
  self:query_area(self.radius)

  -- rotate car
  if self.forced_rotation ~= 0 then
    self.rotation = self.forced_rotation
    self.forced_rotation = approach(self.forced_rotation, 0, dt*30)
  end

  -- choose a random enemy to shoot
  self:shoot_random_enemy()
end

function Player:query_callback(other)
  if other.is_obstacle then
    self:play_crash_snd()
    self:knockback(other.x, other.y, 200)
    self:make_lost_control()
    self:spawn_ouch_msg("ouch!")
  elseif other.is_enemy then
    self:run_over_ped(other)
  end
end

function Player:shoot_random_enemy()
  if love.timer.getTime() - self.last_shot_time < self.fire_rate then return end

  local enemies = {}

  for _, en in ipairs(level.entities) do
    if en.is_enemy and not en.has_died then
      local dx = en.x - self.x
      local dy = en.y - self.y
      local distance = math.sqrt(dx*dx + dy*dy)

      if distance < 200 then
        table.insert(enemies, en)
      end
    end
  end

  for i = 1, self.bullets_per_shot do
    if #enemies == 0 then return end

    local en = enemies[math.random(1, #enemies)]
    level.add_entity("bullet", self.x, self.y, en.x, en.y)
    self:play_shoot_snd()
  end

  self.last_shot_time = love.timer.getTime()
end

function Player:play_shoot_snd()
  local snd = math.random() > 0.5 and assets.sfx_shoot_1 or assets.sfx_shoot_2
  local smp = snd:play()
  if smp then
    smp:setPitch(rand_float(0.7, 0.9))
  end
end

function Player:spawn_ouch_msg(text)
   if love.timer.getTime() - self.last_msg_time < 0.25 then return end
   
    self.last_msg_time = love.timer.getTime()
    level.add_entity("indicator", self.x, self.y, text)
end

function Player:gamve_over()
  for _, en in ipairs(level.entities) do
    en.enabled = false
  end

  assets.engine_sfx:stop()
  assets.sfx_gameover:play()
  level.add_entity("gameover")
end

function Player:run_over_ped(ped)
  if not ped.has_died then
    -- check if the player is still alive
    self.life_still = self.life_still - 1
    if self.life_still <= 0 then
      self:gamve_over()
    end

    -- play hit sound
    local smp = assets.sfx_body_hit:play()
    if smp then
      smp:setPitch(1 - math.random() * 0.3)
    end

    -- kill this motherfucker
    ped:kill()

    -- nerf speed
    self.spd_x = self.spd_x * 0.8
    self.spd_y = self.spd_y * 0.8
    -- visualy explain that you lost something doing it
    self.blink_timer = 0.25
  end
end

function Player:engine_sound()
  local strn = self:spd_strn()
  local volume = strn
  local mutation = love.math.noise(love.timer.getTime()) * 2 - 1
  local pitch = math.min(math.max(strn * 1.6 + mutation * 0.5, 0.5), 2)

  assets.engine_sfx:play()
  assets.engine_sfx:setVolume(volume)
  assets.engine_sfx:setPitch(pitch)
end

function Player:take_damage(v)
  self.blink_timer = 0.5
end

function Player:play_crash_snd()
  local i = math.random(1, 3)
  local snd = assets["sfx_crash_"..i]
  local strn = self:spd_strn()
  local smp = snd:play()

  if not smp then return end

  smp:setVolume(strn)
  smp:setPitch(strn * 0.5 + 1)
end

function Player:make_lost_control()
  -- make it uncontrollable for a while
  self.forced_rotation = math.random(-5, 5)
  self.lost_control_for = 0.5
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

