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

function Dude:knockback(x, y, force)
    local dx = self.x - x
    local dy = self.y - y
    local dist = math.sqrt(dx * dx + dy * dy)

    if dist > 0 then
        self.spd_x = self.spd_x + dx / dist * force
        self.spd_y = self.spd_y + dy / dist * force
    end
end

function Dude.query_callback(other)
end

function Dude:overlaps(other)
    local dx = self.x - other.x
    local dy = self.y - other.y
    local distance = math.sqrt(dx*dx + dy*dy)
    local overlap = self.radius + other.radius

    return distance < overlap
end

function Dude:query_area(radius)
    local x, y = self.x, self.y
    local radius = radius or self.radius
    local entities = level.entities
    for _, en in ipairs(entities) do
        if en.is_dude and en ~= self then
            if self:overlaps(en) then
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