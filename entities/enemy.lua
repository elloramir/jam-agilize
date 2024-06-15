-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local level = require("level")
local Dude = require("entities.dude")
local Enemy = Dude:extend()

Enemy.is_enemy = true
Enemy.friction = 100
Enemy.move_speed = 50

local function random_pos_outside_screen()
    local x, y = 0, 0
    local side = math.random(1, 4)

    if side == 1 then x = math.random(-100, WIDTH + 100); y = -100
    elseif side == 2 then x = math.random(-100, WIDTH + 100); y = HEIGHT + 100
    elseif side == 3 then x = -100; y = math.random(-100, HEIGHT + 100)
    elseif side == 4 then x = WIDTH + 100; y = math.random(-100, HEIGHT + 100)
    end

    return x, y
end

function Enemy:new(index, horde)
    local x, y = random_pos_outside_screen()

    Enemy.super.new(self, x, y, 10)
    self:set_image(assets.enemies, 0.1)
    self:set_order(ORDER_PLAYER - 0.1)
    self.has_died = false
    self.time_before_destroy = 3
    self.dumb_for_x_seconds = 0
    self.max_life = math.floor(5 * 1.5^(horde-1) * 0.7)
    self.life_still = self.max_life

    local sub_horde = math.floor(index/10)
    self.wait_til_sub_horde = sub_horde * 10 -- 10 seconds between each horde
end

function Enemy:kill()
    self.has_died = true
    level.add_entity("blood", self.x, self.y)
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)

    if self.wait_til_sub_horde > 0 then
        self.wait_til_sub_horde = self.wait_til_sub_horde - dt
        return
    end

    -- check for overlaps
    self:query_area(self.radius)

    if self.has_died then
        self.time_before_destroy = self.time_before_destroy - dt
        -- todo(ellora): change sprite
        self.color[4] = 0

        if self.time_before_destroy < 0 then
            level.horders.total_enemies = level.horders.total_enemies - 1
            if level.horders.total_enemies == 0 then
                level.horders:spawn_cards()
            end
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

    self.life_still = self.life_still - level.player.damage

    if self.life_still <= 0 then
        self:kill()
    end

    level.add_entity("indicator", self.x, self.y, "hit!")
end

function Enemy:post_draw()
    if self.has_died then
        return
    end

    local x = self.x - 10
    local y = self.y - 20
    local percent = self.life_still / self.max_life
    local width = percent * 20

    -- draw lifebar
    love.graphics.setColor(1, 0.2, 0.2)
    love.graphics.rectangle("fill", x, y, width, 4, 3)
    love.graphics.setColor(0.05, 0.05, 0.05)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", x, y, 20, 4, 3)
end

return Enemy