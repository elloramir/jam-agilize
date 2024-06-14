-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local Dude = require("entities.dude")
local Obstacle = Dude:extend()

Obstacle.is_obstacle = true

function Obstacle:new(x, y)
    Obstacle.super.new(self, x, y, 17)
    self:set_image(assets.player_car)
    self:set_order(ORDER_PLAYER)
    self.rotation = math.random() * math.pi * 2

    -- tint with green
    self.color[1] = 0
    self.color[2] = 0.5
    self.color[3] = 1
end

return Obstacle