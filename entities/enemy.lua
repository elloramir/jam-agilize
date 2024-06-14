-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local level = require("level")
local Dude = require("entities.dude")
local Enemy = Dude:extend()

Enemy.is_enemy = true
Enemy.friction = 100
Enemy.move_speed = 50

function Enemy:new(x, y)
    Enemy.super.new(self, x, y, 10)
    self:set_image(assets.enemies)
    self:set_order(ORDER_PLAYER - 0.1)
    self.has_died = false
    self.time_before_destroy = 3
    self.dumb_for_x_seconds = 0
    self.life_still = 2
end

function Enemy:kill()
    self.has_died = true
    level.add_entity("blood", self.x, self.y)
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)

    -- check for overlaps
    self:query_area(self.radius)

    if self.has_died then
        self.time_before_destroy = self.time_before_destroy - dt
        -- todo(ellora): change sprite
        self.color[4] = 0

        if self.time_before_destroy < 0 then
            self:destroy()
        end
    else
        if self.dumb_for_x_seconds > 0 then
            self.dumb_for_x_seconds = self.dumb_for_x_seconds - dt
            -- friction
            self.spd_x = approach(self.spd_x, 0, Enemy.friction * dt)
            self.spd_y = approach(self.spd_y, 0, Enemy.friction * dt)
        else
            -- look to player
            self.flip_x = level.player.x < self.x
            local target = math.atan2(level.player.y - self.y, level.player.x - self.x)
            self.rotation = lerp(self.rotation, target-math.pi/2, 5*dt)

            -- follow player
            self.spd_x = math.cos(target) * Enemy.move_speed
            self.spd_y = math.sin(target) * Enemy.move_speed
            self.solid_color = false
        end
    end

    self.x = self.x + self.spd_x * dt
    self.y = self.y + self.spd_y * dt
end

function Enemy:query_callback(other)
    if other.is_enemy or other.is_obstacle then
        -- repell this enemy from other enemies.
        local dx = self.x - other.x
        local dy = self.y - other.y
        local distance = math.sqrt(dx*dx + dy*dy)
        local overlap = self.radius + other.radius

        local angle = math.atan2(dy, dx)
        local push = overlap - distance

        self.x = self.x + math.cos(angle) * push
        self.y = self.y + math.sin(angle) * push
    end
end

function Enemy:hit(bullet)
    self.dumb_for_x_seconds = 0.3
    self.solid_color = true
    self:knockback(bullet.x, bullet.y, 100)
    level.add_entity("flash", self.x, self.y)

    -- todo(ellora): compute damage based on status
    self.life_still = self.life_still - 1

    if self.life_still <= 0 then
        self:kill()
    end

    level.add_entity("indicator", self.x, self.y, "hit!")
end

return Enemy