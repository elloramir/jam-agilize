-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local level = require("level")
local Dude = require("entities.dude")
local Enemy = Dude:extend()

Enemy.is_enemy = true

function Enemy:new(x, y)
    Enemy.super.new(self, x, y, 10)
    self:set_image(assets.enemies)
    self:set_order(ORDER_PLAYER - 0.1)
    self.has_died = false
    self.time_before_destroy = 3
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
    end

    -- look to player
    self.flip_x = level.player.x < self.x
    local target = math.atan2(level.player.y - self.y, level.player.x - self.x) - math.pi/2
    self.rotation = lerp(self.rotation, target, 5*dt)

    -- follow player
    local speed = 50
    self.x = self.x + math.cos(self.rotation + math.pi/2) * speed * dt
    self.y = self.y + math.sin(self.rotation + math.pi/2) * speed * dt
end

function Enemy:query_callback(other)
    if other.is_enemy or other.is_obstacle then
        -- repell me from other enemies.
        -- it's very important to repell only the exactlly collsiion size
        -- otherwise the enemies will repell each other forever.
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

return Enemy