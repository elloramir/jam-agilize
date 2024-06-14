-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = require("level")
local Sprite = require("entities/sprite")
local Dude = Sprite:extend()

Dude.is_dude = true

function Dude:new(x, y, radius)
    Dude.super.new(self, x, y)
    self.y_sort = true
    self.radius = radius or 0
    self.spd_x = 0
    self.spd_y = 0
end

function Dude.query_callback(other)
end

function Dude:query_area(radius)
    local x, y = self.x, self.y
    local radius = radius or self.radius
    local entities = level.entities
    for _, en in ipairs(entities) do
        if en.is_dude and en ~= self then
            local dx, dy = en.x - x, en.y - y
            local dist = dx * dx + dy * dy
            local rad = en.radius + radius

            if dist < rad * rad then
                self:query_callback(en)
            end
        end
    end
end

function Dude:debug_draw()
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.circle("line", self.x, self.y, self.radius)
end

return Dude