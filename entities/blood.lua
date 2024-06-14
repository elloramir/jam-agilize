-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local Sprite = require("entities.sprite")
local Blood = Sprite:extend()

function Blood:new(x, y)
    Blood.super.new(self, x, y, 10)
    self:set_image(assets.blood)
    self:set_order(ORDER_PLAYER - 0.3)
    self.y_sort = true
    self.frame = math.random(1, #self.image.quads)
    self.scale_x = 0.8
    self.scale_y = 0.5
end

function Blood:update(dt)
    Blood.super.update(self, dt)

    self.scale_x = math.min(self.scale_x + 1 * dt, 2)
    self.scale_y = math.min(self.scale_y + 1 * dt, 2)

    -- fade color
    self.color[4] = self.color[4] - 0.35 * dt
end

return Blood