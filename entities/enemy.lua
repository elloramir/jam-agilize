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
    self.pivot_y = 1
    self.has_died = false
    self.frame = math.random(1, #self.image.quads)
end

function Enemy:kill()
    self.has_died = true
    level.add_entity("blood", self.x, self.y)
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)

    -- todo(ellora): remove, temp
    if self.has_died then
        self.color[4] = 0
    end

    -- look to player
    self.flip_x = level.player.x < self.x

    -- wooble animation
    local wobble = math.sin(self.y * self.x + love.timer.getTime() * 7) * 0.08
    self.scale_y = 1 + wobble
end

return Enemy