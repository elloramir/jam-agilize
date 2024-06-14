-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = require("level")
local assets = require("assets")
local Dude = require("entities.dude")
local Obstacle = Dude:extend()

Obstacle.is_obstacle = true

local function random_pos()
    return math.random(0, WIDTH), math.random(0, HEIGHT)
end

function Obstacle:new()
    local x, y = random_pos()

    Obstacle.super.new(self, x, y, 17)
    self:set_image(assets.player_car)
    self:set_order(ORDER_PLAYER)
    self.rotation = math.random() * math.pi * 2

    -- tint with green
    self.color[1] = 0.2
    self.color[2] = 1
    self.color[3] = 0

    while self:overlaps(level.player) do
        self.x, self.y = random_pos()
    end
end

return Obstacle