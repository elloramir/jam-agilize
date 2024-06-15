-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = require("level")
local assets = require("assets")
local Dude = require("entities.dude")
local Bullet = Dude:extend()

Bullet.max_speed = 800

function Bullet:new(from_x, from_y, to_x, to_y)
    Bullet.super.new(self, from_x, from_y, 10)
    self:set_order(ORDER_PLAYER + 1)

    self.rotation = math.atan2(to_y - from_y, to_x - from_x)
    self.spd_x = math.cos(self.rotation) * Bullet.max_speed
    self.spd_y = math.sin(self.rotation) * Bullet.max_speed

    self:set_image(assets.beam)
end

function Bullet:update(dt)
    Bullet.super.update(self, dt)

    self.x = self.x + self.spd_x * dt
    self.y = self.y + self.spd_y * dt

    self:query_area(self.radius)
end

function Bullet:query_callback(other)
    if other.is_enemy then
        other:hit(self)
        self:destroy()
    end
end

return Bullet